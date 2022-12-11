import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_saloon/models/databaseModel.dart';
import 'package:my_saloon/services/itemService.dart';

import '../models/salonmodel.dart';
import '../models/servicemodel.dart';
import '../models/userData.dart';

class DetailPageController extends GetxController {
  ItemService itemService = ItemService();
  List<SalonModel> salonlist = [];
  List<DatabaseModel> cartlist = [];
  List<ServiceModel>  servicemodellist = [];
  List<ServiceModel>  cartServicesForBookingpage = [];
  bool isusermodelinitilize = false;
  Usermodel? modelforintent = null;
  var cartservicetotal = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDB();
  }

  loadservicesFromfirebase(String salonid) async{
    servicemodellist = await itemService.loadservicesFromfirebase(salonid);
    getCartList(salonid);
  }


  Future<List<SalonModel>> callfirebase() async {
    final CollectionReference collection =
    FirebaseFirestore.instance.collection('salons');
    QuerySnapshot querySnapshot = await collection.get();

    salonlist = List.from(
        querySnapshot.docs.map((element) => fromQuerySnapshot(element)));
    return salonlist;
  }

  Future<bool> getuserdata() async{
    modelforintent = (await itemService.getuserdata());
    print("model class modelforintent : ${modelforintent!.name}");

    // update();
    if(modelforintent!.uid != ""){
      isusermodelinitilize = true;
      return true;
    }else{
      return false;
    }
    print("sadgsdgdg   ${modelforintent!.surname}");
  }

  Future<List<ServiceModel>> loadgetfilteredServices(String gender) async{
    return await itemService.loadgetfilteredServices(gender);
  }

  loadCartServices() async {
    cartServicesForBookingpage = [];
    cartservicetotal = 0.obs;
    for(var ele in servicemodellist){
      if(cartlist.indexWhere((element) => element.serviceId == ele.serviceId) > -1){
        print("ele ${ele.serviceId.toString()}");
        cartServicesForBookingpage.add(ele);
        cartservicetotal = cartservicetotal + ele.price;
      }
    }
  }

  loadDB() async {
    await itemService.openDB();
  }

  getCartList(String salonid) async {
    try {
      List list = await itemService.getPerticularList(salonid);
      cartlist.clear();
      for(var element in list){
        cartlist.add(DatabaseModel.fromJson(element));
      }
      update();

    } catch (e) {
      print("fghdfghdfgh  $e");
    }
  }

  addToCart(String salonid, String serviceid, bool addedToCart){
    itemService.saveRecord(salonid, serviceid, addedToCart);
    update();
  }

  removeRecord(String service_id) async {
    await itemService.removeRecord(service_id);
    print("removecall ${cartServicesForBookingpage.length}");
    update();
  }

  deleteTable() async{
    await itemService.deleteTable();
  }

  bool addedInCartOrNot(String service_id){
    return cartlist.indexWhere((element) => element.serviceId == service_id) > -1;
  }

  Future<String?> loadUser(String userid, String name, String surname,
      String email, String phoneno,String address,String photo) async {
    return await itemService.loadUser(userid,name,surname,email,phoneno,address,photo);
  }

  Future<String?> uploadImage(PickedFile file,String name) async{
    return await itemService.uploadImage(file,name);
  }
}
