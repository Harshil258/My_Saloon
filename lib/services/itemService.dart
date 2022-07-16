import 'package:my_saloon/services/sqlServices.dart';

class ItemService {
  sqlServices sqlService = sqlServices();

  Future openDB() async {
    return await sqlService.openDb();
  }

  Future getCartList() async {
    return await sqlService.getCartList();
  }

  Future getPerticularList(String salonid) async {
    return await sqlService.getPerticularList(salonid);
  }

  Future saveRecord(String salonid, String serviceid, bool addedToCart,
      bool bookedOrNot, String timeSlot) async {
    return await sqlService.saveRecord(
        salonid, serviceid, addedToCart, bookedOrNot, timeSlot);
  }
}
