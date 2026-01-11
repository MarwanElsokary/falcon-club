import UIKit
import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var preloaderChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController

        // ✅ Factory للفيديوهات
        let factory = NativeVideoViewFactory(messenger: controller.binaryMessenger)
        registrar(forPlugin: "native-video-view")?.register(factory, withId: "native-video-view")

        // ✅ Global Preloader Channel
        preloaderChannel = FlutterMethodChannel(name: "video-preloader", binaryMessenger: controller.binaryMessenger)
        preloaderChannel?.setMethodCallHandler(handlePreload)

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func handlePreload(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "preload":
            if let args = call.arguments as? [String: Any],
               let urls = args["urls"] as? [String],
               let currentIndex = args["currentIndex"] as? Int {
                VideoPreloader.shared.preload(urls: urls, currentIndex: currentIndex)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

// MARK: - Native Video View Factory
class NativeVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return NativeVideoView(frame: frame, viewId: viewId, args: args, messenger: messenger)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}

// MARK: - Native Video View
class NativeVideoView: NSObject, FlutterPlatformView {
    private var containerView: UIView
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var viewId: Int64
    private var channel: FlutterMethodChannel
    private var resizeTimer: Timer?
    private var loadingIndicator: UIActivityIndicatorView?
    private var currentUrl: String?

    init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        containerView = UIView(frame: frame)
        self.viewId = viewId
        self.channel = FlutterMethodChannel(name: "native-video-view-\(viewId)", binaryMessenger: messenger)
        super.init()
        setupView(args: args)
        channel.setMethodCallHandler(handle)
    }

    func view() -> UIView { containerView }

    private func setupView(args: Any?) {
        guard let dict = args as? [String: Any],
              let urlString = dict["url"] as? String,
              let url = URL(string: urlString)
        else { return }

        currentUrl = urlString
        setupPlayer(url: url, urlString: urlString)
    }

    private func setupPlayer(url: URL, urlString: String) {
        removeObservers()
        player?.pause()

        // 🔥 استخدام الـ cache من الـ VideoPreloader
        let asset = VideoPreloader.shared.getAsset(for: urlString) ?? AVURLAsset(url: url)
        
        // 🆕 تخزين الـ asset في الـ cache
        VideoPreloader.shared.cacheAsset(asset, for: urlString)
        
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)

        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = containerView.bounds
        if let layer = playerLayer { containerView.layer.addSublayer(layer) }

        // ✅ Loading spinner
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.center = containerView.center
        spinner.startAnimating()
        containerView.addSubview(spinner)
        loadingIndicator = spinner

        // ✅ Observers
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)

        // 🔁 Loop video
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item
        )

        // ✅ Adjust playerLayer
        resizeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            if self.containerView.window != nil {
                self.playerLayer?.frame = self.containerView.bounds
                timer.invalidate()
            }
        }
    }

    @objc private func videoDidEnd(notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
        print("🔁 Video looped")
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "play":
            player?.play()
            result(nil)
        case "pause":
            player?.pause()
            result(nil)
        case "setVolume":
            if let args = call.arguments as? [String: Any],
               let muted = args["muted"] as? Bool {
                player?.isMuted = muted
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Observers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = object as? AVPlayerItem else { return }

        if keyPath == "status", item.status == .failed {
            print("❌ Video failed to load")
        } else if keyPath == "playbackLikelyToKeepUp" {
            DispatchQueue.main.async {
                if item.isPlaybackLikelyToKeepUp {
                    self.loadingIndicator?.stopAnimating()
                    self.loadingIndicator?.removeFromSuperview()
                    print("✅ Video ready, spinner hidden")
                } else {
                    self.loadingIndicator?.startAnimating()
                    print("🔄 Buffering…")
                }
            }
        }
    }

    private func removeObservers() {
        if let item = player?.currentItem {
            item.removeObserver(self, forKeyPath: "status", context: nil)
            item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
            item.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    deinit {
        removeObservers()
        NotificationCenter.default.removeObserver(self)
        resizeTimer?.invalidate()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        loadingIndicator?.removeFromSuperview()
        print("🧹 NativeVideoView deinitialized (cache preserved)")
    }
}

// MARK: - Enhanced Video Preloader with Persistent Cache
class VideoPreloader {
    static let shared = VideoPreloader()
    
    // 🔥 Cache دائم لكل الفيديوهات - زودناه ل 100 فيديو عشان ما يمسحش بسرعة
    private var persistentCache: [String: AVURLAsset] = [:]
    private var preloadQueue = DispatchQueue(label: "video.preload.queue", qos: .userInitiated)
    private let maxCacheSize = 100 // 🔥 زودناه من 50 ل 100 عشان يحفظ فيديوهات أكتر
    private var cacheOrder: [String] = []

    private init() {
        // 🆕 Configure URLCache لزيادة الـ memory
        let memoryCapacity = 300 * 1024 * 1024 // 300 MB (زودناه)
        let diskCapacity = 1024 * 1024 * 1024 // 1 GB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
        URLCache.shared = cache
        
        print("💾 Video cache initialized: \(memoryCapacity / 1024 / 1024) MB memory, \(diskCapacity / 1024 / 1024) MB disk")
    }

    // 🆕 استرجاع asset من الـ cache
    func getAsset(for url: String) -> AVURLAsset? {
        if let cached = persistentCache[url] {
            print("✅ Using cached asset: \(url)")
            return cached
        }
        return nil
    }
    
    // 🆕 تخزين asset في الـ cache
    func cacheAsset(_ asset: AVURLAsset, for url: String) {
        // إذا كان موجود، نحذفه من الترتيب القديم
        if let index = cacheOrder.firstIndex(of: url) {
            cacheOrder.remove(at: index)
        }
        
        // إضافة للآخر (الأحدث)
        cacheOrder.append(url)
        persistentCache[url] = asset
        
        // 🧹 تنظيف الـ cache إذا تجاوز الحد الأقصى (FIFO)
        if cacheOrder.count > maxCacheSize {
            let oldestUrl = cacheOrder.removeFirst()
            persistentCache.removeValue(forKey: oldestUrl)
            print("🧹 Removed oldest video from cache: \(oldestUrl) (limit: \(maxCacheSize))")
        }
        
        print("💾 Cached asset: \(url) (total: \(persistentCache.count)/\(maxCacheSize))")
    }

    func preload(urls: [String], currentIndex: Int) {
        guard currentIndex < urls.count else { return }

        preloadQueue.async { [weak self] in
            guard let self = self else { return }
            
            // 🔥 تحميل الفيديو الحالي أولاً
            let currentUrl = urls[currentIndex]
            if self.persistentCache[currentUrl] == nil {
                self.preloadVideo(url: currentUrl, label: "CURRENT")
            }
            
            // 🔥 تحميل الفيديو التالي
            let nextIndex = currentIndex + 1
            if nextIndex < urls.count, self.persistentCache[urls[nextIndex]] == nil {
                self.preloadVideo(url: urls[nextIndex], label: "NEXT")
            }
            
            // 🔥 تحميل الفيديو اللي بعده
            let afterNextIndex = currentIndex + 2
            if afterNextIndex < urls.count, self.persistentCache[urls[afterNextIndex]] == nil {
                self.preloadVideo(url: urls[afterNextIndex], label: "NEXT+1")
            }
            
            // 🆕 تحميل الفيديو السابق
            let prevIndex = currentIndex - 1
            if prevIndex >= 0, self.persistentCache[urls[prevIndex]] == nil {
                self.preloadVideo(url: urls[prevIndex], label: "PREV")
            }
            
            // 🆕 تحميل الفيديو قبل السابق
            let beforePrevIndex = currentIndex - 2
            if beforePrevIndex >= 0, self.persistentCache[urls[beforePrevIndex]] == nil {
                self.preloadVideo(url: urls[beforePrevIndex], label: "PREV-1")
            }
        }
    }

    private func preloadVideo(url: String, label: String) {
        guard let videoUrl = URL(string: url) else { return }
        
        let asset = AVURLAsset(url: videoUrl, options: [
            AVURLAssetPreferPreciseDurationAndTimingKey: false
        ])
        
        // 🆕 تخزين في الـ cache فوراً
        cacheAsset(asset, for: url)
        
        // تحميل البيانات الأساسية
        asset.loadValuesAsynchronously(forKeys: ["playable", "duration", "tracks"]) { [weak self] in
            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            
            if status == .loaded {
                print("⚡ Preloaded video [\(label)]: \(url)")
            } else if let error = error {
                print("❌ Failed to preload [\(label)]: \(url) - \(error.localizedDescription)")
                self?.persistentCache.removeValue(forKey: url)
            }
        }
    }
    
    // 🆕 دالة لمعرفة حجم الـ cache
    func getCacheInfo() -> (count: Int, maxSize: Int) {
        return (persistentCache.count, maxCacheSize)
    }
    
    // 🆕 دالة لحذف cache معين (اختياري)
    func removeFromCache(url: String) {
        persistentCache.removeValue(forKey: url)
        if let index = cacheOrder.firstIndex(of: url) {
            cacheOrder.remove(at: index)
        }
        print("🗑️ Removed from cache: \(url)")
    }
}