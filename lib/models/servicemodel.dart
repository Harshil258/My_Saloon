// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) =>
    ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

ServiceModel fromQuerySnapshotService(snapshot) {
  return ServiceModel(
      title: snapshot.data()['Title'],
      description: snapshot.data()['description'],
      price: snapshot.data()['Price'],
      image: snapshot.data()['image'],
      salonId: snapshot.data()['salon_id'],
      serviceId: snapshot.data()['service_id']);
}

class ServiceModel {
  ServiceModel({
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.salonId,
    required this.serviceId,
  });

  String title;
  int price;
  String description;
  String image;
  String salonId;
  String serviceId;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        title: json["Title"],
        price: json["Price"],
        description: json["description"],
        image: json["image"],
        salonId: json["salon_id"],
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Price": price,
        "description": description,
        "image": image,
        "salon_id": salonId,
        "service_id": serviceId,
      };
}
