import 'package:falconclubapp/core/networking/api_constants.dart';
import 'package:falconclubapp/core/networking/media_url.dart';
import 'package:flutter_test/flutter_test.dart';

/// The AI video used to spin forever because a relative path was handed to a
/// network player. [MediaUrl.resolve] is the fix: absolute in, absolute out.
void main() {
  test('an already-absolute https URL is returned unchanged', () {
    const String url = 'https://files.fteet.ai/Videos/HLS/Attempts/x.m3u8';
    expect(MediaUrl.resolve(url), url);
  });

  test('an http URL is left alone too', () {
    const String url = 'http://example.com/a.mp4';
    expect(MediaUrl.resolve(url), url);
  });

  test('a relative path is joined onto the media base', () {
    expect(
      MediaUrl.resolve('Videos/HLS/AI/ed5e9d6f.m3u8'),
      '${ApiConstants.mediaBaseUrl}Videos/HLS/AI/ed5e9d6f.m3u8',
    );
  });

  test('a leading slash does not produce a double slash', () {
    expect(
      MediaUrl.resolve('/Videos/HLS/AI/x.m3u8'),
      '${ApiConstants.mediaBaseUrl}Videos/HLS/AI/x.m3u8',
    );
  });

  test('null and blank resolve to null, so callers can show a real state', () {
    expect(MediaUrl.resolve(null), isNull);
    expect(MediaUrl.resolve(''), isNull);
    expect(MediaUrl.resolve('   '), isNull);
  });
}
