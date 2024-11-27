import 'package:flutter/material.dart';

class BusPartnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đối tác nhà xe',
          style: TextStyle(
      color: Color.fromARGB(255, 214, 72, 32), // Chỉnh màu chữ
      fontWeight: FontWeight.bold, // Đậm chữ
    ),
  ),
  backgroundColor: const Color.fromARGB(255, 255, 230, 224),
  centerTitle: true, // Căn chữ ra giữa
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg/bg3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Trở thành đối tác nhà xe
                  const Text(
                    "Trở thành đối tác nhà xe cùng Safety Travel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 214, 72, 32),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Hướng dẫn điền thông tin
                  const Text(
                    "Để bắt đầu, hãy điền các thông tin theo hướng dẫn phía dưới",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 214, 72, 32),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Các TextField
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Tên nhà xe",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Website/Fanpage của bạn",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Người đại diện",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Số điện thoại",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Địa chỉ nhà xe",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tôi đồng ý
                  const Text(
                    "Tôi đồng ý rằng Safety Travel có thể thu thập, sử dụng, "
                    "tiết lộ thông tin do tôi cung cấp, thay mặt cho công ty đăng ký, theo "
                    "Thông báo bảo mật của Safety Travel mà tôi đã đọc và hiểu.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nút đăng ký
                  ElevatedButton(
                    onPressed: () {
                      // Logic xử lý đăng ký
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 214, 72, 32), // Màu nền của nút
                      foregroundColor: Colors.white, // Màu chữ
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Đăng ký"),
                  ),
                  const SizedBox(height: 20),

                  // Điều khoản Safety Travel
                  const Text(
                    "Bằng cách gửi biểu mẫu này, tôi đồng ý với các điều khoản của Safety Travel.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
