import 'package:flutter/material.dart';

class HighlightNumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "CON SỐ NỔI BẬT"
          const Text(
            'CON SỐ NỔI BẬT',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 72, 32),
            ),
          ),
          const SizedBox(height: 10),
          // Sử dụng Row để đặt 2 hình tròn bên cạnh nhau
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Hình tròn 1
              buildCircle('100+', 'Nhà xe chất lượng cao', Colors.green),
              // Hình tròn 2
              buildCircle('100+', 'Nhà xe chất lượng cao', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm tạo hình tròn
  Widget buildCircle(String number, String description, Color color) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          // Nửa trên không có màu nền
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: color, // Thay đổi màu chữ nếu cần
                ),
              ),
            ),
          ),
          // Nửa dưới có màu nền
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              color: color,
              alignment: Alignment.center,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
