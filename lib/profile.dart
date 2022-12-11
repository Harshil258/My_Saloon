import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_saloon/services/auth.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/signup_process.dart';
import 'package:my_saloon/themes.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool editable = false;
    var detailPagecontroller = Get.find<DetailPageController>();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            detailPagecontroller.modelforintent!.photo.trim().isEmpty
                ? SvgPicture.asset(
                    "assets/male.svg",
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.contain,
                  )
                : CachedNetworkImage(
                    imageUrl: "${detailPagecontroller.modelforintent!.photo}",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Scrollbar(
                  child: Container(
                      decoration: new BoxDecoration(
                          color: MyThemes.darkblack,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0))),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SvgPicture.asset("assets/divider.svg"),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          22, 0, 22, 0),
                                      child: TextFormField(
                                        cursorColor: MyThemes.txtwhite,
                                        initialValue: (detailPagecontroller
                                                        .modelforintent!.name +
                                                    " " +
                                                    detailPagecontroller
                                                        .modelforintent!
                                                        .surname)
                                                .trim()
                                                .isNotEmpty
                                            ? detailPagecontroller
                                                    .modelforintent!.name +
                                                " " +
                                                detailPagecontroller
                                                    .modelforintent!.surname
                                            : "Name and Surname is not set",
                                        autofocus: false,
                                        readOnly: editable,
                                        style: TextStyle(
                                            color: MyThemes.txtwhite,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(22, 0, 22, 0),
                                    child: SvgPicture.asset(
                                        "assets/Edit Icon.svg"),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Signup_process()));
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                detailPagecontroller
                                        .modelforintent!.email.isNotEmpty
                                    ? detailPagecontroller.modelforintent!.email
                                    : "Please Set Email",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                detailPagecontroller
                                        .modelforintent!.mobilenumber.isNotEmpty
                                    ? detailPagecontroller
                                        .modelforintent!.mobilenumber
                                    : "Please set mobile number",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                detailPagecontroller
                                        .modelforintent!.address.isNotEmpty
                                    ? detailPagecontroller
                                        .modelforintent!.address
                                    : "Please set Adderess",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
            ),
            SafeArea(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: SvgPicture.asset(
                    "assets/backpurple.svg",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: MyThemes.darkblack,
        child: InkWell(
          onTap: () {
            Authentication.signOut(context: context);
            detailPagecontroller
                .isusermodelinitilize = false;
            detailPagecontroller.deleteTable();
            detailPagecontroller.modelforintent = null;
            detailPagecontroller.dispose();
            // Get.delete<DetailPageController>();
            // Get.put(DetailPageController());
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 50,
              color: MyThemes.purple,
              child: Center(child: Text("Sign Out")),
            ),
          ),
        ),
      ),
    );
  }
}
