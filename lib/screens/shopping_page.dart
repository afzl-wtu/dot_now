import 'package:dot_now/screens/components/search_bar.dart';
import 'package:flutter/material.dart';

import 'package:dot_now/widgets/login_header.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF126881),
      body: Stack(
        children: [
          Column(
            children: [
              LoginHeader(
                height: 300,
                color: const Color(0xFF0B1A2D),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          'Categories',
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //ListView.builder(itemCount: ,itemBuilder: itemBuilder)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: buildFloatingSearchBar(context),
          ),
        ],
      ),
    );
  }
}
