import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../themes.dart';
import 'Upload_photo_preview.dart';

class Upload_Photo extends StatelessWidget {
  const Upload_Photo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.darkblack,
      body: Container(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: SvgPicture.asset(
                          "assets/backpurple.svg",
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
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
                      child: InkWell(
                        onTap: () async {
                          await Permission.photos.request();
                          var permissionStatus = await Permission.photos.status;
                          if (permissionStatus.isGranted) {
                            final _imagePicker = ImagePicker();
                            final PickedFile? image = await _imagePicker
                                .getImage(source: ImageSource.gallery);
                            var file = await File(image!.path);
                            if (file != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Upload_Photo_preview(
                                              image, file, "")));
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: MyThemes.lightblack,
                          child: Container(
                            height: 150,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/Gallery Icon.svg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
                      child: InkWell(
                        onTap: () async {
                          /*   final _imagePicker = ImagePicker();
                          PickedFile? image;
                          image = await _imagePicker.getImage(source: ImageSource.gallery);*/
                          await Permission.photos.request();
                          var permissionStatus = await Permission.photos.status;
                          if (permissionStatus.isGranted) {
                            final _imagePicker = ImagePicker();
                            final PickedFile? image = await _imagePicker
                                .getImage(source: ImageSource.camera);
                            var file = await File(image!.path);
                            if (file != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Upload_Photo_preview(
                                              image, file, "")));
                            }
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: MyThemes.lightblack,
                          child: Container(
                            height: 150,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/Camera Icon.svg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
