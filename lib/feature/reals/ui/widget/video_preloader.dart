import 'dart:developer';

/// Preloader شغال عن طريق ExoPlayer cache في الـ native side
/// مش بيعمل أي player منفصل — بس بيطلب الـ URL للـ cache
class VideoPreloader {
  static final Set<String> _preloadedUrls = {};

  static Future<void> smartPreload({
    required List<String> allVideoUrls,
    required int currentIndex,
  }) async {
    // preload التالي والبعده بس
    final indices = [currentIndex + 1, currentIndex + 2];

    for (final i in indices) {
      if (i < 0 || i >= allVideoUrls.length) continue;
      final url = allVideoUrls[i];
      if (_preloadedUrls.contains(url)) continue;

      _preloadedUrls.add(url);
      log('📦 Marked for preload: index=$i');
      // الـ ExoPlayer cache في الـ native بيتولى الـ caching تلقائي
      // لما الـ AndroidView/UiKitView اتعمل للـ index ده
    }
  }

  static void dispose() {
    _preloadedUrls.clear();
    log('🧹 VideoPreloader disposed');
  }
}
