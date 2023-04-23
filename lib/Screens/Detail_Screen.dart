import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_saloon/models/salonmodel.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/servicemodel.dart';
import '../services/detailPageController.dart';
import '../themes.dart';
import 'Slot_Booking_Screen.dart';

class Detail_Screen extends StatefulWidget {
  const Detail_Screen(
      {Key? key, required this.salonid, required this.salonmodel})
      : super(key: key);

  final String salonid;
  final SalonModel salonmodel;

  @override
  State<Detail_Screen> createState() => _Detail_ScreenState();
}

class _Detail_ScreenState extends State<Detail_Screen> {
  late List<ServiceModel>? servicelist = null;
  late final Future<List<ServiceModel>> future;

  late DetailPageController detailPageController =
      Get.put(DetailPageController());

  bool listlodedornot = false;

  @override
  void initState() {
    super.initState();
    detailPageController.loadservicesFromfirebase(widget.salonid);
  }

  @override
  Widget build(BuildContext context) {
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
                  sliverlist = SliverToBoxAdapter(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("No Service Listed!!")),
                  ));
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
                                    )
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
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      Uri url = Uri(
                                          scheme: "tel",
                                          path: widget.salonmodel.mobilenumber);

                                      // var url = "tel:${widget.salonmodel.mobilenumber.toString()}";
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: MyThemes.purple),
                                    child: Text(
                                      "CALL SALOON NOW",
                                      style: TextStyle(
                                          color: MyThemes.txtwhite,
                                          fontSize: 10),
                                    ))
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
            ),
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
                                  builder: (context) => Slot_Booking_Screen(
                                      widget.salonmodel.salonName,
                                      widget.salonid)));
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
