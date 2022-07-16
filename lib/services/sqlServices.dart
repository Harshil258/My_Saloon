import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sqlServices {
  Database? db;

  Future openDb() async {
    try {
      var databasepath = await getDatabasesPath();
      print("database path : ${databasepath}");
      String path = join(databasepath, 'cart.db');
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) {
          this.db = db;
          createTables();
        },
      );
      print("opendatabase  database ${db.toString()}");
    } catch (e) {
      print("error in creating database : ${e}");
    }
  }

  createTables() async {
    try {
      var query = "CREATE TABLE IF NOT EXISTS CART "
          "(documentid TEXT PRIMARY KEY, "
          "service_id TEXT, "
          "addedToCart INTEGER, "
          "bookedOrNot INTEGER, "
          "timeslot TEXT)";
      await db?.execute(query);
      print("table created");
      var query2 =
          'INSERT INTO CART (documentid , service_id, addedToCart, bookedOrNot, timeSlot) '
          'VALUES("124245","aseryserty",1,1,"rtyewrtyert")';
      await db?.execute(query2);
      var query3 =
          'INSERT INTO CART (documentid , service_id, addedToCart, bookedOrNot, timeSlot) '
          'VALUES("stdufsdgjhfg","aseryserty",1,1,"rtyewrtyert")';
      await db?.execute(query3);

      var list = await db?.rawQuery('SELECT * FROM CART', []);
      print("sdgsdgsdgdsg  ${list.toString()}");
    } catch (e) {
      print("ERROR IN CREATE TABLE");
      print(e);
    }
  }

  Future saveRecord(String salonid, String serviceid, bool addedToCart,
      bool bookedOrNot, String timeSlot) async {
    // try{
    print(
        'sdgsfdgsgsgsgsdgsgsdg  INSERT INTO CART (documentid , service_id, addedToCart, bookedOrNot, timeSlot) VALUES("${salonid}","${serviceid}",${addedToCart ? 1 : 0},${bookedOrNot ? 1 : 0},"${timeSlot}")');
    await db!.transaction((txn) async {
      var query =
          'INSERT INTO CART (documentid , service_id, addedToCart, bookedOrNot, timeSlot) '
          'VALUES("${salonid}","${serviceid}",${addedToCart ? 1 : 0},${bookedOrNot ? 1 : 0},"${timeSlot}")';
      await txn.rawInsert(query);
      print("record inserted successfully ");
    });
    print("sdgsdgsdgsdgdgdg11111111111");
    // }catch(e){
    //   print("sdgsdgsdgsdgdgdg  ${e}");
    //
    // }
  }

  Future getPerticularList(String salonid) async {
    try {
      var list = await db
          ?.rawQuery('SELECT * FROM CART where documentid = ${salonid}', []);
      return list ?? [];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future getCartList() async {
    // try {
      // var query2 =
      //     'INSERT INTO CART (documentid , service_id, addedToCart, bookedOrNot, timeSlot) '
      //     'VALUES("124245","aseryserty",1,1,"rtyewrtyert")';
      // await db?.execute(query2);

      // await this.db!.transaction((txn) async{
      //   var list =  txn.execute("SELECT * FROM CART",[]);
      //   print("getcartlist ${list.toString()}");
      // });
    print("select  database ${db.toString()}");
    var list = await db?.rawQuery('SELECT * FROM CART', []);
      print("getcartlist ${list.toString()}");
      return list ?? [];
    // } catch (e) {
    //   return Future.error(e);
    // }
  }

  Future<bool> bookedOrNot(String documentid) async {
    try {
      var record = await db
          ?.rawQuery('SELECT * FROM CART where documentid = ${documentid}', []);
      List list = record!.toList();

      if (list.elementAt(4) == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future removeFromCart(String salonid) async {
    if (bookedOrNot(salonid) == false) {
      var query = "DELETE FROM CART where documentid = ${salonid}";
      return await this.db?.rawDelete(query);
    } else {
      var query = "UPDATE CART set addedToCart = ?";
      return await this.db?.rawUpdate(query, [0]);
    }
  }
}
