import 'package:app_pbl6/Profile/account_management.dart';
import 'package:app_pbl6/Profile/order_management_page.dart';
import 'package:app_pbl6/Profile/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:app_pbl6/welcome_page.dart';


class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safety Travel',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'DancingScript',
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
          const SizedBox(height: 5),
          Text(
            'Mỗi chuyến xe là mỗi...',
            style: TextStyle(
              fontSize: 14,
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
          const SizedBox(height: 10),
        ],
      ),
      centerTitle: false,
      titleSpacing: 16.0,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.message,
            color: Color.fromARGB(255, 214, 72, 32),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Color.fromARGB(255, 214, 72, 32),
          ),
          onPressed: () {},
        ),
        
        // Thay thế Container bằng PopupMenuButton
        PopupMenuButton<String>(
          icon: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey, // Màu nền là xám
            child: Icon(
              Icons.person, // Biểu tượng tượng trưng
              color: Colors.white, // Màu biểu tượng
              size: 20, // Kích thước biểu tượng
            ),
          ),
          onSelected: (value) {
            switch (value) {
              case 'settings':
                // Điều hướng đến trang cài đặt chế độ
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                break;
              case 'account_management':
                // Điều hướng đến trang quản lý tài khoản
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountManagementPage()),
                );
                break;
              case 'order_management':
                // Điều hướng đến trang quản lý đơn hàng
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderManagementPage()),
                );
                break;
              case 'logout':
                _logout(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Cài đặt chế độ'),
              ),
              const PopupMenuItem<String>(
                value: 'account_management',
                child: Text('Quản lý tài khoản'),
              ),
              const PopupMenuItem<String>(
                value: 'order_management',
                child: Text('Quản lý đơn hàng'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Đăng xuất'),
              ),
            ];
          },
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    // Quay lại màn hình đăng nhập
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()), // Thay LoginPage bằng trang đăng nhập của bạn
      (Route<dynamic> route) => false, // Loại bỏ tất cả các route khác
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
