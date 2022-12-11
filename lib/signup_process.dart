import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/widgets/common_widgets.dart';

import '../themes.dart';
import 'Upload_photo.dart';
import 'Upload_photo_preview.dart';
import 'models/userData.dart';

class Signup_process extends StatefulWidget {
  const Signup_process({Key? key}) : super(key: key);

  @override
  State<Signup_process> createState() => _Signup_processState();
}

class _Signup_processState extends State<Signup_process> {
  @override
  Widget build(BuildContext context) {
    TextEditingController firstname = new TextEditingController();
    TextEditingController surname = new TextEditingController();
    TextEditingController mobile = new TextEditingController();
    TextEditingController address = new TextEditingController();
    var detailPagecontroller = Get.find<DetailPageController>();
    try {
      if (detailPagecontroller.isusermodelinitilize) {
        firstname.text = "${detailPagecontroller.modelforintent!.name}";
        surname.text = "${detailPagecontroller.modelforintent!.surname}";
        mobile.text = "${detailPagecontroller.modelforintent!.mobilenumber}";
        address.text = "${detailPagecontroller.modelforintent!.address}";
      }
    } on Exception catch (e) {
    }

    final _formKeysignupprocess = GlobalKey<FormState>();

    bool loading = false;

    return SafeArea(
      child: Scaffold(
          backgroundColor: MyThemes.darkblack,
          body: Form(
            key: _formKeysignupprocess,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: SvgPicture.asset(
                        "assets/backorange.svg",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text(
                        "Fill in your bio to get",
                        style: TextStyle(
                            color: MyThemes.txtwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text(
                        "started",
                        style: TextStyle(
                            color: MyThemes.txtwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 15, 0, 0),
                      child: Text(
                        "This data will be displayed in your account",
                        style: TextStyle(
                          color: MyThemes.txtwhite,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 3, 0, 0),
                      child: Text(
                        "profile for security",
                        style: TextStyle(
                          color: MyThemes.txtwhite,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "FirstName can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: firstname,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "FirstName",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "LastName can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: surname,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "LastName",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Address can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: address,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Address",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Mobile Number can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: mobile,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Mobile Number",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    loading
                        ? CircularProgressIndicator()
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              child: Common_Widget("Next"),
                              onTap: () async {
                                if (_formKeysignupprocess.currentState!
                                    .validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (detailPagecontroller
                                      .modelforintent!.name != "") {
                                    // when user data is already filled
                                    detailPagecontroller.modelforintent = new Usermodel(
                                        uid:
                                            "${detailPagecontroller.modelforintent!.uid}",
                                        name:
                                            "${firstname.text}",
                                        surname:
                                            "${surname.text}",
                                        email:
                                            "${detailPagecontroller.modelforintent!.email}",
                                        mobilenumber:
                                            "${mobile.text}",
                                        address:
                                            "${address.text}",
                                        photo:
                                            "${detailPagecontroller.modelforintent!.photo}");

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Upload_Photo_preview(
                                                    null,
                                                    null,
                                                    detailPagecontroller
                                                        .modelforintent!
                                                        .photo)));
                                  } else {
                                    // when new user
                                    detailPagecontroller.modelforintent =
                                        new Usermodel(
                                            uid: "",
                                            name: firstname.text,
                                            surname: surname.text,
                                            email: "",
                                            mobilenumber: mobile.text,
                                            address: address.text,
                                            photo: "");

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Upload_Photo()));
                                  }
                                }
                              },
                            )),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
