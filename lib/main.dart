import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/cache/cach_Helper.dart';
import 'core/di/dependency_injection.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/security/session_expiry_listener.dart';
import 'core/thems/thems.dart';
import 'feature/home/ui/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await CacheHelper.init();
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  EasyLocalization.logger.enableBuildModes = [];

  // `CacheHelper.clearDataCache()` used to run here, on every cold start. It
  // wiped the whole of SharedPreferences and then restored a hand-maintained
  // list of five keys, so everything else the app persists was destroyed each
  // launch:
  //
  //   * the locale `easy_localization` saves — `ensureInitialized()` above had
  //     already read it into memory, so the current launch looked right and the
  //     *next* one fell back to `startLocale`. A language choice survived
  //     exactly one restart.
  //   * `myProfile`, which `CachedSubscriptionReader` derives entitlement from —
  //     so a paying user started every launch as `Subscription.none` until a
  //     profile fetch landed, and could be shown a paywall in the meantime.
  //   * the `exercise.*` TimedCache entries, wiped before their TTL could ever
  //     be read — the cache was dead on arrival.
  //   * `categories` and `home_trials`, so those prefs-cache fallbacks could
  //     never serve a cold start.
  //
  // The preserve-list had been grown reactively (its last two entries are marked
  // `// ✅ أضف ده`), which is the signature of a blunt instrument being patched
  // each time it broke something — and it would have silently broken the next
  // thing anyone stored. Signing out clears the user's data by name; nothing
  // needs a per-launch wipe.

  // Clean Architecture container first: it owns Dio and ApiService, which the
  // legacy registrations below resolve from the same GetIt instance.
  await configureDependencies();
  await setupGetIt();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: Phoenix(child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        // Above MaterialApp so it outlives every route: a session can die while
        // any screen is open.
        child: SessionExpiryListener(
          child: MaterialApp(
            scrollBehavior: NoGlowScrollBehavior(),
            title: 'Fteet AI Club',
            debugShowCheckedModeBanner: false,
            // Lets the Dio interceptors reach a navigator without a context.
            navigatorKey: appNavigatorKey,
            theme: themsApp.light,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: const Locale('ar'),
            onGenerateRoute: (settings) {
              final appRouter = AppRouter();
              return appRouter.generateRoute(settings);
            },
          ),
        ),
      ),
    );
  }
}
