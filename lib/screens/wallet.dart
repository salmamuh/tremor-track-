import 'package:flutter/material.dart';
import 'package:tremor_track/auth/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/paymob_manager.dart';
bool pay = false;

class WalletPage extends StatefulWidget {

  @override
  _WalletPageState createState() => _WalletPageState();
}


class _WalletPageState extends State<WalletPage> {

 // Initial balance
  late int _balance=0;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }
  Future<void> _fetchBalance() async {
    int? balance = await AuthService().getUserBalance();
    if (balance != null) {
      setState(() {
        _balance = balance;
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4FFFE),
      appBar: AppBar(
        title: Text('Wallet Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Balance: $_balance',
              style: TextStyle(fontSize: 24),
            ),
            // SizedBox(height: 16),
            // TextField(
            //   controller: _amountController,
            //   keyboardType: TextInputType.number,
            //   decoration: InputDecoration(
            //     labelText: 'Enter amount of points',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (value) {
            //     setState(() {
            //       _amount = int.tryParse(value) ?? 0; // Parse the input to an integer, default to 0 if parsing fails
            //     });
            //   },
            // ),
            // SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         _pay(_amount);
            //         setState(() {
            //           _updateBalance();
            //         });
            //       },
            //       child: Text('Buy Points'),
            //     ),
            //   ],
            // ),

          ],
        ),
      ),
    );
  }
  Future<void> _pay(int amount) async {
    try {
      String paymentKey = await PaymobManager().getPaymentKey(amount, "EGP");
      await launch(
        "https://accept.paymob.com/api/acceptance/iframes/844284?payment_token=$paymentKey",
      );
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        pay = true;
      });
    } catch (e) {
      print("Error during payment: $e");
    }
  }
}

