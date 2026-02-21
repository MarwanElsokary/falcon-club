import 'dart:developer';
import 'package:flutter/services.dart';

/// 📥 Video Preloader
/// مسؤول عن التحميل المسبق للفيديوهات
class VideoPreloader {
  static const _channel = MethodChannel('video-preloader');

  /// تحميل مسبق ذكي (الحالي + السابق + التالي)
  static Future<void> smartPreload({
    required List<String> allVideoUrls,
    required int currentIndex,
  }) async {
    try {
      final preloadIndices = _getPreloadIndices(currentIndex, allVideoUrls.length);

      final urls = preloadIndices
          .where((i) => i >= 0 && i < allVideoUrls.length)
          .map((i) => allVideoUrls[i])
          .toList();

      await _channel.invokeMethod('preload', {
        'urls': urls,
        'currentIndex': currentIndex,
      });

      log('📥 Preloading ${urls.length} videos around index $currentIndex');
    } catch (e) {
      log('⚠️ Preload error: $e');
    }
  }

  /// حساب الـ indices المطلوب تحميلها
  static List<int> _getPreloadIndices(int currentIndex, int totalCount) {
    final indices = <int>[];

    // السابق
    if (currentIndex > 0) {
      indices.add(currentIndex - 1);
    }

    // الحالي
    indices.add(currentIndex);

    // التالي
    if (currentIndex < totalCount - 1) {
      indices.add(currentIndex + 1);
    }

    return indices;
  }

  /// إلغاء كل التحميلات
  static Future<void> cancelAll() async {
    try {
      await _channel.invokeMethod('cancelAll');
      log('🚫 All preloads cancelled');
    } catch (e) {
      log('⚠️ Cancel preload error: $e');
    }
  }
}