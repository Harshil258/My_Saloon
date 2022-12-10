import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sqlServices {
  Future<Database> openDb() async {
    var databasepath = await getDatabasesPath();
    String path = join(databasepath, 'cart.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        var query = "CREATE TABLE IF NOT EXISTS CART "
            "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "documentid TEXT,"
            "service_id TEXT, "
            "addedToCart INTEGER);";
        db.execute(query);
      },
    );
  }

  Future saveRecord(String salonid, String serviceid, bool addedToCart) async {
    try {
      Database _db = await openDb();
      print(
          'sdgsfdgsgsgsgsdgsgsdg  INSERT INTO CART (documentid , service_id, addedToCart) VALUES("${salonid}","${serviceid}",${addedToCart ? 1 : 0}")');
      await _db.transaction((txn) async {
        var query = 'INSERT INTO CART (documentid , service_id, addedToCart) '
            'VALUES("${salonid}","${serviceid}",${addedToCart ? 1 : 0})';
        await txn.rawInsert(query);
        print("record inserted successfully ");
      });
      print("sdgsdgsdgsdgdgdg11111111111");
    } catch (e) {
      print("sdgsdgsdgsdgdgdg  ${e}");
    }
  }

  Future getPerticularList(String salonid) async {
    try {
      Database _db = await openDb();
      var list = await _db
          .rawQuery('SELECT * FROM CART where documentid = ?', [salonid]);
      print("sdfgsdgsdgd ${list.toList().toString()}");
      return list;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future getCartList() async {
    try {
      Database _db = await openDb();
      // print("select  database ${_db.toString()}");
      var list = await _db.rawQuery('SELECT * FROM CART', []);
      // print("getcartlist ${list.toString()}");
      return list;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> addedInCartOrNot(String service_id) async {
    try {
      Database _db = await openDb();
      var record = await _db
          .rawQuery('SELECT * FROM CART where service_id = ${service_id}', []);
      List list = record.toList();
      print("function addedInCartOrNot  ${list.length} ");

      if(list.length > 0){
        return true;
      }else{
        return false;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future deleteTables() async {
    Database _db = await openDb();
    var query = "DROP TABLE IF EXISTS CART;";
    _db.execute(query);
  }

  Future removeFromCart(String serviceid) async {
    Database _db = await openDb();
    print("removecall ${serviceid}");
    var query = "DELETE FROM CART WHERE service_id = '${serviceid}';";
    return await _db.rawDelete(query);
  }
}
