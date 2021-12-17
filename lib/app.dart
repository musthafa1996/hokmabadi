import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app_init.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr. Hokmabadi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Colors.black,
          primaryVariant: Colors.black,
          onPrimary: Colors.white,
          secondary: const Color(0xFF1C2340),
          secondaryVariant: const Color(0xFF1C2340),
          onSecondary: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          error: Colors.redAccent.shade400,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          behavior: SnackBarBehavior.floating,
          elevation: 0,
        ),
        shadowColor: Colors.black.withOpacity(0.8),
        scaffoldBackgroundColor: const Color(0xFFf3f3f3),
        indicatorColor: Colors.black,
        hintColor: Colors.grey,
        errorColor: Colors.redAccent[400],
        fontFamily: 'roboto',
        textTheme: TextTheme(
          headline1: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
          headline2: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
          headline3: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
          headline4: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
          headline5: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
          headline6: const TextStyle(fontWeight: FontWeight.w600, height: 1.5),
          bodyText1: TextStyle(color: Colors.grey.shade600, height: 1.4),
          bodyText2: TextStyle(color: Colors.grey.shade600, height: 1.4),
          button: const TextStyle(fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
            minimumSize: MaterialStateProperty.all(const Size(5, 48)),
            elevation: MaterialStateProperty.resolveWith((states) {
              if (states.isEmpty) {
                return 0;
              }
            }),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          // fillColor: AppColors.textFiledFillColor,
          border: InputBorder.none,
          fillColor: const Color(0xFFf3f3f3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
          ),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      builder: (context, child) {
        return ResponsiveWrapper.builder(
          AppInit(child: child ?? const SizedBox()),
          defaultName: PHONE,
          minWidth: 1,
          defaultScale: false,
          breakpoints: [
            const ResponsiveBreakpoint.resize(576, name: MOBILE),
            const ResponsiveBreakpoint.resize(768, name: TABLET),
            const ResponsiveBreakpoint.resize(992, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(1920,
                name: "4K", scaleFactor: 1),
          ],
          background: Container(
            color: Colors.white,
          ),
        );
      },
    ).modular();
  }
}
