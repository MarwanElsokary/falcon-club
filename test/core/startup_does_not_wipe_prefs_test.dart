import 'dart:convert';
import 'dart:io';

import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `main()` used to call `CacheHelper.clearDataCache()` on every cold start.
///
/// It wiped the whole of SharedPreferences and restored a hand-maintained list
/// of five keys, so everything else was destroyed each launch: the locale
/// `easy_localization` persists, `myProfile` (which entitlement is derived
/// from), the `exercise.*` TimedCache entries, and the `categories` /
/// `home_trials` fallbacks.
///
/// Two guards here, because the risk has two halves:
///  1. the function really is destructive — proven, not assumed;
///  2. startup does not call it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Keys that must survive a restart. Named literally rather than imported so
  /// that renaming a constant cannot quietly narrow what this protects.
  const Map<String, String> survivesRestart = <String, String>{
    'locale': 'en', // easy_localization's own key
    'myProfile': '{"data":{}}', // entitlement is derived from this
    'exercise.details.42': '{"savedAt":0}', // TimedCache entry
    'categories': '[]',
    'home_trials': '[]',
  };

  group('CacheHelper.clearDataCache', () {
    test('is genuinely destructive — this is why startup must not call it', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        ...survivesRestart,
        'userToken': 'tok', // on the preserve-list
      });
      await CacheHelper.init();

      await CacheHelper.clearDataCache();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // The preserved key comes back...
      expect(prefs.getString('userToken'), 'tok');
      // ...and everything else is gone. If this ever starts failing, the
      // function became safe and these guards can be revisited.
      for (final String key in survivesRestart.keys) {
        expect(
          prefs.getString(key),
          isNull,
          reason: '$key survived clearDataCache — expected it to be destroyed',
        );
      }
    });
  });

  test('startup does not wipe preferences', () {
    // A source-level guard: the hazard is re-introducing the call, which no
    // runtime assertion inside main() can catch from a unit test.
    final String source = File('lib/main.dart').readAsStringSync();

    final Iterable<String> activeCalls = const LineSplitter()
        .convert(source)
        .map((String line) => line.trim())
        .where((String line) => !line.startsWith('//'))
        .where((String line) => line.contains('clearDataCache'));

    expect(
      activeCalls,
      isEmpty,
      reason:
          'main.dart calls clearDataCache() again. That wipes the persisted '
          'locale, myProfile (entitlement), the exercise TimedCache and the '
          'categories/home_trials fallbacks on every launch. Clear specific '
          'keys instead — logout already does exactly that.',
    );
  });
}
