import 'package:flutter/material.dart';

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
          icon: const Icon(Icons.message, color: Color.fromARGB(255, 214, 72, 32),),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 214, 72, 32),),
          onPressed: () {},
        ),
         // Avatar hiển thị tượng trưng khi chưa đăng nhập
        Container(
          margin: const EdgeInsets.only(right: 16), // Khoảng cách bên phải
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey, // Màu nền là xám
            child: Icon(
              Icons.person, // Biểu tượng tượng trưng
              color: Colors.white, // Màu biểu tượng
              size: 20, // Kích thước biểu tượng
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
