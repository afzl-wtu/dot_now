import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sembast/sembast.dart';

import '../helpers/database_helper.dart';

class AuthModel {
  UserModel? user;

  Future<void> fetchUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      final _db = await DatabaseManager.instance.database;
      var store = StoreRef.main();

      var phone = await store.record('phone').get(_db);
      if (phone != null) user = UserModel(phone);

      _db.close();
    }
  }

  Future<void> signInWithPhonePassword(String phone, String password) async {
    DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("users");
    final _snap = await _dbRef.ref.orderByChild("phone").equalTo(phone).get();
    if (_snap.value == null) {
      print('No User Found');
      return;
    }
    Map data = _snap.value as Map<String, String>;
    data.forEach((key, value) {
      if (password == value['password']) {
        print("User Exist");
      } else {
        print('Wrong Password');
      }
    });
  }

  Future<void> signUpWithPhonePassword(String phone, String password) async {
    user = UserModel(phone);
    final _db = await DatabaseManager.instance.database;
    DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("users");
    await _dbRef.child(phone).set({'password': password});
    var store = StoreRef.main();
    await store.record('phone').put(_db, phone);
    _db.close();
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
