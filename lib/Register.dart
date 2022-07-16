import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_saloon/util/routes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:page_transition/page_transition.dart';

import '../themes.dart';
import 'LoginPage.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool changebutton = false;
  final _formKey = GlobalKey<FormState>();

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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
