import 'package:booking_calendar/booking_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_saloon/Screens/Signup_Process_Screen.dart';
import 'package:my_saloon/models/servicemodel.dart';
import 'package:my_saloon/services/auth.dart';
import 'package:my_saloon/services/detailPageController.dart';
import 'package:my_saloon/themes.dart';
import 'package:readmore/readmore.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  var detailPagecontroller = Get.find<DetailPageController>();
  final firestore = FirebaseFirestore.instance;
  List<BookingService> listOfBookingServices = <BookingService>[].obs;

  @override
  void initState() {
    super.initState();
    // fetchConfirmedBookings(detailPagecontroller.modelforintent!.uid);
    fetchConfirmedBookings(detailPagecontroller.modelforintent!.uid)
        .then((value) {
      value.sort((a, b) => b.bookingStart.compareTo(a.bookingStart));
      listOfBookingServices = value;
      setState(() {});
    });
  }

  Future<List<BookingService>> fetchConfirmedBookings(String uid) async {
    List<BookingService> bookingstemp = [];
    var instance = await FirebaseFirestore.instance
        .collectionGroup('bookings')
        .where('userId', isEqualTo: uid)
        .get();
    bookingstemp = instance.docs
        .map((doc) => BookingService.fromJson(doc.data()))
        .toList();
    print('All Bookings With this id :: ${uid} :: ${bookingstemp[0].toJson()}');
    return bookingstemp;
  }

  Future<List<ServiceModel>> fetchServiceDetails(
      List<dynamic>? serviceids) async {
    print(
        "fetchServiceDetails :: serviceids  :: ${serviceids!.toSet().toString()}");
    List<ServiceModel> servicelist = [];

    for (var element in serviceids!) {
      var instance = await FirebaseFirestore.instance
          .collection("service")
          .doc(element.toString())
          .get();

      print("fetchServiceDetails :: forloop  :: ${instance.data().toString()}");
      print(
          "fetchServiceDetails :: forloop  :: ${fromQuerySnapshotService(instance)}");
      var service = fromQuerySnapshotService(instance);
      print("fetchServiceDetails :: service toJson :: ${service.toJson()}");
      servicelist.add(service);
    }
    print(
        "fetchServiceDetails :: servicelist  :: ${servicelist!.toSet().toString()}");
    return servicelist;
  }

  @override
  Widget build(BuildContext context) {
    bool editable = false;

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
                          shrinkWrap: true,
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
                                                Signup_Process_Screen()));
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 5, 22, 0),
                              child: Text(
                                "Your Bookings :",
                                style: TextStyle(
                                    color: MyThemes.txtwhite, fontSize: 18),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: listOfBookingServices.length,
                              itemBuilder:
                                  (context, listOfBookingServicesindex) {
                                print(
                                    "sdhgsdhgdhgdshdh :: ${listOfBookingServices[listOfBookingServicesindex].servicePrice.toString()}");

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: MyThemes.txtwhite,
                                              width: 1),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        children: [
                                          FutureBuilder<List<ServiceModel>>(
                                            future: fetchServiceDetails(
                                                listOfBookingServices[
                                                        listOfBookingServicesindex]
                                                    .servicesId),
                                            initialData: [],
                                            builder: (context, snapshot) {
                                              print(
                                                  "sgfdggfdgfg ::  ${snapshot.data!.toSet().toString()}");
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder: (context,
                                                              indexofperticulerservice) {
                                                            return Container(
                                                                child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          snapshot.data![indexofperticulerservice].image!.isNotEmpty
                                                                              ? ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: CachedNetworkImage(
                                                                                    imageUrl: "${snapshot.data![indexofperticulerservice].image}",
                                                                                    placeholder: (context, url) => Center(
                                                                                        child: CircularProgressIndicator(
                                                                                      color: MyThemes.purple,
                                                                                    )),
                                                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                    height: 120,
                                                                                    width: 110,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                )
                                                                              : SizedBox(
                                                                                  height: 50,
                                                                                  width: 110,
                                                                                ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              "${snapshot.data![indexofperticulerservice].price.toString()} ₹",
                                                                              style: TextStyle(color: MyThemes.txtwhite, fontSize: 18),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    snapshot.data![indexofperticulerservice].title,
                                                                                    style: TextStyle(color: MyThemes.txtwhite, fontSize: 17, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              ReadMoreText(
                                                                                snapshot.data![indexofperticulerservice].description,
                                                                                textAlign: TextAlign.start,
                                                                                trimLines: 2,
                                                                                colorClickableText: MyThemes.purple,
                                                                                trimMode: TrimMode.Line,
                                                                                trimCollapsedText: ' Show more',
                                                                                trimExpandedText: ' Show less',
                                                                                style: TextStyle(overflow: TextOverflow.ellipsis),
                                                                              ),
                                                                              Text("Timing :"),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Column(
                                                                                      children: [
                                                                                        Text(DateFormat("dd-MM-yyyy hh:mm").format(listOfBookingServices[listOfBookingServicesindex].bookingStart)),
                                                                                        Text("To"),
                                                                                        Text(DateFormat("dd-MM-yyyy hh:mm").format(listOfBookingServices[listOfBookingServicesindex].bookingEnd)),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                  ),
                                                                  (indexofperticulerservice ==
                                                                          snapshot.data!.length -
                                                                              1)
                                                                      ? Container()
                                                                      : Divider(
                                                                          thickness:
                                                                              1,
                                                                          color:
                                                                              MyThemes.txtdarkwhite,
                                                                        ),
                                                                  (indexofperticulerservice ==
                                                                          snapshot.data!.length -
                                                                              1)
                                                                      ? (listOfBookingServices[listOfBookingServicesindex].bookingStart.isAfter(DateTime.now()) &&
                                                                              "${listOfBookingServices[listOfBookingServicesindex].status}" == "PENDING")
                                                                          ? Container(
                                                                              color: MyThemes.darkblack,
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: Text('Cancellation Warning', style: TextStyle(color: MyThemes.darkblack, fontSize: 17, fontWeight: FontWeight.bold)),
                                                                                        content: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            Text('Bookings can only be cancelled prior to 24 hours before the actual appointment time.', style: TextStyle(color: MyThemes.darkblack, fontWeight: FontWeight.w100)),
                                                                                            (listOfBookingServices[listOfBookingServicesindex].bookingStart.difference(DateTime.now()).inHours > 24) ? Container() : Text('You cannot delete the appointment because it is less than 24 hours away from now.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w100))
                                                                                          ],
                                                                                        ),
                                                                                        actions: <Widget>[
                                                                                          (listOfBookingServices[listOfBookingServicesindex].bookingStart.difference(DateTime.now()).inHours > 24)
                                                                                              ? TextButton(
                                                                                                  child: Text('Cancel Booking'),
                                                                                                  onPressed: () async {
                                                                                                    for (var element in listOfBookingServices[listOfBookingServicesindex].servicesId!) {
                                                                                                      detailPagecontroller.removeRecord(element);
                                                                                                    }
                                                                                                    final querySnapshot = await FirebaseFirestore.instance.collection('salons').doc(snapshot.data![0].salonId).collection("bookings").where("userId", isEqualTo: listOfBookingServices[listOfBookingServicesindex].userId).get();
                                                                                                    if (querySnapshot.size > 0) {
                                                                                                      final documentSnapshot = querySnapshot.docs.first;
                                                                                                      await documentSnapshot.reference.delete();
                                                                                                    }
                                                                                                    fetchConfirmedBookings(detailPagecontroller.modelforintent!.uid).then((value) {
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Appointment has Cancelled Successfully...")));
                                                                                                      setState(() {
                                                                                                        listOfBookingServices = value;
                                                                                                      });
                                                                                                      Navigator.of(context, rootNavigator: true).pop();
                                                                                                    });
                                                                                                  },
                                                                                                )
                                                                                              : SizedBox(),
                                                                                          TextButton(
                                                                                            child: Text('Dismiss'),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  height: 50,
                                                                                  color: MyThemes.purple,
                                                                                  child: const Center(child: Text("Cancel Appointment ?")),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : Container()
                                                                      : Container(),
                                                                  Container(
                                                                    color: MyThemes
                                                                        .darkblack,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      color: MyThemes
                                                                          .purple,
                                                                      child: Center(
                                                                          child: ("${listOfBookingServices[listOfBookingServicesindex].status}" == "PENDING" && listOfBookingServices[listOfBookingServicesindex].bookingStart.isAfter(DateTime.now()))
                                                                              ? "${listOfBookingServices[listOfBookingServicesindex].status}" == "PENDING"
                                                                                  ? Text("DATE IS YET TO COME")
                                                                                  : ("${listOfBookingServices[listOfBookingServicesindex].status}" == "DONE")
                                                                                      ? Text("APPOINTMENT IS FINISHED")
                                                                                      : Text("CANCELED BY SALOON")
                                                                              : ("${listOfBookingServices[listOfBookingServicesindex].status}" == "DONE")
                                                                                  ? Text("APPOINTMENT IS FINISHED")
                                                                                  : Text("CANCELED BY SALOON")),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ));
                                                          },
                                                          itemCount: snapshot
                                                              .data!.length,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          Divider(
                                            thickness: 1,
                                            color: MyThemes.txtdarkwhite,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Total Bill Of :  ${listOfBookingServices[listOfBookingServicesindex].servicePrice.toString()} ₹",
                                                  style: TextStyle(
                                                      color: MyThemes.txtwhite,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                );
                              },
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
            detailPagecontroller.isusermodelinitilize = false;
            detailPagecontroller.deleteTable();
            detailPagecontroller.modelforintent = null;
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
