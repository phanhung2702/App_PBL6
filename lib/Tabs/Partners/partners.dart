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
              'assets/bg/bg3.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Content on top of the background
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Điều hướng tới trang BusPartnerPage khi nhấn nút "Đối tác nhà xe"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusPartnerPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 214, 72, 32), // Màu nền của nút
                    foregroundColor: Colors.white, // Màu chữ
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding của nút
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Kiểu chữ
                  ),
                  child: const Text("Đối tác nhà xe"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Điều hướng tới trang DriverPartnerPage khi nhấn nút "Đối tác tài xế"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DriverPartnerPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 214, 72, 32), // Màu nền của nút
                    foregroundColor: Colors.white, // Màu chữ
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding của nút
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Kiểu chữ
                  ),
                  child: const Text("Đối tác cho thuê xe"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
