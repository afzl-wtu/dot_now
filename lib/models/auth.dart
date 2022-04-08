import 'package:firebase_database/firebase_database.dart';
import 'package:sembast/sembast.dart';

import '../helpers/database_helper.dart';

class AuthModel {
  UserModel? user;

  Future<void> fetchUser() async {
    final _db = await DatabaseManager.instance.database;
    var store = StoreRef.main();
    var phone = await store.record('phone').get(_db);
    if (phone != null) user = UserModel(phone);
    _db.close();
  }

  Future<void> signInWithPhonePassword(String phone, String password) async {
    DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("users");
    final _snap = await _dbRef.ref.orderByKey().equalTo(phone).get();
    if (_snap.value == null) {
      throw Exception('User Not Found');
    }
    Map data = _snap.value as Map;
    if (password == data[phone]['password']) {
      final _db = await DatabaseManager.instance.database;
      var store = StoreRef.main();
      await store.record('phone').put(_db, phone);
      _db.close();
      return;
    } else {
      throw Exception('Wrong Password');
    }
  }

  Future<void> signUpWithPhonePassword(String phone, String password) async {
    user = UserModel(phone);
    DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("users");
    await _dbRef.child(phone).set({'password': password});
    final _db = await DatabaseManager.instance.database;
    var store = StoreRef.main();
    await store.record('phone').put(_db, phone);
    user = UserModel(phone);
    _db.close();
    return;
  }

  Future<void> logout() async {
    final _db = await DatabaseManager.instance.database;
    var store = StoreRef.main();
    await store.record('phone').delete(_db);
    user = null;
    _db.close();
  }
}

class UserModel {
  final String phoneNumber;
  UserModel(this.phoneNumber);
}
