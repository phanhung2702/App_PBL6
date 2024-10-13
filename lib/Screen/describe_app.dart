import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Danh sách các hình nền
  final List<String> images = [
    'assets/homeimages/1.jpg',
    'assets/homeimages/2.jpg',
    'assets/homeimages/3.jpg',
  ];


// Widget hiển thị phần mô tả ứng dụng với danh sách hình ảnh
Widget buildDescribeApp(PageController pageController, List<String> images) {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 200,
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300]?.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Chào mừng bạn đến với Safety Travel, nơi bắt đầu mọi hành trình!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 214, 72, 32),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      SmoothPageIndicator(
        controller: pageController,
        count: images.length,
        effect: const WormEffect(
          dotHeight: 8,
          dotWidth: 8,
          activeDotColor: Colors.orange,
          dotColor: Colors.grey,
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}
