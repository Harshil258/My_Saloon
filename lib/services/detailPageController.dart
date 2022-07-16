import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:my_saloon/models/databaseModel.dart';
import 'package:my_saloon/services/itemService.dart';

import '../constants.dart';
import '../models/servicemodel.dart';

class DetailPageController extends GetxController {
  ItemService itemService = ItemService();
  List<databaseModel> databasemodellist = [];
  List<databaseModel> cartlist = [];
  List<servicemodel> mainCartList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadDB();
  }

  loadDB() async {
    await itemService.openDB();
  }



  getCartList(String salonid) async {
    // try {
      List list = await itemService.getCartList();
      print("sdgsdgsdgsdgsdg ${list}");
      databasemodellist.clear();
      list.forEach((element) {
        databasemodellist.add(databaseModel.fromJson(element));
      });
      if (databasemodellist
              .indexWhere((element) => element.documentid == salonid) >
          -1) {
        cartlist = await itemService.getPerticularList(salonid);
      }

      Client client = Client(endPoint: AppConstsnts.endPoint);
      client.setProject(AppConstsnts.project);
      client.setSelfSigned(status: true);

      cartlist.forEach((element) {
        final databases = Database(client);
        Future result = databases.getDocument(
          collectionId: salonid,
          documentId: element.serviceId,
        );
        result.then((value) {
          print("afhfdhsfghfsgh  $value");
        }).catchError((onError) {
          print("afhfdhsfghfsgh  $onError");
        });
      });

    // } catch (e) {
    //   // print("fghdfghdfgh  $e");
    // }
  }

  addToCart(String salonid, String serviceid, bool addedToCart,
      bool bookedOrNot, String timeSlot){
    itemService.saveRecord(salonid, serviceid, addedToCart, bookedOrNot, timeSlot);
  }

/*
   database columns
   documentid(salon id)
   services id
  */
}
