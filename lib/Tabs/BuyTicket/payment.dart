import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentPage({super.key, required this.paymentUrl});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  Future<void> _launchPaymentUrl(String url) async {
  final Uri uri = Uri.parse(url);

  try {
    bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Mở URL trong trình duyệt bên ngoài
    );

    if (!launched) {
      throw 'Không thể mở URL: $url';
    }
  } catch (e) {
    debugPrint('Error launching URL: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể mở URL: $url'),
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _launchPaymentUrl(widget.paymentUrl),
          child: const Text('Thanh toán ngay'),
        ),
      ),
    );
  }
}
