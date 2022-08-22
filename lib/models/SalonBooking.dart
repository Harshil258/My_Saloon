// To parse this JSON data, do
//
//     final salonBooking = salonBookingFromJson(jsonString);
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SalonBooking salonBookingFromJson(String str) =>
    SalonBooking.fromJson(json.decode(str));

String salonBookingToJson(SalonBooking data) => json.encode(data.toJson());

class SalonBooking {
  SalonBooking({
    required this.uid,
    required this.userName,
    required this.placeId,
    required this.serviceName,
    required this.serviceDuration,
    required this.servicePrice,
    required this.bookingStart,
    required this.bookingEnd,
    required this.email,
    required this.phoneNumber,
    required this.placeAddress,
  });

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now()); //To TimeStamp
  }

  static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  String uid;
  String userName;
  String placeId;
  String serviceName;
  int serviceDuration;
  int servicePrice;
  DateTime bookingStart;
  DateTime bookingEnd;
  String email;
  String phoneNumber;
  String placeAddress;

  factory SalonBooking.fromJson(Map<String, dynamic> json) => SalonBooking(
        uid: json["uid"],
        userName: json["userName"],
        placeId: json["placeId"],
        serviceName: json["serviceName"],
        serviceDuration: json["serviceDuration"],
        servicePrice: json["servicePrice"],
        bookingStart: timeStampToDateTime(json["bookingStart"]),
        bookingEnd: timeStampToDateTime(json["bookingEnd"]),
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        placeAddress: json["placeAddress"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "userName": userName,
        "placeId": placeId,
        "serviceName": serviceName,
        "serviceDuration": serviceDuration,
        "servicePrice": servicePrice,
        "bookingStart": dateTimeToTimeStamp(bookingStart),
        "bookingEnd": dateTimeToTimeStamp(bookingEnd),
        "email": email,
        "phoneNumber": phoneNumber,
        "placeAddress": placeAddress,
      };
}
