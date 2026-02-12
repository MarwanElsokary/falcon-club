import 'dart:async';
import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

/// 🔗 Deep Link Handler
/// مسؤول عن معالجة الروابط العميقة للتطبيق
class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  /// Initialize deep link handling
  Future<void> initialize({
    required BuildContext context,
    required Function(String reelId) onReelDeepLink,
  }) async {
    try {
      // Handle initial link (when app is opened from terminated state)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        log('🔗 Initial Deep Link: $initialUri');
        _handleDeepLink(initialUri, onReelDeepLink);
      }

      // Handle links while app is running
      _linkSubscription = _appLinks.uriLinkStream.listen(
            (uri) {
          log('🔗 Deep Link Received: $uri');
          _handleDeepLink(uri, onReelDeepLink);
        },
        onError: (err) {
          log('❌ Deep Link Error: $err');
        },
      );

      log('✅ Deep Link Handler Initialized');
    } catch (e) {
      log('❌ Failed to initialize deep links: $e');
    }
  }

  /// Handle incoming deep link
  void _handleDeepLink(Uri uri, Function(String reelId) onReelDeepLink) {
    log('🔍 Processing Deep Link: $uri');
    log('   Scheme: ${uri.scheme}');
    log('   Host: ${uri.host}');
    log('   Path: ${uri.path}');

    // Handle both custom scheme (fteet://) and universal links (https://falconai.net)
    if (uri.scheme == 'fteet' || uri.host == 'falconai.net' || uri.host == 'www.falconai.net') {
      // Extract reel ID from path
      // Examples:
      // fteet://reel/123
      // https://falconai.net/reel/123
      final pathSegments = uri.pathSegments;

      if (pathSegments.isNotEmpty && pathSegments[0] == 'reel') {
        if (pathSegments.length > 1) {
          final reelId = pathSegments[1];
          log('✅ Reel Deep Link Detected - ID: $reelId');
          onReelDeepLink(reelId);
        } else {
          log('⚠️ Reel ID missing in deep link');
        }
      } else {
        log('⚠️ Unknown deep link path: ${uri.path}');
      }
    } else {
      log('⚠️ Unknown deep link scheme: ${uri.scheme}');
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    log('🗑️ Deep Link Handler Disposed');
  }
}