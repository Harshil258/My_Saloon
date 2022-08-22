// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  Usermodel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.mobilenumber,
    required this.address,
    required this.photo
  });

  String uid;
  String name;
  String surname;
  String email;
  String mobilenumber;
  String address;
  String photo;

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
    uid: json["uid"],
    name: json["Name"],
    surname: json["Surname"],
    email: json["email"],
    mobilenumber: json["mobilenumber"],
    address: json["address"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "Name": name,
    "Surname": surname,
    "email": email,
    "mobilenumber": mobilenumber,
    "address": address,
    "photo": photo,
  };
}
