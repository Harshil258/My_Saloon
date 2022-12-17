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
      rating2: List<Rating2>.from(snapshot.data()['rating'].map((item) {
        return Rating2(review: item['review'], rating: item['rating']);
      })),
      location: snapshot.data()['location'],
      salonName: snapshot.data()['salon_name'],
      image: snapshot.data()['image'],
      address: snapshot.data()['address'],
      salonId: snapshot.data()['salon_id'],
      category: snapshot.data()['category']);
}

class SalonModel {
  SalonModel(
      {required this.rating2,
      required this.salonId,
      required this.location,
      required this.salonName,
      required this.image,
      required this.address,
      required this.category});

  List<Rating2> rating2;
  String salonId;
  String location;
  String salonName;
  String image;
  String address;
  String category;

  factory SalonModel.fromJson(Map<String, dynamic> json) => SalonModel(
      rating2:
          List<Rating2>.from(json["rating2"].map((x) => Rating2.fromJson(x))),
      salonId: json["salon_id"],
      location: json["location"],
      salonName: json["salon_name"],
      image: json["image"],
      address: json["address"],
      category: json["category"]);

  Map<String, dynamic> toJson() => {
        "rating2": List<dynamic>.from(rating2.map((x) => x.toJson())),
        "salon_id": salonId,
        "location": location,
        "salon_name": salonName,
        "image": image,
        "address": address,
        "category": category
      };
}

class Rating2 {
  Rating2({
    required this.review,
    required this.rating,
  });

  String review;
  int rating;

  factory Rating2.fromJson(Map<String, dynamic> json) => Rating2(
        review: json["review"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "review": review,
        "rating": rating,
      };
}
