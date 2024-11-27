

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_pbl6/main.dart';
import 'package:app_pbl6/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  await Future.delayed(const Duration(seconds: 2)); // Add a delay for splash effect

  if (!mounted) return; // Check if the widget is still in the widget tree

  if (token != null && token.isNotEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/homeimages/3.jpg', // Logo của ứng dụng (thay thế bằng đường dẫn logo của bạn)
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD64820)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Đang kiểm tra trạng thái đăng nhập...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
