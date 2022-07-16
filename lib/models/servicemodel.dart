// To parse this JSON data, do
//
//     final mainModel = mainModelFromJson(jsonString);

import 'dart:convert';

servicemodel servicemodelFromJson(String str) =>
    servicemodel.fromJson(json.decode(str));

String servicemodelToJson(servicemodel data) => json.encode(data.toJson());

class servicemodel {
  servicemodel({
    required this.serviceId,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.salonId,
    required this.id,
  });

  int serviceId;
  String title;
  int price;
  String image;
  String description;
  String salonId;
  String id;

  factory servicemodel.fromJson(Map<String, dynamic> json) {
    print("srtjrtjryjtj ${json.toString()}");
    return servicemodel(
      serviceId: json["serviceId"],
      title: json["Title"],
      price: json["Price"],
      image: json["Image"],
      description: json["Description"],
      salonId: json["salon_id"],
      id: json["\$id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "serviceId": serviceId,
        "Title": title,
        "Price": price,
        "Image": image,
        "Description": description,
        "salon_id": salonId,
        "id": id,
      };
}
