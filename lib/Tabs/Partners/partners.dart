import 'package:app_pbl6/Tabs/Partners/bus_partner_page.dart';
import 'package:app_pbl6/Tabs/Partners/driver_partner_page.dart';
import 'package:flutter/material.dart';

class PartnersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bg/bg4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          Padding(
            padding: const EdgeInsets.only(top: 50.0), // Khoảng cách từ trên
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nút Đối tác nhà xe
                Center(
                  child: SizedBox(
                    width: 250, // Chiều rộng cố định
                    child: ElevatedButton(
                      onPressed: () {
                        // Điều hướng tới trang BusPartnerPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BusPartnerPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 214, 72, 32), // Màu nền của nút
                        foregroundColor: Colors.white, // Màu chữ
                        padding: const EdgeInsets.symmetric(vertical: 15), // Padding theo chiều dọc
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Kiểu chữ
                      ),
                      child: const Text("Đối tác nhà xe"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Nút Đối tác tài xế
                Center(
                  child: SizedBox(
                    width: 250, // Chiều rộng cố định
                    child: ElevatedButton(
                      onPressed: () {
                        // Điều hướng tới trang DriverPartnerPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DriverPartnerPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 214, 72, 32), // Màu nền của nút
                        foregroundColor: Colors.white, // Màu chữ
                        padding: const EdgeInsets.symmetric(vertical: 15), // Padding theo chiều dọc
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Kiểu chữ
                      ),
                      child: const Text("Đối tác cho thuê xe"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
