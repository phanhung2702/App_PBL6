import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Danh sách các tuyến đường phổ biến
  final List<Map<String, String>> popularRoutes = [
    {
      'image': 'assets/tuyen_duong_pho_bien/xekhach1.jpg',
      'from': 'Sài Gòn',
      'to': 'Nha Trang',
      'price': 'Từ 200.000 VNĐ',
    },
    {
      'image': 'assets/tuyen_duong_pho_bien/xekhach2.jpg',
      'from': 'Đà Nẵng',
      'to': 'Nha Trang',
      'price': 'Từ 500.000 VNĐ',
    },
    {
      'image': 'assets/tuyen_duong_pho_bien/xekhach3.jpg',
      'from': 'Đà Nẵng',
      'to': 'Đà Lạt',
      'price': 'Từ 400.000 VNĐ',
    },
    {
      'image': 'assets/tuyen_duong_pho_bien/xekhach4.jpg',
      'from': 'Đà Nẵng',
      'to': 'Hà Nội',
      'price': 'Từ 500.000 VNĐ',
    },
  ];

class PopularRoutesWidget extends StatelessWidget {
  final List<Map<String, String>> popularRoutes;
  final PageController pageControllerRoutes;

  const PopularRoutesWidget({
    super.key,
    required this.popularRoutes,
    required this.pageControllerRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Các tuyến đường phổ biến'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 72, 32),
            ),
          ),
          const SizedBox(height: 10),
          
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: pageControllerRoutes,
              itemCount: (popularRoutes.length / 2).ceil(),
              itemBuilder: (context, pageIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (index) {
                      final routeIndex = pageIndex * 2 + index;
                      if (routeIndex < popularRoutes.length) {
                        final route = popularRoutes[routeIndex];
                        return Container(
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
                                  route['image']!,
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${route['from']} - ${route['to']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                route['price']!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox(width: 100);
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
            controller: pageControllerRoutes,
            count: (popularRoutes.length / 2).ceil(),
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
