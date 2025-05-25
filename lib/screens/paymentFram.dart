import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tremor_track/models/paymob_manager.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController _webViewController;
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'about:blank',
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _loadPaymentPage();
            },
            onPageFinished: (url) {
              setState(() {
                _loading = false;
              });
            },
          ),
          if (_loading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _loadPaymentPage() async {
    try {
      String paymentKey = await PaymobManager().getPaymentKey(50, "EGP");
      await _webViewController.loadUrl(
        "https://accept.paymob.com/api/acceptance/iframes/844284?payment_token=$paymentKey",
      );
    } catch (e) {
      print("Error loading payment page: $e");
      // Handle error loading payment page
    }
  }
}
