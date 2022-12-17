import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../models/servicemodel.dart';
import '../models/userData.dart';
import 'auth.dart';
import 'detailPageController.dart';

class FirebaseService {


  Future<List<ServiceModel>> loadservicesFromfirebase(String salonid) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('service');
    QuerySnapshot snapshot =
        await collection.where('salon_id', isEqualTo: salonid).get();

    return await List.from(
        snapshot.docs.map((element) => fromQuerySnapshotService(element)));
  }

  Future<Usermodel> getuserdata() async {
    User? user = await Authentication.getUserId();
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot<Object?> model = await collection.doc(user!.uid).get();
    print("Current user : ${user!.uid}");
    print("Current user : ${model.data().toString()}");
    if(model.data().isNull){
      return Usermodel(
          uid: "",
          name: "",
          surname: "",
          email: "",
          mobilenumber: "",
          address: "",
          photo: "");
    }else{
      return Usermodel(
          uid: model.get("uid"),
          name: model.get("Name"),
          surname: model.get("Surname"),
          email: model.get("email"),
          mobilenumber: model.get("mobilenumber"),
          address: model.get("address"),
          photo: model.get("photo"));
    }

  }

  Future<String?> storeData(String userid, String name, String surname,
      String email, String phoneno, String address,String photo) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('Users');
      collection.doc(userid).set({
        "uid":userid,
        "Name": name,
        "Surname": surname,
        "email": email,
        "mobilenumber": phoneno,
        "address": address,
        "photo" : photo
      });
      return 'success';
    } on Exception catch (e) {
      return 'Error adding user  ${e.toString()}';
    }
  }

  Future<List<ServiceModel>> getfilteredServices(String gender) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('service');
    QuerySnapshot snapshot =
        await collection.where('gender', isEqualTo: gender).get();


    return await List.from(
        snapshot.docs.map((element) => fromQuerySnapshotService(element)));
  }

  Future<String?> uploadImage(PickedFile file,String name) async {
    final _firebaseStorage = FirebaseStorage.instance;
    try {
      print("sadgsdgdg   ${file.path}");
      if (file != null) {
        var snapshot = await _firebaseStorage
            .ref()
            .child('Users/Profiles/${name}')
            .putFile(File(file.path));
        var downloadUrl = await snapshot.ref.getDownloadURL();
        print("sadgsdgdg   ${downloadUrl}");
        return downloadUrl;
      } else {
        print('No Image Path Received');
      }
    } on Exception catch (e) {
      return 'Error adding image  ${e.toString()}';
    }
  }
}
