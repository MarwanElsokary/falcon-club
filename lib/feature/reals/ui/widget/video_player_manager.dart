import 'dart:developer';
import 'package:flutter/services.dart';

/// 🎬 Video Player Manager
/// مسؤول عن إدارة تشغيل/إيقاف الفيديوهات فقط
class VideoPlayerManager {
  // Video Views
  final Map<int, int> _viewIds = {};
  final Map<int, bool> _muted = {};
  final Map<int, bool> _isPlaying = {};
  final Set<int> _initializedViews = {};

  // Getters
  Map<int, int> get viewIds => Map.unmodifiable(_viewIds);

  Map<int, bool> get muted => Map.unmodifiable(_muted);

  Map<int, bool> get isPlaying => Map.unmodifiable(_isPlaying);

  bool isViewInitialized(int index) => _initializedViews.contains(index);

  /// تسجيل View جديد
  void registerView(int index, int viewId) {
    // ✅ امسح الـ guard ده — خليه يسمح بـ re-registration
    // if (_initializedViews.contains(index)) return;  ← احذف السطر ده

    // بدلاً منه:
    if (_viewIds[index] == viewId) return; // نفس الـ view بالظبط = ignore

    _viewIds[index] = viewId;
    _initializedViews.add(index);
    _muted[index] = false;
    _isPlaying[index] = false;

    log('✅ View registered: index=$index, viewId=$viewId');
  }

  /// تشغيل فيديو
  Future<void> playVideo(int index) async {
    if (!_viewIds.containsKey(index)) {
      log('⚠️ View not ready for index $index');
      return;
    }

    try {
      final viewId = _viewIds[index]!;
      final channel = MethodChannel('native-video-view-$viewId');

      await pauseAllExcept(index);

      // ✅ أعد تطبيق الـ mute state قبل التشغيل
      final isMuted = _muted[index] ?? false;
      await channel.invokeMethod('setVolume', {'muted': isMuted});

      await channel.invokeMethod('play');
      _isPlaying[index] = true;

      log('▶️ Playing video at index $index (muted: $isMuted)');
    } catch (e) {
      log('❌ Error playing video $index: $e');
    }
  }

  /// إيقاف فيديو
  Future<void> pauseVideo(int index) async {
    if (!_viewIds.containsKey(index)) return;

    try {
      final viewId = _viewIds[index]!;
      final channel = MethodChannel('native-video-view-$viewId');

      await channel.invokeMethod('pause');
      _isPlaying[index] = false;

      log('⏸️ Paused video at index $index');
    } catch (e) {
      log('❌ Error pausing video $index: $e');
    }
  }

  /// Toggle تشغيل/إيقاف
  Future<void> togglePlay(int index) async {
    if (_isPlaying[index] == true) {
      await pauseVideo(index);
    } else {
      await playVideo(index);
    }
  }

  /// إيقاف كل الفيديوهات ماعدا واحد
  Future<void> pauseAllExcept(int currentIndex) async {
    final playingIndices = Map<int, bool>.from(_isPlaying);

    for (final entry in playingIndices.entries) {
      final index = entry.key;
      if (index == currentIndex) continue;

      // ✅ سواء كان isPlaying أو لأ، لو الـ view موجودة — وقّفها
      // ده بيضمن مفيش حاجة شغالة في الخفاء
      if (_viewIds.containsKey(index)) {
        try {
          final viewId = _viewIds[index]!;
          final channel = MethodChannel('native-video-view-$viewId');
          await channel.invokeMethod('pause');
          _isPlaying[index] = false;
        } catch (e) {
          log('⚠️ Error pausing video $index: $e');
          // ✅ لو فشل الـ channel، اعتبر الـ view stale وامسحها
          _viewIds.remove(index);
          _isPlaying.remove(index);
          _initializedViews.remove(index);
        }
      }
    }
  }

  /// Toggle صوت
  // ✅ الصح
  Future<void> toggleMute(int index) async {
    if (!_viewIds.containsKey(index)) return;

    try {
      final viewId = _viewIds[index]!;
      final channel = MethodChannel('native-video-view-$viewId');

      _muted[index] = !(_muted[index] ?? false); // ✅ toggle صح
      await channel.invokeMethod('setVolume', {'muted': _muted[index]});

      log('🔇 Mute toggled for index $index: ${_muted[index]}');
    } catch (e) {
      log('❌ Error toggling mute $index: $e');
    }
  }

  /// تنظيف الـ Views القديمة
  void cleanupOldViews(int currentIndex) {
    final indicesToRemove = <int>[];
    for (final index in _viewIds.keys) {
      if ((index - currentIndex).abs() > 2) {
        indicesToRemove.add(index);
      }
    }
    for (final index in indicesToRemove) {
      _disposeView(
        index,
      ); // مش لازم await هنا، بس دلوقتي جوها بتستنى pause فعليًا قبل ما تعتبر العملية خلصت
    }
  }

  /// 🔥 تنظيف كل الـ Views (للـ Refresh)
  void cleanupAllViews() {
    // 🔥 حل المشكلة: نسخ المفاتيح قبل الحذف
    final indices = List<int>.from(_viewIds.keys);

    for (final index in indices) {
      _disposeView(index);
    }
    log('🧹 All views cleaned up');
  }

  /// Dispose view واحد
  // في VideoPlayerManager، غيّر _disposeView:
  Future<void> _disposeView(int index) async {
    if (!_viewIds.containsKey(index)) return;

    final viewId = _viewIds[index]!;

    _viewIds.remove(index);
    _isPlaying.remove(index);
    _muted.remove(index);
    _initializedViews.remove(
      index,
    ); // ✅ مهم — اتحذف الـ index عشان يقدر يتسجل تاني

    try {
      final channel = MethodChannel('native-video-view-$viewId');
      await channel
          .invokeMethod('pause')
          .timeout(const Duration(seconds: 2), onTimeout: () => null);
    } catch (e) {
      log('⚠️ Error cleaning view $index: $e');
    }
  }

  /// تهيئة أول 3 فيديوهات
  void initializeFirstVideos(int count) {
    final limit = count < 3 ? count : 3;
    for (int i = 0; i < limit; i++) {
      _muted[i] = false;
      _isPlaying[i] = false;
    }
  }

  /// تهيئة فيديو جديد
  void initializeVideo(int index) {
    if (!_muted.containsKey(index)) {
      _muted[index] = false;
      _isPlaying[index] = false;
    }
  }

  /// تنظيف كل شيء
  void dispose() {
    // 🔥 حل المشكلة: نسخ المفاتيح قبل التعديل
    final entries = List<MapEntry<int, int>>.from(_viewIds.entries);

    for (var entry in entries) {
      // (index intentionally unused — only the viewId is needed to pause)
      final viewId = entry.value;

      try {
        final channel = MethodChannel('native-video-view-$viewId');
        channel.invokeMethod('pause').catchError((e) {
          log('⚠️ Error pausing on cleanup: $e');
        });
      } catch (e) {
        log('⚠️ Error on cleanup: $e');
      }
    }

    _viewIds.clear();
    _isPlaying.clear();
    _muted.clear();
    _initializedViews.clear();

    log('🧹 VideoPlayerManager disposed');
  }
}
