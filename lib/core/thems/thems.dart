import 'package:flutter/material.dart';

const Color mainColor = Color(0xFF5D2BF4); //background: #4D63EE;

const Color fillColor = Color(0xFFEBEBFD); //background: #;

const Color blueColor = Color(0xFF2664B1);
const Color redAndOrangeColor = Color(0xFFF4827E);
const Color redColor = Color(0xFFC9000C); //background: #;

const Color secondMainColor = Color(0xFF31187D); //Color()

const Color whiteBlueColor = Color(
  0xFFE6F4FF,
); //background: var(--color-yellow-warning-yellow-500, #FFAA00);

const Color fesfourColor = Color(0xFFD7FA78);

const Color blackmainColor = Color(0xFF0E0E0E);

const Color primaryClr = Color(0xFFE6F6F4); //#

const Color secondPrimaryClr = Color(0xFFD7FA78);

const Color darkmainColor = Color(0xFF212428); //##
const Color whiteclr = Color(0xFFFAFAFA); //#
const Color primerymainColor = Color(0xFFE4E4FB); //background: #008774;

const Color orangeClr = Color(0xFFF98600); //background: #;

const Color greenSoftClr = Color(0xFFE2F8E3); //#
const Color blackclr = Color(0xFF666666); //background: #3E3E3E;
const Color blackcolor = Color(0xFF3E3E3E); //background: #

const Color darkclr = Color(0xFF212428); //##212428
const Color darkblackclr = Color(0xFF151617); //#151617
const Color redClr = Color(0xFFF44336); //background: #;

const Color mainOpactyColor = Color(0xFFFF979B);
const Color dark = Color(0xFF282828);
const Color yellowclr = Color(0xFFFFF9E5); //#background: #;

const Color greyClr = Color(0xFFC9C9C9); //background: #;
const Color greyClr2 = Color(0xFF424242); //background: #;

const Color starGreyClr = Color(0xFFB0BEC5);

const Color greyopacutyClr = Color(0xFFF1F5F9);
const Color offWhiteClr = Color(0xFFF5F6FA); //background: #;

const Color offGreenClr = Color(0xFFF4F7EF);

const Color darkGreyClr = Color(0xFFFFFFFF);

const Color greenClr = Color(0xFF22B295); //background: #;

const Color softGreenClr = Color(0xFFEBF7EB); //background: #;

const Color recGreyClr = Color(0xFFEB001B);

const Color blueOpacityClr = Color(0xFF5486E9);
const Color blueClr = Color(0xFF0A185D); //background: #;

const Color pinkClr = Color(0xFF401693); //background: #;

const Color pink2Clr = Color(0xFF7456B7);
const Color callClr = Color(0xFFF5EFFF);
const Color orngClr = Color(0xFFFF9F29);
const Color scendrycolor = Color(0xFFFFF0C2);
const Color kCOlor4 = Color(0xff738B71);
const Color kCOlor5 = Color(0xff9A22B2); //background: #;

const Color darkSettings = Color(0xff6138e4);
const Color accountSettings = Color(0xff73bc65);
const Color logOutSettings = Color(0xff5f95ef);
const Color notiSetting = Color(0xffdf5862);
const Color languageSettings = Color(0xffCB256C);

///

ThemeData lightMood = ThemeData(
  scaffoldBackgroundColor: whiteclr,
  useMaterial3: true,
  colorScheme: lightColorScheme,
);
ThemeData DarkMood = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkblackclr,
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: mainColor,
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFEADDFF),
  onPrimaryContainer: Color(0xFF21005D),
  secondary: Color(0xFF625B71),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE8DEF8),
  onSecondaryContainer: Color(0xFF1D192B),
  tertiary: Color(0xFF7D5260),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD8E4),
  onTertiaryContainer: Color(0xFF31111D),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),
  outline: Color(0xFF79747E),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
  surfaceContainerHighest: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  inverseSurface: Color(0xFF313033),
  onInverseSurface: Color(0xFFF4EFF4),
  inversePrimary: Color(0xFFD0BCFF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF6750A4),
  outlineVariant: Color(0xFFCAC4D0),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: mainColor,
  onPrimary: mainColor,
  primaryContainer: Color(0xFF4F378B),
  onPrimaryContainer: Color(0xFFEADDFF),
  secondary: Color(0xFFCCC2DC),
  onSecondary: Color(0xFF332D41),
  secondaryContainer: Color(0xFF4A4458),
  onSecondaryContainer: Color(0xFFE8DEF8),
  tertiary: Color(0xFFEFB8C8),
  onTertiary: Color(0xFF492532),
  tertiaryContainer: Color(0xFF633B48),
  onTertiaryContainer: Color(0xFFFFD8E4),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),
  outline: Color(0xFF938F99),
  surface: Color(0xFF1C1B1F),
  onSurface: Color(0xFFE6E1E5),
  surfaceContainerHighest: Color(0xFF49454F),
  onSurfaceVariant: Color(0xFFCAC4D0),
  inverseSurface: Color(0xFFE6E1E5),
  onInverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFF6750A4),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFD0BCFF),
  outlineVariant: Color(0xFF49454F),
  scrim: Color(0xFF000000),
);

// ignore: camel_case_types
class themsApp {
  static final light = ThemeData(
    scaffoldBackgroundColor: whiteclr,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteclr,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
    primaryColor: mainColor,
    hintColor: mainColor,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    scaffoldBackgroundColor: whiteclr,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}
