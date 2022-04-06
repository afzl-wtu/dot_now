import 'package:dot_now/screens/sign_in.dart';
import 'package:dot_now/vx_state/vx_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vxstate/vxstate.dart';

class HomeScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = VxState.store as MyStore;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: (() {
                _auth.signOut();
                store.auth.logout();
              }),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
