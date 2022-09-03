import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:dot_now/screens/shopping_page.dart';
import 'package:dot_now/screens/sign_in.dart';
import 'package:dot_now/core.dart';
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
      extendBody: true,
      bottomNavigationBar: DotNavigationBar(
        backgroundColor: const Color(0xFFF36616),
        //currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: (_) {},
        // dotIndicatorColor: Colors.black,
        items: _navBarItems,
      ),
      body: PageView(
        children: [
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       const Text(
          //         'Welcome',
          //         textAlign: TextAlign.center,
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       ElevatedButton(
          //         onPressed: (() {
          //           _auth.signOut();
          //           store.auth.logout();
          //           Navigator.of(context).pushReplacement(
          //             MaterialPageRoute(
          //               builder: (_) => const SignInPage(),
          //             ),
          //           );
          //         }),
          //         child: const Text('Logout'),
          //       ),
          //     ],
          //   ),
          // ),
          const ShoppingPage(),
        ],
      ),
    );
  }

  List<DotNavigationBarItem> get _navBarItems {
    return [
      /// Home
      DotNavigationBarItem(
          icon: const Icon(Icons.home),
          selectedColor: const Color(0xFF126881),
          unselectedColor: Colors.white),

      /// Likes
      DotNavigationBarItem(
          icon: const Icon(Icons.favorite),
          selectedColor: const Color(0xFF126881),
          unselectedColor: Colors.white),

      /// Profile
      DotNavigationBarItem(
          icon: const Icon(Icons.person),
          selectedColor: const Color(0xFF126881),
          unselectedColor: Colors.white),
    ];
  }
}
