// To parse this JSON data, do
//
//     final mainModel = mainModelFromJson(jsonString);
import 'dart:convert';

DatabaseModel mainModelFromJson(String str) => DatabaseModel.fromJson(json.decode(str));

String mainModelToJson(DatabaseModel data) => json.encode(data.toJson());

class DatabaseModel {
  DatabaseModel({
    required this.documentid,
    required this.serviceId,
    required this.addedToCart
  });

  final String documentid;
  final String serviceId;
  final int addedToCart;

  factory DatabaseModel.fromJson(Map<String, dynamic> json) {
    print("ttttttttttt  ${json["documentid"]}     ${json["service_id"]}     ${json["addedToCart"]}");
    return DatabaseModel(
        documentid: json["documentid"],
        serviceId: json["service_id"],
        addedToCart: json["addedToCart"]);
  }


  Map<String, dynamic> toJson() => {
    "documentid": documentid,
    "service_id": serviceId,
    "addedToCart": addedToCart
  };
}
