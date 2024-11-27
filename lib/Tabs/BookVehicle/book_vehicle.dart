import 'package:app_pbl6/Tabs/BookVehicle/book_car_page.dart';
import 'package:app_pbl6/Tabs/BookVehicle/book_motor_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



// Danh sách mã giảm giá với thông tin chi tiết
class DiscountCode {
  final String code;
  final String discountPercentage;
  final String validity;
  final String expirationDate;
  bool isCollected;

  DiscountCode(this.code, this.discountPercentage, this.validity, this.expirationDate, {this.isCollected = false});
}

// Khởi tạo danh sách mã giảm giá
final List<DiscountCode> discountCodes = [
  DiscountCode('GIAMGIA10', '10%', 'Hiệu lực sử dụng: 30 ngày', 'Hạn sử dụng: 31/12/2024'),
  DiscountCode('KHANHVIET20', '20%', 'Hiệu lực sử dụng: 15 ngày', 'Hạn sử dụng: 15/11/2024'),
];

// Khai báo lớp cho các mục câu hỏi thường gặp
class FAQItem {
  final String question;
  final String answer;

  FAQItem(this.question, this.answer);
}

// Danh sách các câu hỏi và câu trả lời
final List<FAQItem> faqItems = [
  FAQItem('Làm thế nào để thuê xe?', 'Bạn có thể chọn loại xe mong muốn, sau đó nhấn nút "Thuê ngay" để hoàn tất thủ tục.'),
  FAQItem('Tôi có cần bằng lái để thuê xe tự lái không?', 'Có, bạn cần có bằng lái hợp lệ để thuê xe tự lái.'),
  FAQItem('Có những loại xe nào?', 'Chúng tôi cung cấp xe tự lái và xe có tài xế, với đa dạng mẫu mã.'),
  FAQItem('Mã giảm giá áp dụng như thế nào?', 'Mã giảm giá có thể áp dụng khi thanh toán, chỉ áp dụng với các mã hợp lệ.'),
];


class BookVehiclePage extends StatefulWidget {
  @override
  BookVehiclePageState createState() => BookVehiclePageState();
}

class BookVehiclePageState extends State<BookVehiclePage> {
  // Hàm để xử lý sự kiện khi lấy mã giảm giá
  void collectDiscount(int index) {
    setState(() {
      discountCodes[index].isCollected = true; // Cập nhật trạng thái đã lấy
    });
  }

  final PageController _pageController = PageController();
  final List<String> bookVehicleImages = [
    'assets/homeimages/8.jpg',
    'assets/homeimages/9.jpg',
    // Thêm các hình ảnh khác vào danh sách này
  ];

  final List<String> serviceImages = [
    'assets/homeimages/6.jpg', // Đường dẫn tới hình ảnh dịch vụ 1
    'assets/homeimages/7.jpg', // Đường dẫn tới hình ảnh dịch vụ 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container chứa carousel hình ảnh
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: bookVehicleImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          bookVehicleImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      );
                    },
                  ),
                  // Văn bản chồng lên hình ảnh
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
                        'Đặt xe thả ga, không lo về giá!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 214, 72, 32),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Hiển thị SmoothPageIndicator
            SmoothPageIndicator(
              controller: _pageController,
              count: bookVehicleImages.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.orange,
                dotColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child: Row(
    children: [
      // Hình ảnh 1
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookCarPage()), // Điều hướng đến trang thuê xe tự lái
            );
          },
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(right: 5),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    serviceImages[0], // Đường dẫn tới hình ảnh dịch vụ 1
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
                  ),
                ),
                // Văn bản chồng lên hình ảnh
                Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Xe oto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 214, 72, 32),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Hình ảnh 2
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookMotorPage()), // Điều hướng đến trang thuê xe có tài xế
            );
          },
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(left: 5),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    serviceImages[1], // Đường dẫn tới hình ảnh dịch vụ 2
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
                  ),
                ),
                // Văn bản chồng lên hình ảnh
                Positioned(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300]?.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Xe máy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 214, 72, 32),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),
            const SizedBox(height: 20), // Khoảng cách giữa phần hình ảnh và mã giảm giá
                  // Phần hiển thị mã giảm giá
                  const Text(
                    'MÃ GIẢM GIÁ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), // Khoảng cách
                  // Hiển thị mã giảm giá
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(discountCodes.length, (index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 193, 83, 55),
                              Color.fromARGB(255, 197, 162, 149),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              discountCodes[index].code,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              discountCodes[index].discountPercentage,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              discountCodes[index].validity,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              discountCodes[index].expirationDate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: discountCodes[index].isCollected
                                  ? null
                                  : () => collectDiscount(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: discountCodes[index].isCollected ? Colors.green : Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              ),
                              child: Text(
                                discountCodes[index].isCollected ? 'Đã lấy' : 'Lấy mã',
                                style: TextStyle(
                                  color: discountCodes[index].isCollected ? Colors.white : const Color.fromARGB(255, 193, 83, 55),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

            const SizedBox(height: 20),
            // Phần hiển thị câu hỏi thường gặp
                  const Text(
                    'CÂU HỎI THƯỜNG GẶP',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10), // Khoảng cách
                  
                    // Phần câu hỏi thường gặp
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: faqItems.length,
  shrinkWrap: true, // Đảm bảo ListView không chiếm hết màn hình
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền của câu hỏi
        borderRadius: BorderRadius.circular(10), // Độ bo góc
        border: Border.all(
          color: const Color.fromARGB(255, 214, 72, 32).withOpacity(0.3), // Màu viền bạn muốn
          width: 1.5, // Độ dày của viền
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5), // Khoảng cách giữa các câu hỏi
      child: ExpansionTile(
        backgroundColor: Colors.white,
        title: Text(
          faqItems[index].question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              faqItems[index].answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  },
),
const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
