import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_pbl6/services/otp_page.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final Logger _logger = Logger();
  // URL API đăng ký
  final String _registerUrl = "http://10.0.2.2:8080/api/v1/auth/register";

  // Kiểm tra mật khẩu và xác nhận mật khẩu

  // Xử lý phản hồi API và hiển thị thông báo
  void _handleApiResponse(Map<String, dynamic> response) {
  // In ra toàn bộ lỗi để kiểm tra
  _logger.e('API Response: $response');  

  if (response['statusCode'] == 400) {
    // Giải mã lỗi nếu cần
    String errorMessage = _decodeString(response['error']);

    // Hiển thị thông báo lỗi từ API
    _showErrorDialog(errorMessage);
  } else if (response['statusCode'] == 201) {
    // Thành công: Đăng ký thành công, yêu cầu kiểm tra email
    _showSuccessDialog(response['data']?['info'] ?? 'Đăng ký thành công. Vui lòng kiểm tra email!');
  } else {
    // Lỗi không xác định
    _showErrorDialog('Đã xảy ra lỗi không xác định. Vui lòng thử lại.');
  }
}

// Hàm giải mã chuỗi nếu có sự cố về encoding
String _decodeString(String? input) {
  if (input == null) return '';
  try {
    return utf8.decode(input.runes.toList());
  } catch (e) {
    return input;  // Trả về chuỗi gốc nếu không thể giải mã
  }
}

  // Hiển thị thông báo lỗi
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Hiển thị thông báo thành công
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Sau khi đăng ký thành công, điều hướng sang trang OTP
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OtpPage(email: _emailController.text)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Gửi yêu cầu đăng ký đến API
  Future<void> _register() async {
    // Chuẩn bị dữ liệu để gửi đến API
    final Map<String, String> requestBody = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "confirmPassword": _confirmPasswordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      final responseData = json.decode(response.body);

      // Xử lý phản hồi từ API
      _handleApiResponse({
        "statusCode": response.statusCode,
        "data": responseData,
        "error": responseData['error'],
      });
       if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _emailController.text);
    }
    } catch (e) {
      _showErrorDialog('Đã xảy ra lỗi. Vui lòng thử lại');
    }
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
          // Nội dung chính của form đăng ký
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.85,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Đăng Ký Tài Khoản',
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
                      // Các trường nhập liệu
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email,
                              color: Color.fromARGB(255, 214, 72, 32)),
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
                          prefixIcon: const Icon(Icons.lock,
                              color: Color.fromARGB(255, 214, 72, 32)),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Xác nhận mật khẩu',
                          prefixIcon: const Icon(Icons.lock,
                              color: Color.fromARGB(255, 214, 72, 32)),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 214, 72, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                          ),
                          child: const Text(
                            'Đăng Ký',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
