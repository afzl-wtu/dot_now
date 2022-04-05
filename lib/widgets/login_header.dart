import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginHeader extends StatelessWidget {
  final String heading;
  final String body;
  final Widget? button;
  const LoginHeader({
    Key? key,
    required this.heading,
    required this.body,
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.deepOrange,
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [if (button != null) button!],
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      heading,
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      body,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
