import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/cache/cach_Helper.dart';
import 'core/di/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/thems/thems.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // منع الدوران وخلي التطبيق في الوضع العمودي فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation
        .portraitDown, // اختياري لو عايز يسمح بالوضع العمودي المقلوب
  ]);
  await EasyLocalization.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  await setupGetIt();

  await Future.wait([CacheHelper.init()]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations', // مسار الملفات المترجمة
      fallbackLocale: const Locale('ar'),
      child: Phoenix(child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    EasyLocalization.of(context)!.setLocale(Locale('ar'));
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.transparent,
        ),
        child: MaterialApp(
          title: 'Winner',
          debugShowCheckedModeBanner: false,
          theme: themsApp.light,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: const Locale('ar'),
          // context.locale,
          localeResolutionCallback: (locale, supportedLocales) {
            return locale;
          },
          onGenerateRoute: (settings) {
            final appRouter = AppRouter();
            return appRouter.generateRoute(settings);
          },
        ),
      ),
    );
  }
}
