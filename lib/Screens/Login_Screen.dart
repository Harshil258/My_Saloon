import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_saloon/services/auth.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/Screens/Signup_Process_Screen.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/util/routes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:page_transition/page_transition.dart';

import 'MyHomePage.dart';
import 'Register_Screen.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  bool changebutton = false;
  final _formKey = GlobalKey<FormState>();
  var detailPagecontroller = Get.find<DetailPageController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            color: MyThemes.darkblack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 32),
                  child: Center(
                    child: Text(
                      "Welcome to My Saloon",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 50),
                        child: SvgPicture.asset(
                          "assets/login mobile.svg",
                          height: 250,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Material(
                                color: changebutton
                                    ? MyThemes.purple
                                    : Colors.transparent,
                                // borderRadius: BorderRadius.circular(8),
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: changebutton
                                            ? MyThemes.txtwhite
                                            : MyThemes.purple)),
                                child: InkWell(
                                  onTap: () async {
                                    User? user =
                                        await Authentication.signInWithGoogle(
                                            context: context);
                                    if (user != null) {
                                      setState(() {
                                        changebutton = true;
                                      });
                                      await detailPagecontroller
                                          .getuserdata()
                                          .then((value) async {
                                        await Future.delayed(Duration(seconds: 1));

                                        print(
                                            "detailPagecontroller modelforintent : ${detailPagecontroller.modelforintent!.uid}");

                                        if (detailPagecontroller
                                                .modelforintent!.name !=
                                            "") {
                                          Get.offAll(MyHomePage());
                                        } else {
                                          Get.offAll( Signup_Process_Screen());
                                        }
                                      });

                                      setState(() {
                                        changebutton = false;
                                      });
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration:
                                        Duration(seconds: 1, milliseconds: 100),
                                    width: changebutton ? 150 : 350,
                                    height: changebutton ? 50 : 60,
                                    alignment: Alignment.center,
                                    child: changebutton
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 8, 0),
                                                  child: Image.asset(
                                                      "assets/googleicon.png",
                                                      height: 35,
                                                      fit: BoxFit.cover)),
                                              Text("Sign in with Google",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
                              child: InkWell(
                                  onTap: () {
                                    // Navigator.pushNamed(context, Routes.register);
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.fade,
                                          child: Register_Screen(),
                                        ));
                                  },
                                  child: Text(
                                    "Want to Register ??",
                                    style: TextStyle(color: MyThemes.txtdarkwhite),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
