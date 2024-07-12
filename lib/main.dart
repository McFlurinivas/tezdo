import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tezdo/model/colors.dart';
import 'package:tezdo/model/l10n.dart';
import 'package:tezdo/model/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FakeStoreApi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.transparent,
          cursorColor: FSColors.purple,
          selectionHandleColor: FSColors.purple,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.transparent,
          elevation: 0,
          actionsIconTheme: IconThemeData(
            color: FSColors.purple,
          ),
          iconTheme: IconThemeData(
            color: FSColors.purple,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
          displayLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 30,
            color: FSColors.purple,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            color: FSColors.purple,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        hintColor: Colors.black,
        shadowColor: FSColors.purple,
        focusColor: FSColors.purple,
        inputDecorationTheme: const InputDecorationTheme(
          focusColor: FSColors.purple,
          labelStyle: TextStyle(
            fontSize: 20,
            color: FSColors.purple,
          ),
          // border: InputBorder.none,
          // disabledBorder: InputBorder.none,
          // enabledBorder: InputBorder.none,
          // focusedBorder: InputBorder.none,
          // errorBorder: InputBorder.none,
          // focusedErrorBorder: InputBorder.none,
          iconColor: FSColors.purple,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: FSColors.purple,
            shadowColor: FSColors.purple,
            side: const BorderSide(
              color: FSColors.purple,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: FSColors.purple,
        ),
        iconTheme: const IconThemeData(
          color: FSColors.purple,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: FSColors.purple,
        ),
      ),
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      initialRoute: '/',
      getPages: routes,
    );
  }
}
