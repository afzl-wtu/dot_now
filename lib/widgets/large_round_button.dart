import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LargeRoundButton extends StatelessWidget {
  final Color color;
  final String text;
  final bool fullLength;
  const LargeRoundButton({
    Key? key,
    required this.color,
    required this.text,
    this.fullLength = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: fullLength ? 40 : 0),
      width: fullLength ? double.infinity : 120,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: (text == 'f' || text == 'g')
            ? SvgPicture.asset(text == 'f'
                ? 'assets/svg/Facebook Logo.svg'
                : 'assets/svg/google logo.svg')
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
