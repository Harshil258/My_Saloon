import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/themes.dart';

import 'category_list.dart';
import 'models/salonmodel.dart';

class search_page extends StatefulWidget {
  const search_page({Key? key}) : super(key: key);

  @override
  State<search_page> createState() => _search_pageState();
}

class _search_pageState extends State<search_page> {
  var detailPagecontroller = Get.find<DetailPageController>();

  // late final List<SalonModel> futuremini =
  //     detailPagecontroller.salonlist;
  late Future<List<SalonModel>> future;
  TextEditingController searchtext = new TextEditingController();

  Future<List<SalonModel>> getfuturelist(String searchtxt) async {

    // print("aedfgdgdg   ${detailPagecontroller.salonlist.toString()}");

    if (searchtext.toString().trim() == "") {
      return detailPagecontroller.salonlist;
    } else {
      return detailPagecontroller.salonlist
          .where((element) => element.salonName
              .toLowerCase()
              .contains(searchtxt.toLowerCase().toString()))
          .toList();
    }
  }

  @override
  initState() {
    super.initState();
    future = getfuturelist("");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: MyThemes.darkblack,
      appBar: AppBar(
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Material(
              color: MyThemes.darkblack,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: MyThemes.purple)),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              onChanged: (text) {
                                setState(() {
                                  future = getfuturelist(text);
                                });
                                print("asdgfsdgsdfg ${future}");
                              },
                              controller: searchtext,
                              cursorColor: MyThemes.txtwhite,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: MyThemes.txtdarkwhite, fontSize: 15),
                              decoration: InputDecoration(
                                  hintText: "Search Your Favourite Saloon!!",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(bottom: 10),
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            CupertinoIcons.search,
                            size: 22.0,
                            color: MyThemes.txtdarkwhite,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: CustomScrollView(slivers: [category_list(future)]),
      ),
    ));
  }
}
