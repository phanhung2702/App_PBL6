import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;

  PaymentWebViewPage({required this.paymentUrl});

  @override
  PaymentWebViewPageState createState() => PaymentWebViewPageState();
}

class PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView();  // Đảm bảo sử dụng WebView cho Android
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thanh toán"),
      ),
      body: WebView(
        initialUrl: widget.paymentUrl,
        javascriptMode: JavascriptMode.unrestricted,  // Cho phép thực thi JavaScript
        onWebViewCreated: (WebViewController webViewController) {
          controller = webViewController;
        },
        onPageStarted: (String url) {
         
        },
        onPageFinished: (String url) {
          
        },
      ),
    );
  }
}
