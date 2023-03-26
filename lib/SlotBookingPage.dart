import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_saloon/themes.dart';
import 'package:my_saloon/widgets/common_widgets.dart';
import 'package:intl/intl.dart';

import 'models/SalonBooking.dart';
import 'services/detailPageController.dart';
import 'package:intl/date_symbol_data_local.dart';


class SlotBookingPage extends StatefulWidget {
  const SlotBookingPage(this.salonName, this.salonid, {Key? key})
      : super(key: key);
  final String salonName;
  final String salonid;

  @override
  State<SlotBookingPage> createState() => _SlotBookingPageState();
}

class _SlotBookingPageState extends State<SlotBookingPage> {
  var detailPagecontroller = Get.find<DetailPageController>();
  CollectionReference bookings =
      FirebaseFirestore.instance.collection('salons');
  final now = DateTime.now();
  List<String> servicelist = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    detailPagecontroller.loadCartServices();
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0)),
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 15, 0),
          end: DateTime(now.year, now.month, now.day, 16, 0))
    ];
  }

  CollectionReference<SalonBooking> getBookingStream(
      {required String placeId}) {
    print("place id :: ${placeId}");

    bookings
        .doc(placeId)
        .collection("bookings")
        .snapshots()
        .listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          var booking = SalonBooking.fromJson(change.doc.data()!);
          print("Booking added: ${booking.toJson()}");
        }
        if (change.type == DocumentChangeType.modified) {
          var booking = SalonBooking.fromJson(change.doc.data()!);
          print("Booking modified: ${booking.toJson()}");
        }
        if (change.type == DocumentChangeType.removed) {
          var booking = SalonBooking.fromJson(change.doc.data()!);
          print("Booking removed: ${booking.toJson()}");
        }
      });
    });

    var books = bookings
        .doc(placeId)
        .collection("bookings")
        .withConverter<SalonBooking>(
      fromFirestore: (snapshots, _) {
        var booking = SalonBooking.fromJson(snapshots.data()!);
        print("Booking: ${booking.toJson()}");
        return booking;
      },
      toFirestore: (snapshots, _) {
        print("sfdhgfdgsdfg  ${snapshots.toJson()}");
        return snapshots.toJson();
      },
    );
    return books;
  }

  String convertDateTime(String initialDateTimeString) {
    final initialDateTime = DateTime.parse(initialDateTimeString);
    final newDateTimeString =
        DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(initialDateTime);
    return newDateTimeString;
  }

  Stream<dynamic>? getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
    var bookings = getBookingStream(placeId: widget.salonid)
        .where('bookingStart',
            isGreaterThanOrEqualTo: convertDateTime(start.toString()))
        .where('bookingStart', isLessThanOrEqualTo: end.toString())
        .snapshots();

    bookings.length.then((value) {
      print("getBookingStreamFirebase bookings value:: ${value}  ");
    });

    bookings.forEach((element) {
      print(
          "getBookingStreamFirebase :: ${element.docs.length}    start   ${start.toString()}       end    ${end}");
    });
    return bookings;
  }

  List<DateTimeRange> convertStreamResultFirebase(
      {required dynamic streamResult}) {
    print("streamResult ${streamResult.size}");

    List<DateTimeRange> converted = [];
    for (var i = 0; i < streamResult.size; i++) {
      final item = streamResult.docs[i].data();
      converted.add(
          DateTimeRange(start: (item.bookingStart!), end: (item.bookingEnd!)));
    }
    print("egagwe ${converted.toList().toString()}");
    return converted;
  }

  Future<dynamic> uploadBookingFirebase(
      {required BookingService newBooking}) async {
    detailPagecontroller.cartServicesForBookingpage.forEach((element) async {
      await detailPagecontroller.removeRecord(element.serviceId);
    });
    detailPagecontroller.cartServicesForBookingpage.clear();
    detailPagecontroller.getCartList(widget.salonid);

    print("clear bookings");
    print(
        "after bookings   ${detailPagecontroller.cartServicesForBookingpage.toSet().toString()}");

    await bookings
        .doc(widget.salonid)
        .collection('bookings')
        .add(newBooking.toJson())
        .then((value) => print("Booking Added ${value.get().toString()}"))
        .catchError((error) => print("Failed to add booking: $error"));
    Get.back();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    servicelist.clear();
    for (var element in detailPagecontroller.cartServicesForBookingpage.obs) {
      servicelist.add(element.serviceId);
    }
    print("service List :: ${servicelist.toSet().toString()}");

    return SafeArea(
        child: Scaffold(
      backgroundColor: MyThemes.lightblack,
      body: Container(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MyThemes.darkblack,
              ),
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("SALOON Name :",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text("${widget.salonName}",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: MyThemes.txtdarkwhite)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MyThemes.darkblack,
              ),
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("ADDRESS :",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                          "A-73, Rander Bus Stop, Rander, Surat - 395005, Opposite Rander Health Center",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: MyThemes.txtdarkwhite)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MyThemes.darkblack,
              ),
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("SERVICES :",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Divider(
                      color: MyThemes.purple,
                    ),
                    GetBuilder<DetailPageController>(builder: (controller) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Final_cart(
                            cartServicesForBookingpage:
                                controller.cartServicesForBookingpage[index],
                            removeFromCart: () async {
                              print("dfhsdfh before  ${await controller.cartServicesForBookingpage.toList().toString()}");
                              print("dfhsdfh remove  ${controller.cartServicesForBookingpage[index].serviceId}");
                              await controller.removeRecord(controller
                                  .cartServicesForBookingpage[index].serviceId);
                              await controller.getCartList(controller
                                  .cartServicesForBookingpage[index].salonId);
                              await controller.loadCartServices();
                              if (controller
                                  .cartServicesForBookingpage.isEmpty) {
                                Navigator.pop(context);
                              }
                              setState(() {});
                            },
                          );
                        },
                        itemCount: detailPagecontroller
                            .cartServicesForBookingpage.length,
                        shrinkWrap: true,
                      );
                    }),
                    GetBuilder<DetailPageController>(builder: (controller) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          // "TOTAL PAYABLE AMOUNT :  RS. ${controller.cartServicesForBookingpage.map((e) => e.price).toList().reduce((value, element) => value + element)}",
                          "TOTAL PAYABLE AMOUNT :  RS. ${controller.cartservicetotal}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 600,
            child: BookingCalendar(
              bookingService: BookingService(
                servicesId: servicelist,
                serviceName: detailPagecontroller.modelforintent!.uid,
                serviceDuration: 30,
                bookingStart: DateTime(now.year, now.month, now.day, 9, 0),
                bookingEnd: DateTime(now.year, now.month, now.day, 22, 0),
                userName: detailPagecontroller.modelforintent!.name +
                    " " +
                    detailPagecontroller.modelforintent!.surname,
                userId: detailPagecontroller.modelforintent!.uid,
                userEmail: detailPagecontroller.modelforintent!.email,
                userPhoneNumber:
                    detailPagecontroller.modelforintent!.mobilenumber,
                servicePrice: int.parse(
                  detailPagecontroller.cartservicetotal.toString(),
                ),
              ),
              convertStreamResultToDateTimeRanges: convertStreamResultFirebase,
              getBookingStream: getBookingStreamFirebase,
              uploadBooking: uploadBookingFirebase,
              uploadingWidget: Center(
                child: const CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              loadingWidget: const Text('Fetching data...'),
              hideBreakTime: false,
              pauseSlotText: 'Not Available',
              pauseSlots: generatePauseSlots(),
              bookingButtonColor: MyThemes.purple,
              bookingButtonText: "Book Now",
              availableSlotColor: Colors.green,
            ),
          ),
        ],
      )),
    ));
  }
}
