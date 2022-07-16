// To parse this JSON data, do
//
//     final mainModel = mainModelFromJson(jsonString);
import 'dart:convert';

databaseModel mainModelFromJson(String str) => databaseModel.fromJson(json.decode(str));

String mainModelToJson(databaseModel data) => json.encode(data.toJson());

class databaseModel {
  databaseModel({
    required this.documentid,
    required this.serviceId,
    required this.addedToCart,
    required this.bookedOrNot,
    required this.timeslot,
  });

  final String documentid;
  final String serviceId;
  final int addedToCart;
  final int bookedOrNot;
  final String timeslot;

  factory databaseModel.fromJson(Map<String, dynamic> json) => databaseModel(
    documentid: json["documentid"],
    serviceId: json["service_id"],
    addedToCart: json["addedToCart"],
    bookedOrNot: json["bookedOrNot"],
    timeslot: json["timeslot"],
  );

  Map<String, dynamic> toJson() => {
    "documentid": documentid,
    "service_id": serviceId,
    "addedToCart": addedToCart,
    "bookedOrNot": bookedOrNot,
    "timeslot": timeslot,
  };
}
