import 'package:dot_now/screens/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import './screens/landing_page.dart';

class Logic extends StatelessWidget {
  Logic({Key? key}) : super(key: key);
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _firebaseAuth.idTokenChanges(),
        builder: (_, snap) {
          if (kDebugMode) {
            print(
                'PP: Connection State waiting: ${snap.connectionState == ConnectionState.waiting} , snap.data: ${snap.data} , snap.hasdata: ${snap.hasData}');
          }
          return snap.connectionState == ConnectionState.waiting
              ? const Material(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : snap.data != null
                  ? HomeScreen()
                  : const LandingPage();
        });
  }
}
