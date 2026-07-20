package com.falconclubapp.ai

import android.content.Context
import android.util.Log
import android.view.Gravity
import android.view.TextureView
import android.view.View
import android.widget.FrameLayout
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.PlaybackException
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.source.DefaultMediaSourceFactory
import com.google.android.exoplayer2.ui.AspectRatioFrameLayout
import com.google.android.exoplayer2.upstream.DefaultHttpDataSource
import com.google.android.exoplayer2.upstream.cache.CacheDataSource
import com.google.android.exoplayer2.video.VideoSize
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

private const val TAG = "NativeVideoView"

/**
 * Creates the native surface behind the reels feed.
 *
 * Registered in [MainActivity] under the view type `native-video-view`, which is
 * the same string the Dart side passes to `AndroidView(viewType: ...)`.
 */
class NativeVideoFactory(
    private val messenger: BinaryMessenger,
    private val appContext: Context,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        @Suppress("UNCHECKED_CAST")
        val params = args as? Map<String, Any?> ?: emptyMap()
        return NativeVideoView(context ?: appContext, messenger, viewId, params)
    }
}

/**
 * One ExoPlayer bound to one Flutter platform view.
 *
 * ## Why a TextureView and not PlayerView
 *
 * The Dart side embeds this with `AndroidView`, i.e. virtual-display mode.
 * ExoPlayer's `StyledPlayerView` renders into a `SurfaceView` by default, and a
 * SurfaceView on a virtual display draws nothing — the control calls all
 * succeed, the player really is playing, and the user sees a black rectangle.
 * Rendering into a `TextureView` is composited normally and works in that mode.
 *
 * ## Contract with Dart
 *
 * `VideoPlayerManager` opens `MethodChannel("native-video-view-$viewId")` using
 * the id handed to `onPlatformViewCreated`, and sends exactly three methods:
 * `play`, `pause`, and `setVolume` with a boolean `muted` argument. Anything
 * else is answered with `notImplemented` rather than silently ignored.
 */
class NativeVideoView(
    context: Context,
    messenger: BinaryMessenger,
    private val viewId: Int,
    params: Map<String, Any?>,
) : PlatformView, MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(messenger, "native-video-view-$viewId")

    // Fills the whole platform view and centres [frame] inside it.
    private val root = FrameLayout(context)
    private val frame = AspectRatioFrameLayout(context)
    private val textureView = TextureView(context)
    private var player: ExoPlayer? = null

    init {
        channel.setMethodCallHandler(this)

        // FIT, not ZOOM: ZOOM fills the reel frame by scaling until both axes
        // are covered, which crops whatever overflows. FIT keeps the video at
        // its true proportions inside the frame, letterboxing instead of
        // cropping — matching the reference app.
        frame.resizeMode = AspectRatioFrameLayout.RESIZE_MODE_FIT
        frame.addView(
            textureView,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
            ),
        )

        // RESIZE_MODE_FIT makes AspectRatioFrameLayout shrink its *own* measured
        // size to the video's ratio. As the root view handed to Flutter it had
        // no parent to position it, so it settled at the default top-start and
        // the video sat pinned to the top of the letterboxed area. Wrapping it
        // in a full-size FrameLayout with CENTER gravity splits the leftover
        // space evenly above and below.
        root.addView(
            frame,
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT,
                Gravity.CENTER,
            ),
        )

        val url = params["url"] as? String ?: ""

        // Cached HTTP, shared across every reel view.
        val upstream = DefaultHttpDataSource.Factory()
            .setAllowCrossProtocolRedirects(true)
        val cacheFactory = CacheDataSource.Factory()
            .setCache(VideoCache.getInstance(context))
            .setUpstreamDataSourceFactory(upstream)
            .setFlags(CacheDataSource.FLAG_IGNORE_CACHE_ON_ERROR)

        // DefaultMediaSourceFactory picks the source type from the URL/content
        // type, so an .m3u8 becomes an HlsMediaSource. The previous version
        // hardcoded ProgressiveMediaSource, which forces extractor-based
        // parsing — and no extractor can read an HLS manifest, which is exactly
        // the UnrecognizedInputFormatException that was thrown. The HLS module
        // ships inside the `exoplayer` artifact already on the classpath.
        val exo = ExoPlayer.Builder(context)
            .setMediaSourceFactory(DefaultMediaSourceFactory(cacheFactory))
            .build()
        player = exo

        exo.setVideoTextureView(textureView)
        exo.repeatMode = Player.REPEAT_MODE_ONE
        // Dart owns playback; never autostart, or every off-screen page in the
        // PageView would play at once.
        exo.playWhenReady = false
        exo.volume = 1f

        exo.addListener(object : Player.Listener {
            override fun onVideoSizeChanged(videoSize: VideoSize) {
                if (videoSize.height > 0) {
                    frame.setAspectRatio(
                        videoSize.width * videoSize.pixelWidthHeightRatio / videoSize.height
                    )
                }
            }

            // Without this a bad URL or codec failure is completely silent:
            // Dart's icon state flips, nothing plays, and nothing is logged.
            override fun onPlayerError(error: PlaybackException) {
                Log.e(TAG, "[$viewId] playback error: ${error.errorCodeName}", error)
            }
        })

        if (url.isEmpty()) {
            Log.w(TAG, "[$viewId] created with an empty url — nothing to play")
        } else {
            try {
                // Let the factory above resolve HLS vs progressive.
                exo.setMediaItem(MediaItem.fromUri(url))
                exo.prepare()
            } catch (t: Throwable) {
                Log.e(TAG, "[$viewId] failed to prepare $url", t)
            }
        }
    }

    override fun getView(): View = root

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val exo = player
        if (exo == null) {
            // The view was disposed while a call was in flight. Report it rather
            // than succeeding silently, so Dart never shows a state the native
            // side is not actually in.
            result.error("disposed", "Player for view $viewId is disposed", null)
            return
        }

        when (call.method) {
            "play" -> {
                exo.playWhenReady = true
                result.success(null)
            }

            "pause" -> {
                exo.playWhenReady = false
                result.success(null)
            }

            "setVolume" -> {
                val muted = call.argument<Boolean>("muted") ?: false
                exo.volume = if (muted) 0f else 1f
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    override fun dispose() {
        channel.setMethodCallHandler(null)
        player?.let {
            it.playWhenReady = false
            it.clearVideoTextureView(textureView)
            it.release()
        }
        player = null
        frame.removeAllViews()
        root.removeAllViews()
    }
}
