import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final String heading;
  final Widget? child;
  final Color? color;
  final double height;
  final String body;
  final Widget? button;
  const LoginHeader({
    Key? key,
    this.heading = 'Null',
    this.height = 220,
    this.color,
    this.child,
    this.body = 'Null',
    this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.deepOrange,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: child ??
          Column(
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: color ?? Colors.deepOrange,
                actions: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [if (button != null) button!],
                  )
                ],
              ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          heading,
                          style: const TextStyle(
                              fontSize: 32, color: Colors.white),
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
