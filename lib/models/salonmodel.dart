// To parse this JSON data, do
//
//     final salonModel = salonModelFromJson(jsonString);

import 'dart:convert';

SalonModel salonModelFromJson(String str) =>
    SalonModel.fromJson(json.decode(str));

String salonModelToJson(SalonModel data) => json.encode(data.toJson());

SalonModel fromQuerySnapshot(snapshot) {
  print("Salon list querySnapshot converting ${snapshot.data()['location']}");
  return SalonModel(
    location: snapshot.data()['location'],
    salonName: snapshot.data()['salon_name'],
    image: snapshot.data()['saloonimage'],
    address: snapshot.data()['address'],
    salonId: snapshot.data()['salon_id'],
    category: snapshot.data()['category'],
    mobilenumber: snapshot.data()['owner_mobilenumber'],
  );
}

class SalonModel {
  SalonModel(
      {required this.salonId,
      required this.location,
      required this.salonName,
      required this.image,
      required this.address,
      required this.category,
      required this.mobilenumber});

  String salonId;
  String location;
  String salonName;
  String image;
  String address;
  String category;
  String mobilenumber;

  factory SalonModel.fromJson(Map<String, dynamic> json) => SalonModel(
        salonId: json["salon_id"],
        location: json["location"],
        salonName: json["salon_name"],
        image: json["saloonimage"],
        address: json["address"],
        category: json["category"],
        mobilenumber: json["mobilenumber"],
      );

  Map<String, dynamic> toJson() => {
        "salon_id": salonId,
        "location": location,
        "salon_name": salonName,
        "saloonimage": image,
        "address": address,
        "category": category,
        "mobilenumber": mobilenumber,
      };
}
