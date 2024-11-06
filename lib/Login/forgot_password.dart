import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:app_pbl6/Login/reset_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _forgotPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email của bạn.')),
      );
      return;
    }

    // Thực hiện gọi API forgotpassword
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/forgot-password?email=${_emailController.text}'),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã gửi yêu cầu quên mật khẩu. Kiểm tra email để lấy mã.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại sau.')),
      );
    }
  }

  Future<void> _checkToken(String token) async {
    // Gọi API để kiểm tra token
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/verify-token?token=$token'),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      // Nếu token hợp lệ, chuyển người dùng đến trang đặt lại mật khẩu
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(token: token),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token không hợp lệ hoặc đã hết hạn.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String token = ""; // Giả sử bạn sẽ lấy token từ người dùng, ví dụ từ input

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quên mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: _forgotPassword,
              child: const Text('Gửi yêu cầu quên mật khẩu'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => token = value,
              decoration: const InputDecoration(labelText: 'Nhập mã token'),
            ),
            ElevatedButton(
              onPressed: () => _checkToken(token),
              child: const Text('Xác thực mã token'),
            ),
          ],
        ),
      ),
    );
  }
}
