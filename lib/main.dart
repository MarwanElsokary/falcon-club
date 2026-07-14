import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/cache/cach_Helper.dart';
import 'core/di/dependency_injection.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
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

  await CacheHelper.clearDataCache();

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
        child: MaterialApp(
          scrollBehavior: NoGlowScrollBehavior(),
          title: 'Fteet AI Club',
          debugShowCheckedModeBanner: false,
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
    );
  }
}
