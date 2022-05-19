import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

class PlusMinusButton extends StatefulWidget {
  final Function(int) updateBoxValue;
  final int digit;
  const PlusMinusButton(
    this.updateBoxValue,
    this.digit, {
    Key? key,
  }) : super(key: key);

  @override
  State<PlusMinusButton> createState() => _PlusMinusButtonState();
}

class _PlusMinusButtonState extends State<PlusMinusButton> {
  late TextEditingController _quantityController;
  @override
  void initState() {
    _quantityController = TextEditingController(text: '${widget.digit}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _quantityController.text =
                  (int.parse(_quantityController.text) + 1).toString();
              widget.updateBoxValue(int.parse(_quantityController.text));
            });
          },
          icon: const Icon(Icons.add, size: 20, color: Color(0xFFF36616)),
        ),
        Container(
          color: const Color(0xFFF6F6F7),
          height: 25,
          width: 40,
          child: TextField(
            inputFormatters: [TextInputMask(mask: '9999')],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                focusColor: Colors.transparent,
                enabledBorder: InputBorder.none),
            textAlign: TextAlign.center,
            controller: _quantityController,
            onChanged: (a) {
              if (a.isNotEmpty) {
                setState(() {
                  widget.updateBoxValue(int.parse(_quantityController.text));
                });
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
              color: const Color(0xFFF36616),
              onPressed: int.parse(_quantityController.text) < 2
                  ? null
                  : () {
                      setState(() {
                        _quantityController.text =
                            (int.parse(_quantityController.text) - 1)
                                .toString();
                        widget.updateBoxValue(
                            int.parse(_quantityController.text));
                      });
                    },
              icon: const Icon(
                Icons.remove,
                size: 20,
              )),
        ),
      ],
    );
  }
}
