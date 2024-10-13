import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


// Danh sách đặt xe
  final List<Map<String, String>> bookingOptions = [
    {
      'image': 'assets/Dat_xe/Datxe1.jpg',
      'name': 'Đặt xe ở Đà Nẵng',
      'type': 'Xe máy',
      'price': 'Từ 200.000 VNĐ',
    },
    {
      'image': 'assets/Dat_xe/Datxe2.jpg',
      'name': 'Đặt xe ở Đà Nẵng',
      'type': 'Ô tô',
      'price': 'Từ 300.000 VNĐ',
    },
    {
      'image': 'assets/Dat_xe/Datxe3.jpg',
      'name': 'Đặt xe ở Quảng Nam',
      'type': 'Xe máy',
      'price': 'Từ 200.000 VNĐ',
    },
    {
      'image': 'assets/Dat_xe/Datxe4.jpg',
      'name': 'Đặt xe ở Quảng Nam',
      'type': 'Ô tô',
      'price': 'Từ 300.000 VNĐ',
    },
  ];
class BookingWidget extends StatelessWidget {
  final PageController pageControllerBooking;
  final List<Map<String, String>> bookingOptions;
  final Function onBookingTap;

  const BookingWidget({
    super.key,
    required this.pageControllerBooking,
    required this.bookingOptions,
    required this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đặt xe'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 72, 32),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: pageControllerBooking,
              itemCount: (bookingOptions.length / 2).ceil(),
              itemBuilder: (context, pageIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (index) {
                      final bookingIndex = pageIndex * 2 + index;
                      if (bookingIndex < bookingOptions.length) {
                        final booking = bookingOptions[bookingIndex];
                        return GestureDetector(
                          onTap: () => onBookingTap(),
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
                                    booking['image']!,
                                    width: double.infinity,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  booking['name']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  booking['type']!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  booking['price']!,
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
            controller: pageControllerBooking,
            count: (bookingOptions.length / 2).ceil(),
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
