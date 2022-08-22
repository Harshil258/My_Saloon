import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_saloon/services/auth.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/widgets/common_widgets.dart';

import '../themes.dart';
import 'MyHomePage.dart';
import 'Upload_photo.dart';

class Upload_Photo_preview extends StatefulWidget {
  final PickedFile? image;
  final File? file;
  final String? link;

  const Upload_Photo_preview(this.image, this.file, this.link, {Key? key})
      : super(key: key);

  @override
  State<Upload_Photo_preview> createState() => _Upload_Photo_previewState();
}

class _Upload_Photo_previewState extends State<Upload_Photo_preview> {
  @override
  Widget build(BuildContext context) {
    var detailPagecontroller = Get.find<DetailPageController>();
    bool loading = false;

    return SafeArea(
      child: Scaffold(
          backgroundColor: MyThemes.darkblack,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
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
                      "Upload Your Photo",
                      style: TextStyle(
                          color: MyThemes.txtwhite,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                    child: Text(
                      "Profile",
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
                        color: MyThemes.txtdarkwhite,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 3, 0, 0),
                    child: Text(
                      "in Profile Section",
                      style: TextStyle(
                        color: MyThemes.txtdarkwhite,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: MyThemes.lightblack,
                        child: Container(
                          height: 250,
                          width: 250,
                          alignment: Alignment.center,
                          child: widget.link!.trim().isEmpty
                              ? Center(
                                  child: Image.file(File(widget.image!.path),
                                      height: 250,
                                      width: 250,
                                      fit: BoxFit.cover),
                                )
                              : Center(
                                  child: CachedNetworkImage(
                                    imageUrl: "${widget.link}",
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    height: 250,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Upload_Photo()));
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Common_Widget("Change Again ??")),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  loading
                      ? CircularProgressIndicator()
                      : InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            String setuser = "";
                            if (detailPagecontroller.isusermodelinitilize) {
                              print(
                                  "asedgsdgsd part is if  ${detailPagecontroller.modelforintent!.uid}");
                              if(!widget.link!.trim().isEmpty){
                                setuser = await detailPagecontroller.loadUser(
                                    detailPagecontroller.modelforintent!.uid,
                                    detailPagecontroller.modelforintent!.name,
                                    detailPagecontroller.modelforintent!.surname,
                                    detailPagecontroller.modelforintent!.email,
                                    detailPagecontroller
                                        .modelforintent!.mobilenumber,
                                    detailPagecontroller.modelforintent!.address,
                                    detailPagecontroller
                                        .modelforintent!.photo) as String;
                              }else{
                                detailPagecontroller.modelforintent!.photo =
                                    await detailPagecontroller.uploadImage(
                                        widget.image!,
                                        detailPagecontroller
                                            .modelforintent!.uid) as String;

                                setuser = await detailPagecontroller.loadUser(
                                    detailPagecontroller.modelforintent!.uid,
                                    detailPagecontroller.modelforintent!.name,
                                    detailPagecontroller.modelforintent!.surname,
                                    detailPagecontroller.modelforintent!.email,
                                    detailPagecontroller
                                        .modelforintent!.mobilenumber,
                                    detailPagecontroller.modelforintent!.address,
                                    detailPagecontroller
                                        .modelforintent!.photo) as String;
                              }

                            } else {
                              User id =
                                  await Authentication.getUserId() as User;
                              print("asedgsdgsd part is else  ${id}");

                              detailPagecontroller.modelforintent!.email =
                                  id.email.toString();
                              detailPagecontroller.modelforintent!.photo =
                                  await detailPagecontroller.uploadImage(
                                      widget.image!, id.uid) as String;

                              setuser = await detailPagecontroller.loadUser(
                                  id.uid,
                                  detailPagecontroller.modelforintent!.name,
                                  detailPagecontroller.modelforintent!.surname,
                                  id.email.toString(),
                                  detailPagecontroller
                                      .modelforintent!.mobilenumber,
                                  detailPagecontroller.modelforintent!.address,
                                  detailPagecontroller
                                      .modelforintent!.photo) as String;
                            }
                            print("sdgsdgszdg  ${setuser}");
                            if (await setuser == 'success') {
                              setState(() {
                                loading = false;
                              });
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                            }
                          },
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Common_Widget("Next")),
                        )
                ],
              ),
            ),
          )),
    );
  }
}
