import 'package:flutter/material.dart';
import 'package:app_pbl6/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:app_pbl6/Login/forgot_password.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Logger logger = Logger(); // Tạo logger

  void _login() async {
    if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập email và mật khẩu của bạn.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập email của bạn.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập mật khẩu của bạn.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/login'),
      body: json.encode({
        'username': _emailController.text,
        'password': _passwordController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['message'] == "Login successfully") {
        if (data['data'] != null && data['data']['access_token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          final accountData = data['data']['accountLogin'];
        
        await prefs.setString('token', data['data']['access_token']);
        await prefs.setInt('userId', accountData['id']);
        await prefs.setString('email', accountData['email']);
        await prefs.setString('name', accountData['name']);
        await prefs.setString('phoneNumber', accountData['phoneNumber'] ?? '');
        await prefs.setString('gender', accountData['gender'] ?? '');
        await prefs.setString('avatar', accountData['avatar'] ?? '');
        await prefs.setStringList('roles', List<String>.from(accountData['roles']));
          logger.w("Access Token đã lưu: ${data['data']['access_token']}");
        } else {
          logger.w("Access token không tồn tại trong phản hồi từ API.");
        }

        Future.delayed(Duration.zero, () {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          }
        });
      }
    } else {
      final errorData = json.decode(response.body);
      String errorMessage;

      if (response.statusCode == 400 && errorData['error'] == "Bad credentials") {
        errorMessage = 'Sai mật khẩu. Vui lòng thử lại.';
      } else if (response.statusCode == 500 && errorData['message'] == "Username isn't exist") {
        errorMessage = 'Email không tồn tại. Vui lòng kiểm tra lại.';
      } else {
        errorMessage = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToForgotPassword() {
    // Thực hiện điều hướng tới màn hình quên mật khẩu
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()), // Thay ForgotPasswordPage() bằng trang thực tế
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/bg2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Nút quay lại
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Nội dung chính của form đăng nhập
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.85,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safety Travel xin chào!',
                      style: TextStyle(
                        fontSize: 30,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 214, 72, 32),
                              Color.fromARGB(255, 65, 40, 3)
                            ],
                            tileMode: TileMode.clamp,
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Color.fromARGB(255, 214, 72, 32)),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 214, 72, 32)),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _navigateToForgotPassword,
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 214, 72, 32),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        ),
                        child: const Text(
                          'Đăng Nhập',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
