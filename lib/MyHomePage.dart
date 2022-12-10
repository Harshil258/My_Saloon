import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:my_saloon/models/salonmodel.dart';
import 'package:my_saloon/profile.dart';
import 'package:my_saloon/search_page.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'category_detail_page.dart';
import 'category_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

void launchMap(String address) async {
  String query = Uri.encodeComponent(address);
  String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

  // if (await canLaunch(googleUrl)) {
  try {
    await launch(googleUrl);
  } on Exception catch (e) {
    print("can not launch");
  }
  // }else{
  //   print("can not launch");
  // }
}

Future<Address> getUserLocation() async {
  //call this async method from whereever you need

  LocationData? myLocation;
  String error;
  Location location = Location();
  try {
    myLocation = await location.getLocation();
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      error = 'please grant permission';
      print(error);
    }
    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      error = 'permission denied- please enable it from app settings';
      print(error);
    }
    myLocation = null;
  }
  var currentLocation = myLocation;
  final coordinates = Coordinates(myLocation!.latitude, myLocation!.longitude);
  var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var first = addresses.first;
  print(
      ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  return first;
}

List<String> imgList = [
  'https://images.pexels.com/photos/2061820/pexels-photo-2061820.jpeg?auto=compress&cs=tinysrgb&w=1600',
  'https://images.pexels.com/photos/3993444/pexels-photo-3993444.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/3993443/pexels-photo-3993443.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/3992874/pexels-photo-3992874.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/3101477/pexels-photo-3101477.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  'https://images.pexels.com/photos/897251/pexels-photo-897251.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'
];

class _MyHomePageState extends State<MyHomePage> {
  late List<SalonModel> salonlist;
  late final Future<List<SalonModel>> future;
  var detailPagecontroller = Get.find<DetailPageController>();
  late Future<Address> first;
  late Address addressfinal;

  @override
  initState() {
    super.initState();

    if (detailPagecontroller.isusermodelinitilize == false) {
      detailPagecontroller.isusermodelinitilize = true;
      detailPagecontroller.getuserdata();
    }
    future = detailPagecontroller.callfirebase();
    first = getUserLocation();
  }

  List<String> categoryname = ["Male", "Female", "All"];
  List<Widget> categories = [
    Horizontal_listview_item(
        "https://images.pexels.com/photos/3998429/pexels-photo-3998429.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "Male"),
    Horizontal_listview_item(
        "https://images.pexels.com/photos/3993472/pexels-photo-3993472.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "Female"),
    Horizontal_listview_item(
        "https://images.pexels.com/photos/1319460/pexels-photo-1319460.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        "All")
  ];

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                          imageUrl: "${item}",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 1000.0),
                      // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  String reason = '';
  final CarouselController _controller = CarouselController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() {
      reason = changeReason.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyThemes.darkblack,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: CustomScrollView(
            slivers: [
              // SliverAppBar(
              //   backgroundColor: MyThemes.darkblack,
              //   foregroundColor: MyThemes.darkblack,
              //   pinned: false,
              //   // collapsedHeight: 80,
              //   floating: true,
              //   stretch: true,
              //   flexibleSpace: Padding(
              //     padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              //     child: Container(
              //       color: MyThemes.darkblack,
              //       width: MediaQuery.of(context).size.width,
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.end,
              //                   children: [
              //                     Icon(
              //                       CupertinoIcons.home,
              //                       color: MyThemes.purple,
              //                       size: 20.0,
              //                     ),
              //                     SizedBox(
              //                       width: 10,
              //                     ),
              //                     Text(
              //                       "Home",
              //                       style: TextStyle(
              //                           color: MyThemes.txtwhite,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     SizedBox(
              //                       width: 10,
              //                     ),
              //                     Icon(
              //                       CupertinoIcons.chevron_down,
              //                       color: MyThemes.txtwhite,
              //                       size: 18.0,
              //                     )
              //                   ],
              //                 ),
              //                 GetBuilder<DetailPageController>(
              //                   builder: (controller) {
              //                     return controller.isusermodelinitilize
              //                         ? Text(
              //                             controller.modelforintent!.address.trim().toString(),
              //                             maxLines: 2,
              //                             style: TextStyle(
              //                                 overflow: TextOverflow.ellipsis),
              //                           )
              //                         : Text("No Address Defined");
              //                   },
              //                 )
              //               ],
              //             ),
              //           ),
              //           InkWell(
              //             onTap: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => Profile(),
              //                   ));
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              //               child: Align(
              //                 alignment: Alignment.centerRight,
              //                 child: Icon(
              //                   CupertinoIcons.person_crop_circle,
              //                   size: 28.0,
              //                   color: MyThemes.txtdarkwhite,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SliverStickyHeader(
                header: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: Container(
                    color: MyThemes.darkblack,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    CupertinoIcons.home,
                                    color: MyThemes.purple,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                        color: MyThemes.txtwhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    CupertinoIcons.chevron_down,
                                    color: MyThemes.txtwhite,
                                    size: 18.0,
                                  )
                                ],
                              ),
                              GetBuilder<DetailPageController>(
                                builder: (controller) {
                                  return (detailPagecontroller.modelforintent !=
                                          null)
                                      ? FutureBuilder<Address>(
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return InkWell(
                                                  onTap: () async {
                                                    print("open google map");
                                                    launchMap(
                                                        "${snapshot.data!.addressLine} ${snapshot.data!.featureName} ${snapshot.data!.thoroughfare}");
                                                  },
                                                  child: Text(
                                                    "${snapshot.data!.addressLine} ${snapshot.data!.featureName} ${snapshot.data!.thoroughfare}",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ));
                                            } else {
                                              return Text("No Address Defined");
                                            }
                                          },
                                          future: first,
                                        )
                                      : Text("No Address Defined");
                                },
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: (detailPagecontroller.modelforintent !=
                                          null &&
                                      detailPagecontroller
                                              .modelforintent?.photo !=
                                          null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${detailPagecontroller.modelforintent!.photo}",
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          CupertinoIcons.person_crop_circle,
                                          size: 35.0,
                                          color: MyThemes.txtdarkwhite,
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                          color: MyThemes.purple,
                                        )),
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.cover,
                                      ))
                                  : Icon(
                                      CupertinoIcons.person_crop_circle,
                                      size: 28.0,
                                      color: MyThemes.txtdarkwhite,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                backgroundColor: MyThemes.darkblack,
                foregroundColor: MyThemes.darkblack,
                pinned: true,
                floating: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Container(
                    color: MyThemes.darkblack,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: MyThemes.darkblack,
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: MyThemes.purple)),
                            child: Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                search_page()));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Search Your Favourite Saloon!!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: MyThemes.txtdarkwhite,
                                              fontSize: 15),
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
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      items: imageSliders,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: 200,
                        aspectRatio: 16 / 9,
                        onPageChanged: onPageChange,
                        autoPlay: true,
                      ),
                      carouselController: _controller,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 0, 8),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  // color: Colors.deepPurple,
                  height: 187.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => categoryu_detail_page(
                                        categoryname[index])));
                          },
                          child: categories[index]);
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 0, 8),
                  child: Text(
                    "Saloon To EXPLORE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              category_list(future)
              // FutureBuilder<List<SalonModel>>(
              //     future: future,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return SliverList(
              //           delegate: SliverChildBuilderDelegate(
              //             (context, index) {
              //               double rating = snapshot.data![index].rating2
              //                       .map((e) => e.rating)
              //                       .toList()
              //                       .reduce((a, b) => a + b) /
              //                   salonlist[0].rating2.length;
              //
              //               return Padding(
              //                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              //                 child: InkWell(
              //                   onTap: () {
              //                     Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                           builder: (context) => detail_page(
              //                               salonid:
              //                                   snapshot.data![index].salonId,
              //                               salonmodel: snapshot.data![index]),
              //                         ));
              //                   },
              //                   child: Vertical_listview_item(
              //                       image: snapshot.data![index].image,
              //                       title: snapshot.data![index].salonName,
              //                       rating:
              //                           "${rating.toStringAsFixed(2).toString()} (${snapshot.data![index].rating2.length.toString()}) + Rating",
              //                       // "${snapshot.data![index].rating.map((e) => e).reduce((value, element) => value + element) / snapshot.data![index].rating.length}",
              //                       address: snapshot.data![index].address),
              //                 ),
              //               );
              //             },
              //             childCount: snapshot.data!.length,
              //           ), //SliverChildBuildDelegate
              //         );
              //       } else {
              //         return SliverToBoxAdapter(
              //           child: CircularProgressIndicator(),
              //         );
              //       }
              //     })
            ],
          ),
        ),
      ),
    );
  }
}
