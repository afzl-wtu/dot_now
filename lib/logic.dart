// ignore_for_file: dead_code
import 'package:dot_now/core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vxstate/vxstate.dart';

import 'screens/main_screen.dart';
import 'screens/landing_page.dart';

class Logic extends StatelessWidget {
  Logic({Key? key}) : super(key: key);
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final store = VxState.store as MyStore;
    return FutureBuilder(
      future: store.auth.fetchUser(),
      builder: (_, snap) {
        return true
            ? HomeScreen()
            : snap.connectionState == ConnectionState.waiting
                ? const Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : store.auth.user != null || _firebaseAuth.currentUser != null
                    ? HomeScreen()
                    : const LandingPage();
      },
    );
  }
}
