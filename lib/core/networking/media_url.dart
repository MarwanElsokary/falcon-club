import 'api_constants.dart';

/// Turns whatever the backend puts in a media field into something a player or
/// image widget can actually load — or `null` when there is nothing usable.
///
/// The backend is inconsistent: `photoPath` and an attempt's raw `video` come
/// back **absolute** (`https://files.fteet.ai/…`), while an attempt's `aiVideo`
/// comes back **relative** (`Videos/HLS/AI/….m3u8`). Feeding a relative path to
/// `VideoPlayerController.networkUrl` never initialises, which is exactly why the
/// AI-analysis video sat on its loading spinner forever. Resolving here means the
/// widgets receive one shape — an absolute URL — and never have to know which
/// field carried which.
abstract final class MediaUrl {
  const MediaUrl._();

  /// Resolves [raw] to an absolute `http(s)` URL.
  ///
  /// - Empty/null → `null` (so callers can show a real "no video" state instead
  ///   of handing an empty string to a player that will spin indefinitely).
  /// - Already absolute `http(s)` → returned unchanged.
  /// - Anything else (a relative path) → joined onto [ApiConstants.mediaBaseUrl].
  static String? resolve(String? raw) {
    if (raw == null) return null;
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final Uri? parsed = Uri.tryParse(trimmed);
    if (parsed != null && (parsed.scheme == 'http' || parsed.scheme == 'https')) {
      return trimmed;
    }

    final String base = ApiConstants.mediaBaseUrl; // ends with '/'
    final String path = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return '$base$path';
  }
}
