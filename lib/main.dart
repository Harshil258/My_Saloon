import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_saloon/LoginPage.dart';
import 'package:my_saloon/Register.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/util/routes.dart';
import 'package:my_saloon/widgets/detail_page.dart';

import 'MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Saloon',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: MyThemes.darkblack,
          primarySwatch: MyThemes.darkblack,
          textTheme: Theme.of(context).textTheme.apply(
              displayColor: MyThemes.txtwhite,
              bodyColor: MyThemes.txtwhite,
              fontFamily: GoogleFonts.poppins().fontFamily,
          ),
      ),
      // home: LoginPage(),
      routes: {
        "/": (context) => MyHomePage(),
        Routes.homedetail: (context) => MyHomePage(),
        Routes.register: (context) => Register(),
      },
    );
  }
}
