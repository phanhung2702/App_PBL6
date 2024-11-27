import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_pbl6/Login/login_page.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ResetPasswordPage({required this.token});

  Future<void> _resetPassword(BuildContext context) async {
    // Kiểm tra xem hai mật khẩu có khớp nhau không
    if (_newPasswordController.text != _confirmPasswordController.text) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp.')),
      );
      return;
    }

    // Thực hiện POST request để đổi mật khẩu
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/v1/auth/change-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'token': token,
        'password': _newPasswordController.text,
        'confirmPassword': _confirmPasswordController.text,
      }),
    );

    // Kiểm tra phản hồi từ API
    if (!context.mounted) return; // Kiểm tra nếu widget vẫn còn mounted

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đặt lại mật khẩu thành công.')),
      );
      // Điều hướng về trang Đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // LoginPage() là trang đăng nhập của bạn
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lại mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu mới'),
            ),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              child: const Text('Đổi mật khẩu'),
            ),
          ],
        ),
      ),
    );
  }
}
