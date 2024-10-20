import 'package:flutter/material.dart';
import 'package:app_pbl6/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    // Gọi API để đăng nhập
    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter_api/login.php'), // Thay thế địa chỉ server của bạn
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
      headers: {
        'Content-Type': 'application/json', // Gửi dữ liệu dưới dạng JSON
      },
    );

    if (!mounted) return; // Kiểm tra xem widget còn tồn tại

    if (response.statusCode == 200) {
      // Xử lý dữ liệu trả về nếu đăng nhập thành công
      final data = json.decode(response.body);
      if (data['success']) {
        // Điều hướng đến trang chính
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
           (Route<dynamic> route) => false,
        );
      } else {
        // Hiển thị thông báo lỗi nếu đăng nhập không thành công
        _showErrorDialog(data['message']);
      }
    } else {
      // Hiển thị thông báo lỗi nếu không thể kết nối đến API
      _showErrorDialog('Không thể kết nối đến máy chủ');
    }
  }

  // Hàm để hiển thị thông báo lỗi
  void _showErrorDialog(String message) {
    if (!mounted) return; // Kiểm tra xem widget còn tồn tại

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
                image: AssetImage("assets/bg/bg2.jpg"), // Đường dẫn tới ảnh nền
                fit: BoxFit.cover,
              ),
            ),
          ),
          //  // Nút quay lại
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Quay lại trang trước đó
              },
            ),
          ),
          //Nội dung chính của form đăng nhập
          Align(
            alignment: Alignment.bottomCenter, // Đặt form ở gần cuối màn hình
            child: FractionallySizedBox(
              widthFactor: 1,  // 
              heightFactor: 0.85,  // Chiếm 75% chiều cao màn hình
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Căn các phần tử về phía trên
                  children: [
                    // Tên App
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
                    const SizedBox(height: 20), // Khoảng cách nhỏ giữa tên app và form

                    // Ô nhập email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email, color: Colors.orange),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ô nhập mật khẩu
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock, color: Colors.orange),
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

                    // Nút đăng nhập
                    Center(
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
