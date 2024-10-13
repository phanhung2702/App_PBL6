import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReasonWidget extends StatefulWidget {
  const ReasonWidget({super.key});

  @override
  ReasonWidgetState createState() => ReasonWidgetState();
}

class ReasonWidgetState extends State<ReasonWidget> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> reasons = [
    {
      'icon':
          Icons.confirmation_number, // Thay thế ticket bằng confirmation_number
      'text': 'Đặt vé dễ dàng',
    },
    {
      'icon': Icons.lock,
      'text': 'Bảo mật thông tin',
    },
    {
      'icon': Icons.security,
      'text': 'Di chuyển an toàn',
    },
    {
      'icon': Icons.favorite,
      'text': 'Ân cần chu đáo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dòng "Tại sao nên lựa chọn Safety Travel"
          Text(
            'Tại sao nên lựa chọn Safety Travel'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 72, 32),
            ),
          ),
          const SizedBox(height: 10), // Khoảng cách giữa tiêu đề và nội dung

          // PageView chứa icon và text
          SizedBox(
            height: 150, // Chiều cao cho phần icon và text
            child: PageView.builder(
              controller: _pageController,
              itemCount: (reasons.length / 2).ceil(),
              itemBuilder: (context, pageIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (index) {
                      final reasonIndex = pageIndex * 2 + index;
                      if (reasonIndex < reasons.length) {
                        final reason = reasons[reasonIndex];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              reason['icon'],
                              size: 50,
                              color: const Color.fromARGB(255, 215, 96, 31),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              reason['text'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox(
                            width: 100); // Khoảng trống cho các mục thừa
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(
              height: 20), // Khoảng cách giữa PageView và SmoothPageIndicator

          // SmoothPageIndicator nằm giữa
          Center(
            child: SmoothPageIndicator(
              controller: _pageController,
              count: (reasons.length / 2).ceil(),
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
