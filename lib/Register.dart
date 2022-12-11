import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_saloon/services/auth.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/signup_process.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/util/routes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:page_transition/page_transition.dart';

import 'LoginPage.dart';
import 'MyHomePage.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool changebutton = false;
  var detailPagecontroller = Get.find<DetailPageController>();

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 50),
                          child: SvgPicture.asset(
                            "assets/login mobile.svg",
                            height: 200,
                          ),
                        ),
                        CustomTextField(
                          id: "ID",
                          hinttxt: "Enter ID you want",
                          icon: Icon(
                            CupertinoIcons.person,
                            color: MyThemes.txtwhite,
                          ),
                          isObscure: false,
                        ),
                        CustomTextField(
                          id: "Password",
                          hinttxt: "Enter PASSWORD you want",
                          icon: Icon(
                            CupertinoIcons.padlock_solid,
                            color: MyThemes.txtwhite,
                          ),
                          isObscure: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Material(
                            color: changebutton
                                ? MyThemes.purple
                                : Colors.transparent,
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: changebutton
                                        ? MyThemes.txtwhite
                                        : MyThemes.purple)),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  User? user =
                                      await Authentication.signInWithGoogle(
                                          context: context);
                                  if (user != null) {
                                    setState(() {
                                      changebutton = true;
                                    });
                                    await Future.delayed(Duration(seconds: 1));
                                    await Navigator.pushNamed(
                                        context, Routes.homedetail);
                                    setState(() {
                                      changebutton = false;
                                    });
                                  }
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
                                    : Text("Register",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder(
                            future: Authentication.initializeFirebase(
                                context: context),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error initializing Firebase');
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Material(
                                    color: changebutton
                                        ? MyThemes.purple
                                        : Colors.transparent,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                            color: changebutton
                                                ? MyThemes.txtwhite
                                                : MyThemes.purple)),
                                    child: InkWell(
                                      onTap: () async {
                                        User? user = await Authentication
                                            .signInWithGoogle(context: context);
                                        if (user != null) {
                                          setState(() {
                                            changebutton = true;
                                          });
                                          await Future.delayed(
                                              Duration(seconds: 1));
                                          await detailPagecontroller
                                              .getuserdata()
                                              .then(
                                            (value) {
                                              print(
                                                  "detailPagecontroller modelforintent : ${detailPagecontroller.modelforintent}");

                                              if (detailPagecontroller
                                                      .modelforintent!.uid !=
                                                  "") {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MyHomePage()));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Signup_process()));
                                              }
                                            },
                                          );

                                          setState(() {
                                            changebutton = false;
                                          });
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                            seconds: 1, milliseconds: 100),
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
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 0, 8, 0),
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
                                );
                              }
                              return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  MyThemes.purple,
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child: InkWell(
                              onTap: () {
                                // Navigator.pushNamed(context, Routes.loginroute);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: LoginPage()));
                              },
                              child: Text(
                                "Want to go Login ??",
                                style: TextStyle(color: MyThemes.txtdarkwhite),
                              )),
                        )
                      ],
                    ),
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
