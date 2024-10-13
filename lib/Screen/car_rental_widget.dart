import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Danh sách cho mục thuê xe tự lái hoặc có tài xế
  final List<Map<String, String>> carRentalOptions = [
    {
      'image': 'assets/thue_xe/oto1.jpg',
      'name': 'Sài Gòn',
      'price': 'Từ 400.000 VNĐ',
    },
    {
      'image': 'assets/thue_xe/sh1.jpg',
      'name': 'Đà Nẵng',
      'price': 'Từ 200.000 VNĐ',
    },
    {
      'image': 'assets/thue_xe/vision.jpg',
      'name': 'Hà Nội',
      'price': 'Từ 200.000 VNĐ',
    },
    {
      'image': 'assets/thue_xe/ex155.jpg',
      'name': 'Huế',
      'price': 'Từ 200.000 VNĐ',
    },
  ];

class CarRentalWidget extends StatelessWidget {
  final List<Map<String, String>> carRentalOptions;
  final PageController pageControllerCarRental;
  final VoidCallback onTap;

  const CarRentalWidget({
    super.key,
    required this.carRentalOptions,
    required this.onTap,
    required this.pageControllerCarRental,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "THUÊ XE TỰ LÁI HOẶC CÓ TÀI XẾ"
          Text(
            'THUÊ XE TỰ LÁI HOẶC CÓ TÀI XẾ'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 72, 32),
            ),
          ),
          const SizedBox(height: 10),
          // Hiển thị thông tin các loại xe thuê
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: pageControllerCarRental,
              itemCount: (carRentalOptions.length / 2).ceil(),
              itemBuilder: (context, pageIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (index) {
                      final carIndex = pageIndex * 2 + index;
                      if (carIndex < carRentalOptions.length) {
                        final car = carRentalOptions[carIndex];
                        return GestureDetector(
                          onTap: () {
                            onTap();
                          },
                          child: Container(
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    car['image']!,
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  car['name']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  car['price']!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(
                            width: 100); // Trống nếu không có xe để hiển thị
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: SmoothPageIndicator(
              controller:
                  pageControllerCarRental, // Sử dụng controller của PageView
              count: (carRentalOptions.length / 2)
                  .ceil(), // Số trang dựa trên số xe
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.orange,
                dotColor: Colors.grey,
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
