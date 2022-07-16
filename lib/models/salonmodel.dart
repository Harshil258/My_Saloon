// To parse this JSON data, do
//
//     final mainModel = mainModelFromJson(jsonString);
import 'dart:convert';

MainModel mainModelFromJson(String str) => MainModel.fromJson(json.decode(str));

String mainModelToJson(MainModel data) => json.encode(data.toJson());

class MainModel {
  MainModel({
    required this.id,
    required this.salonId,
    required this.salonName,
    required this.services,
    required this.image,
    required this.rating,
    required this.address,
  });

  String salonId;
  String salonName;
  List<dynamic> services;
  String image;
  List<dynamic> rating;
  String address;
  String id;

  factory MainModel.fromJson(Map<String, dynamic> json) {
    print("asdgsdgsdgdg  ${json["\$id"]}");
    return MainModel(
        salonId: json["salon_id"],
        salonName: json["salon_name"],
        services: List<dynamic>.from(json["services"].map((x) => x)),
        image: json["image"],
        rating: List<dynamic>.from(json["rating"].map((x) => x)),
        address: json["address"],
        id: json["\$id"]);
  }

  Map<String, dynamic> toJson() => {
        "salon_id": salonId,
        "salon_name": salonName,
        "services": List<dynamic>.from(services.map((x) => x)),
        "image": image,
        "rating": List<dynamic>.from(rating.map((x) => x)),
        "address": address,
        "id" : id
      };
}
