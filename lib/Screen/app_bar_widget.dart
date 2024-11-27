import 'dart:io';
import 'package:app_pbl6/Profile/account_management.dart';
import 'package:app_pbl6/Profile/order_management_page.dart';
import 'package:app_pbl6/Profile/setting_page.dart';
import 'package:app_pbl6/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20); // Tăng chiều cao
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late Future<String> _userName;  // Biến lưu tên người dùng
  late Future<String?> _userAvatar;


  @override
  void initState() {
    super.initState();
    _userName = _getUserName();  // Lấy tên người dùng khi widget được khởi tạo
    _userAvatar = _getUserAvatar(); // Tải avatar
  }

// Hàm lấy ảnh đại diện từ SharedPreferences
  Future<String?> _getUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('avatar');  // Lấy đường dẫn ảnh đại diện
  }

  // Hàm lấy tên người dùng từ SharedPreferences
  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'Tên Người Dùng';  // Nếu không có tên thì trả về giá trị mặc định
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Xóa token khi đăng xuất
    await prefs.remove('avatar');
    
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  WelcomePage()),
      (Route<dynamic> route) => false,
    );
  }

  void _showProfileMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar and user name
                FutureBuilder<String>(
                  future: _userName,  // Đợi kết quả từ _getUserName()
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();  // Hiển thị khi dữ liệu đang tải
                    }
                    if (snapshot.hasError) {
                      return const Text('Lỗi khi tải tên người dùng');
                    }

                    final userName = snapshot.data ?? 'Tên Người Dùng'; // Hiển thị tên người dùng
                    return Row(
                      children: [
                        FutureBuilder<String?>(
                          future: _userAvatar, // Tải ảnh đại diện
                          builder: (context, avatarSnapshot) {
                            if (avatarSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            String? avatarPath = avatarSnapshot.data;
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage: avatarPath != null ? FileImage(File(avatarPath)) : null,
                              backgroundColor: Colors.grey,
                              child: avatarPath == null
                                  ? const Icon(Icons.person, color: Colors.white, size: 30)
                                  : null,
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings, color: Color.fromARGB(255, 214, 72, 32)),
                  title: const Text('Cài đặt chế độ'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  SettingsPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle, color: Color.fromARGB(255, 214, 72, 32)),
                  title: const Text('Quản lý tài khoản'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AccountManagementPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart, color: Color.fromARGB(255, 214, 72, 32)),
                  title: const Text('Quản lý đơn hàng'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  OrderManagementPage()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Logout button
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 214, 72, 32)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _logout();
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.logout, color: Color.fromARGB(255, 214, 72, 32)),
                        SizedBox(width: 8),
                        Text(
                          'Đăng xuất',
                          style: TextStyle(
                            color: Color.fromARGB(255, 214, 72, 32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                  colors: <Color>[Color.fromARGB(255, 214, 72, 32), Color.fromARGB(255, 65, 40, 3)],
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
                  colors: <Color>[Color.fromARGB(255, 214, 72, 32), Color.fromARGB(255, 65, 40, 3)],
                  tileMode: TileMode.clamp,
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.message, color: Color.fromARGB(255, 214, 72, 32)),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 214, 72, 32)),
          onPressed: () {},
        ),
        GestureDetector(
          onTap: () => _showProfileMenu(context),
          child: FutureBuilder<String?>(
            future: _userAvatar, // Lấy ảnh đại diện
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: CircularProgressIndicator(),
                );
              }

              String? avatarPath = snapshot.data;
              return CircleAvatar(
                radius: 20,
                backgroundImage: avatarPath != null ? FileImage(File(avatarPath)) : null,
                backgroundColor: Colors.grey,
                child: avatarPath == null ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

