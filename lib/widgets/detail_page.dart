import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_saloon/constants.dart';
import 'package:my_saloon/models/salonmodel.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

import '../MyHomePage.dart';
import '../models/servicemodel.dart';
import '../services/detailPageController.dart';
import '../services/sqlServices.dart';
import '../themes.dart';

class detail_page extends StatefulWidget {
  const detail_page({Key? key, required this.salonid, required this.salonmodel})
      : super(key: key);

  final String salonid;
  final MainModel salonmodel;

  @override
  State<detail_page> createState() => _detail_pageState();
}

class _detail_pageState extends State<detail_page> {
  late List<servicemodel>? servicelist = null;
  late final Future<List<servicemodel>> future;
  late DetailPageController detailPageController = Get.put(DetailPageController());

  Future<List<servicemodel>> _loadservices() async {
    Client client = Client(endPoint: AppConstsnts.endPoint);
    client.setProject(AppConstsnts.project);
    client.setSelfSigned(status: true);
    final databases = Database(client);
    try {
      final res = await databases.listDocuments(
          collectionId: AppConstsnts.servicecollection,
          queries: [Query.equal('salon_id', widget.salonid)]);

      servicelist = res
          .convertTo((p0) => servicemodel.fromJson(p0 as Map<String, dynamic>));

      servicelist!.forEach((element) {
        detailPageController.addToCart(
            element.salonId, element.id, true, true,
            "timeSlot");
      });

      print(servicelist.toString());
    } on AppwriteException catch (e) {}
    return servicelist!;
  }

  @override
  void initState() {
    super.initState();
    future = _loadservices();
    // Navigator.push(context, MaterialPageRoute(builder: (_) => DatabaseList()));
    print("sdfasdfsdf  ${detailPageController.getCartList(widget.salonid)}");
  }

  @override
  Widget build(BuildContext context) {
    double rating = widget.salonmodel.rating
        .map((e) => int.parse(e))
        .toList()
        .reduce((a, b) => a + b) /
        widget.salonmodel.rating.length;

    Widget sliverlist;

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyThemes.darkblack,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<servicemodel>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData == true) {
                sliverlist = SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: custom_item_view(
                            Name: snapshot.data![index].title,
                            Price: snapshot.data![index].price,
                            Description: snapshot.data![index].description,
                            imagelink: snapshot.data![index].image),
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
                                    "${rating.toStringAsFixed(2)
                                        .toString()} (${widget.salonmodel.rating
                                        .length.toString()}) + Rating",
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
                  // FutureBuilder(
                  //   builder: (ctx, snapshot) {
                  //     // Checking if future is resolved or not
                  //     if (snapshot.connectionState == ConnectionState.done) {
                  //       // If we got an error
                  //       if (snapshot.hasError) {
                  //         return Center(
                  //           child: Text(
                  //             '${snapshot.error} occurred',
                  //             style: TextStyle(fontSize: 18),
                  //           ),
                  //         );
                  //
                  //         // if we got our data
                  //       } else if (snapshot.hasData) {
                  //         // Extracting data from snapshot object
                  //         final data = snapshot.data as String;
                  //         return Center(
                  //           child: Text(
                  //             '$data',
                  //             style: TextStyle(fontSize: 18),
                  //           ),
                  //         );
                  //       }
                  //     }
                  //
                  //     // Displaying LoadingSpinner to indicate waiting state
                  //     return Center(
                  //       child: CircularProgressIndicator(),
                  //     );
                  //   },
                  //
                  //   // Future that needs to be resolved
                  //   // inorder to display something on the Canvas
                  //   future: getData(),
                  // )

                  // FutureBuilder<List<servicemodel>>(
                  //     future: future,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData == true) {
                  //         return SliverList(
                  //           delegate: SliverChildBuilderDelegate(
                  //             (context, index) {
                  //               return Padding(
                  //                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  //                 child: custom_item_view(
                  //                     Name: snapshot.data![index].title,
                  //                     Price: snapshot.data![index].price,
                  //                     Description:
                  //                         snapshot.data![index].description,
                  //                     imagelink: snapshot.data![index].image),
                  //               );
                  //             },
                  //             childCount: 5,
                  //           ), //SliverChildBuildDelegate
                  //         );
                  //       } else {
                  //         return CircularProgressIndicator();
                  //       }
                  //     }),

                  sliverlist
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
