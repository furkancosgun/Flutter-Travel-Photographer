import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Screens/LoginPage/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple, accentColor: Colors.black),
      fontFamily: GoogleFonts.nunito().fontFamily,
      textTheme: TextTheme(
        headline1: TextStyle(
            color: Colors.white.withOpacity(.9),
            fontSize: 50,
            height: 1.2,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: Colors.white.withOpacity(.9),
            fontSize: 25,
            height: 1.2,
            fontWeight: FontWeight.bold),
        bodyText2: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(.9),
            height: 1.9,
            fontSize: 17),
        bodyText1: TextStyle(
          letterSpacing: 3,
          color: Colors.white.withOpacity(.9),
          height: 1.9,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    home: LoginPage(),
  ));
}
