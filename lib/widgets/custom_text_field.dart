import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final Widget? suffix;
  final TextEditingController controller;
  const CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    this.suffix,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showSuffix = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            if (value.length == 12) {
              showSuffix = true;
            } else {
              showSuffix = false;
            }
          });
        },
        controller: widget.controller,
        keyboardType: widget.isPassword ? null : TextInputType.number,
        inputFormatters:
            widget.isPassword ? null : [TextInputMask(mask: '9999 9999999')],
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          suffix: showSuffix ? widget.suffix : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          label: Text(widget.label),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
