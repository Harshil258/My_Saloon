import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_saloon/models/salonmodel.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/themes.dart';

import '../category_list.dart';

class Caegory_Detail_Screen extends StatefulWidget {
  const Caegory_Detail_Screen(this.categoryname, {Key? key}) : super(key: key);
  final String categoryname;

  @override
  State<Caegory_Detail_Screen> createState() => _Caegory_Detail_ScreenState();
}

class _Caegory_Detail_ScreenState extends State<Caegory_Detail_Screen> {
  late final Future<List<SalonModel>> future;
  var detailPagecontroller = Get.find<DetailPageController>();

  @override
  initState() {
    super.initState();
    future = _callfirebase();
  }

  Future<List<SalonModel>> _callfirebase() async {
    
    List<SalonModel> salonlist = detailPagecontroller.salonlist;
    
    if (widget.categoryname.toString() == "All") {
      
    } else if(widget.categoryname.toString() == "Male"){
      salonlist = salonlist.where((element) => element.category != "Female").toList();
    }else if(widget.categoryname.toString() == "Female"){
      salonlist = salonlist.where((element) => element.category != "Male").toList();
    }

    // var seen = Set<String>();
    // salonlist2 = salonlist.where((element) => seen.add(element.salonId)).toList();
    // salonlist2 = salonlist.where((element) => seen.remove(element.category) == "").toList();

    return salonlist;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyThemes.darkblack,
        body: CustomScrollView(slivers: [
          SliverAppBar(title: Text("Saloons : ${widget.categoryname}")),
          category_list(future),
        ]),
      ),
    );
  }
}
