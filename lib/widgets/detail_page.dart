import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_saloon/models/salonmodel.dart';
import 'package:my_saloon/widgets/common_widgets.dart';

import '../SlotBookingPage.dart';
import '../models/servicemodel.dart';
import '../services/detailPageController.dart';
import '../themes.dart';

class detail_page extends StatefulWidget {
  const detail_page({Key? key, required this.salonid, required this.salonmodel})
      : super(key: key);

  final String salonid;
  final SalonModel salonmodel;

  @override
  State<detail_page> createState() => _detail_pageState();
}

class _detail_pageState extends State<detail_page> {
  late List<ServiceModel>? servicelist = null;
  late final Future<List<ServiceModel>> future;

  late DetailPageController detailPageController =
      Get.put(DetailPageController());
  bool listlodedornot = false;

  Future<List<ServiceModel>> _loadservices() async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('service');
    QuerySnapshot snapshot =
        await collection.where('salon_id', isEqualTo: widget.salonid).get();
    servicelist = await List.from(
        snapshot.docs.map((element) => fromQuerySnapshotService(element)));
    print("yyyyyyyyyyy   " + servicelist!.toList().toString());
    detailPageController.getCartList(widget.salonid);

    return servicelist!;
  }

  @override
  void initState() {
    super.initState();
    detailPageController.loadservicesFromfirebase(widget.salonid);
  }

  @override
  Widget build(BuildContext context) {
    double rating = widget.salonmodel.rating2
            .map((e) => e.rating)
            .toList()
            .reduce((a, b) => a + b) /
        widget.salonmodel.rating2.length;

    Widget sliverlist;

    return SafeArea(
      child: Scaffold(
          backgroundColor: MyThemes.darkblack,
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<DetailPageController>(
                builder: (controller) {
                  if (controller.servicemodellist.isNotEmpty == true) {
                    sliverlist = SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          bool addedInCartOrNot =
                              detailPageController.addedInCartOrNot(
                                  controller.servicemodellist[index].serviceId);
                          return Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: custom_item_view(
                                Name: controller.servicemodellist[index].title,
                                Price: controller.servicemodellist[index].price,
                                Description: controller
                                    .servicemodellist[index].description,
                                imagelink:
                                    controller.servicemodellist[index].image,
                                addedOrNot: addedInCartOrNot,
                                onTapOnAddCart: () async {
                                  setState(
                                    () {
                                      if (addedInCartOrNot == true) {
                                        //removing element from cart(databasemodel)
                                        detailPageController.removeRecord(
                                            controller.servicemodellist[index]
                                                .serviceId);
                                        detailPageController
                                            .getCartList(widget.salonid);
                                      } else {
                                        //adding element in cart(databasemodel)
                                        detailPageController.addToCart(
                                            widget.salonid,
                                            controller.servicemodellist[index]
                                                .serviceId,
                                            true);
                                        detailPageController
                                            .getCartList(widget.salonid);
                                      }
                                    },
                                  );
                                },
                              ));
                        },
                        childCount: controller.servicemodellist.length,
                      ), //SliverChildBuildDelegate
                    );
                  } else {
                    sliverlist =
                        SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: MyThemes.txtwhite,)));
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: MyThemes.darkblack,
                        pinned: true,
                        floating: true,
                        flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text(widget.salonmodel.salonName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ) //TextStyle
                                ), //Text
                            background: Image.network(
                              widget.salonmodel.image,
                              fit: BoxFit.cover,
                            ) //Images.network
                            ),
                        expandedHeight: 300,
                        leading: IconButton(
                          icon: Icon(CupertinoIcons.chevron_back),
                          tooltip: 'Back',
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => MyHomePage()));
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: MyThemes.darkblack,
                                boxShadow: [
                                  BoxShadow(
                                      color: MyThemes.purple, spreadRadius: 1),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      widget.salonmodel.salonName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: MyThemes.txtwhite),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.star_circle,
                                        color: MyThemes.txtdarkwhite,
                                        size: 20.0,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${rating.toStringAsFixed(2).toString()} (${widget.salonmodel.rating2.length}) + Rating",
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: MyThemes.txtdarkwhite),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    widget.salonmodel.address,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: MyThemes.txtdarkwhite),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                          child: Text(
                            "Our Services :",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      sliverlist
                    ],
                  );
                },
              )
              /*FutureBuilder<List<ServiceModel>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData == true) {
                sliverlist = SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      bool addedincartornot = false;
                      DatabaseModel? databasemodel = null;
                      print(
                          "ffffffffffffffffff  ${listlodedornot}");
                      if (listlodedornot == Future<bool>.value(true)) {
                        print("bool is true");
                        for (var databaseModel
                            in detailPageController.cartlist) {
                          print("bbbbbbbbbbbbb  ${databaseModel.serviceId}");
                          if (databaseModel.serviceId ==
                              snapshot.data![index].serviceId) {
                            // setState(() {
                            databasemodel = databaseModel;
                            addedincartornot = true;
                            // });
                            break;
                          }
                        }
                      }
                      bool addedInCartOrNot = detailPageController.addedInCartOrNot(snapshot.data![index].serviceId);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: custom_item_view(
                              Name: snapshot.data![index].title,
                              Price: snapshot.data![index].price,
                              Description: snapshot.data![index].description,
                              imagelink: snapshot.data![index].image,
                              addedOrNot: addedInCartOrNot,
                              onTapOnAddCart: () async {
                                setState(() {
                                  if (addedInCartOrNot == true) {
                                    //removing element from cart(databasemodel)
                                    detailPageController.removeRecord(snapshot.data![index].serviceId);
                                    print("removing from cart");
                                  } else {
                                    //adding element in cart(databasemodel)
                                    if (databasemodel.isNullOrBlank == true) {
                                      print("adding in cart");
                                      detailPageController.addToCart(
                                          widget.salonid,
                                          snapshot.data![index].serviceId,
                                          true);
                                    } else {
                                      print("kkkkkkkkkkkkkkkkkkkkkkkkkkk");
                                      detailPageController.addToCart(
                                          widget.salonid,
                                          snapshot.data![index].serviceId,
                                          databasemodel!.addedToCart.isEqual(1)
                                              ? true
                                              : false);
                                    }
                                    print(
                                        "hhhhhhhhhhhhh ${detailPageController.cartlist.toList().toString()}");
                                  }
                                });
                              },
                            )
                      );
                    },
                    childCount: snapshot.data!.length,
                  ), //SliverChildBuildDelegate
                );
              } else {
                sliverlist =
                    SliverToBoxAdapter(child: CircularProgressIndicator());
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: MyThemes.darkblack,
                    pinned: true,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(widget.salonmodel.salonName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ) //TextStyle
                            ), //Text
                        background: Image.network(
                          widget.salonmodel.image,
                          fit: BoxFit.cover,
                        ) //Images.network
                        ),
                    expandedHeight: 300,
                    leading: IconButton(
                      icon: Icon(CupertinoIcons.chevron_back),
                      tooltip: 'Back',
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => MyHomePage()));
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: MyThemes.darkblack,
                            boxShadow: [
                              BoxShadow(
                                  color: MyThemes.purple, spreadRadius: 1),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  widget.salonmodel.salonName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22, color: MyThemes.txtwhite),
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.star_circle,
                                    color: MyThemes.txtdarkwhite,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${rating.toStringAsFixed(2).toString()} (${widget.salonmodel.rating2.length}) + Rating",
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: MyThemes.txtdarkwhite),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                widget.salonmodel.address,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13, color: MyThemes.txtdarkwhite),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                      child: Text(
                        "Our Services :",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  sliverlist
                ],
              );
            },
          ),*/
              ),
          bottomNavigationBar: GetBuilder<DetailPageController>(
            builder: (controller) {
              int cartItemTotal = 0;
              cartItemTotal = controller.cartlist.length;
              return controller.cartlist.isNotEmpty
                  ? Container(
                      color: MyThemes.purple,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SlotBookingPage(widget.salonmodel.salonName,widget.salonid)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CHOOSE THE SLOT FOR ${cartItemTotal} SERVICES   ",
                                style: TextStyle(
                                    color: MyThemes.txtwhite,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                CupertinoIcons.arrow_right_circle,
                                color: MyThemes.txtwhite,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox();
            },
          )),
    );
  }
}
