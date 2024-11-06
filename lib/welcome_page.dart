import 'package:flutter/material.dart';
import 'package:app_pbl6/Login/login_page.dart';
import 'package:app_pbl6/Register/register_page.dart';

class WelcomePage extends StatelessWidget {
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
         
          Align(
            alignment: Alignment.bottomCenter, // Đặt form ở gần cuối màn hình
            child: FractionallySizedBox(
              widthFactor: 1,  
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center, // Căn các phần tử về phía trên
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
                    const SizedBox(height: 20), // Khoảng cách nhỏ 
                    // Form lựa chọn Đăng Nhập hoặc Đăng Ký
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều ngang
                      children: [
                        // Nút Đăng Nhập
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
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
                        const SizedBox(width: 20), // Khoảng cách giữa hai nút
                        // Nút Đăng Ký
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          ),
                          child: const Text(
                            'Đăng Ký',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
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