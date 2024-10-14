import 'package:flutter/material.dart';

class CustomerReviewsWidget extends StatelessWidget {
  const CustomerReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft, // Căn trái
            child: Text(
              'Đánh giá của khách hàng'.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 214, 72, 31),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Kiểm tra xem có đánh giá không
          const Center(
            // Căn giữa thông báo "Chưa có đánh giá"
            child: Text(
              'Chưa có đánh giá', // Hiển thị thông báo khi chưa có đánh giá
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
