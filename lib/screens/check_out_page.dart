import 'package:cool_alert/cool_alert.dart';
import 'package:dot_now/widgets/large_round_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CheckOutPage extends StatefulWidget {
  final int cartTotal;

  const CheckOutPage({Key? key, required this.cartTotal}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final _descriptionController = TextEditingController();

  var _sendAsaDropshipper = false;

  int _deliverCharges = 200;

  @override
  void dispose() {
    _descriptionController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Color(0xff788187)),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Checkout',
            style: TextStyle(
              color: Color(0xff788187),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    cardWithPadding(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Shipping Address'),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Edit'),
                              ),
                            ],
                          ),
                          const Divider(),
                          const Text(
                            'User Name',
                            style: TextStyle(fontSize: 20),
                          ),
                          const Text('xyz , \ncity xyz, \nPunjab, Pakistan')
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    cardWithPadding(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Add Description'),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(20)),
                            child: TextField(
                              controller: _descriptionController,
                              minLines: 4,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    cardWithPadding(Column(
                      children: [
                        Row(
                          children: [
                            const Text('Payment Method'),
                            const Spacer(),
                            DropdownButton<Text>(
                              items: const [
                                DropdownMenuItem(
                                  child: Text('Payment on Delivery'),
                                ),
                              ],
                              onChanged: (_) {},
                            ),
                          ],
                        ),
                        const Divider(),
                        _row('Subtotal for products',
                            widget.cartTotal.toString()),
                        _row('Delivery Charges', _deliverCharges.toString()),
                        _row('Total',
                            (widget.cartTotal + _deliverCharges).toString()),
                      ],
                    )),
                    const SizedBox(
                      height: 5,
                    ),
                    cardWithPadding(
                      Row(
                        children: [
                          const Text('Send As a Dropshipper'),
                          const Spacer(),
                          Switch(
                              value: _sendAsaDropshipper,
                              onChanged: (val) {
                                setState(() {
                                  _sendAsaDropshipper = val;
                                });
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              cardWithPadding(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          'Rs. ${widget.cartTotal + _deliverCharges}',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        context: context,
                        builder: (_) => Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Enter your Pin'),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Pinput(),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text('Forgot Pin?'))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      CoolAlert.show(
                                          confirmBtnText: 'Continue Shopping',
                                          context: context,
                                          type: CoolAlertType.success,
                                          text:
                                              "Your Order Placed Successfully",
                                          onConfirmBtnTap: () =>
                                              Navigator.of(context).pop());
                                    },
                                    child: const LargeRoundButton(
                                      color: Colors.blue,
                                      text: 'Buy',
                                      fullLength: true,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: const LargeRoundButton(
                        color: Colors.blue,
                        text: 'Buy Now',
                        fullLength: true,
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Card cardWithPadding(Widget child) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: child,
        ),
      );
  Row _row(String start, String end) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(start), Text(end)],
      );
}
