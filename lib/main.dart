import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_saloon/Register.dart';
import 'package:my_saloon/profile.dart';
import 'package:my_saloon/services/initclass.dart';
import 'package:my_saloon/signup_process.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/util/routes.dart';

import 'MyHomePage.dart';
import 'Upload_photo.dart';
import 'Upload_photo_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCD2SG1HdAaFGtheNmgKyU6mBbiE6mQB8o",
      appId: "1:572332114039:android:19e053b6753276e3d20672",
      messagingSenderId: "572332114039",
      projectId: "my-saloon-86728",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Widget first;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      first = MyHomePage();
    } else {
      first =  Register();
    }

    return GetMaterialApp(
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
        "/": (context) => first,
        Routes.homedetail: (context) => MyHomePage(),
        Routes.register: (context) => Register(),
        Routes.Uploadphoto: (context) => Upload_Photo(),
      },
    );
  }
}
