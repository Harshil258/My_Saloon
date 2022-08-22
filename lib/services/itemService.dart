import 'package:image_picker/image_picker.dart';
import 'package:my_saloon/services/FirebaseService.dart';
import 'package:my_saloon/services/sqlServices.dart';

import '../models/servicemodel.dart';
import '../models/userData.dart';

class ItemService {
  sqlServices sqlService = sqlServices();
  FirebaseService firebaseService = FirebaseService();

  Future openDB() async {
    return await sqlService.openDb();
  }

  Future getCartList() async {
    return await sqlService.getCartList();
  }

  Future getPerticularList(String salonid) async {
    return await sqlService.getPerticularList(salonid);
  }

  Future saveRecord(String salonid, String serviceid, bool addedToCart) async {
    return await sqlService.saveRecord(salonid, serviceid, addedToCart);
  }

  Future removeRecord(String service_id) async {
    return await sqlService.removeFromCart(service_id);
  }

  Future addedInCartOrNot(String service_id) async {
    return await sqlService.addedInCartOrNot(service_id);
  }

  Future loadservicesFromfirebase(String Salonid) async {
    return await firebaseService.loadservicesFromfirebase(Salonid);
  }

  Future<Usermodel> getuserdata() async {
    return await firebaseService.getuserdata();
  }

  Future<List<ServiceModel>> loadgetfilteredServices(String gender) async {
    return await firebaseService.getfilteredServices(gender);
  }

  Future<String?> loadUser(String userid, String name, String surname,
      String email, String phoneno, String address, String photo) async {
    return await firebaseService.storeData(
        userid, name, surname, email, phoneno, address, photo);
  }

  Future<String?> uploadImage(PickedFile file,String name) async {
    return await firebaseService.uploadImage(file,name);
  }
}
