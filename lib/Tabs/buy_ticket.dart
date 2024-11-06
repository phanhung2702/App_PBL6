import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Danh sách các hình ảnh cho tab Mua vé
final List<String> buyTicketImages = [
  'assets/homeimages/4.jpg',
  'assets/homeimages/5.jpg',
];

class BuyTicketPage extends StatefulWidget {
  @override
  BuyTicketPageState createState() => BuyTicketPageState();
}

class BuyTicketPageState extends State<BuyTicketPage> {
  final PageController _pageController = PageController();
  String selectedBus = 'Chọn nhà xe';
  String selectedStartPlace = 'Nơi xuất phát';
  String selectedDestination = 'Nơi đến';
  DateTime? selectedDate;

  // Hàm chọn ngày đi
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container chứa hình ảnh cho trang Mua vé
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 200, // Chiều cao của container chứa hình ảnh
              child: Stack(
                children: [
                  // Sử dụng PageView.builder để hiển thị danh sách hình ảnh
                  PageView.builder(
                    controller: _pageController,
                    itemCount: buyTicketImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Bo tròn các góc
                        child: Image.asset(
                          buyTicketImages[index],
                          fit: BoxFit.cover, // Hiển thị toàn bộ hình ảnh trong khung
                          width: double.infinity,
                          height: 200,
                        ),
                      );
                    },
                  ),
                  // Văn bản được chồng lên hình ảnh
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300]?.withOpacity(0.7), // Màu nền mờ
                        borderRadius: BorderRadius.circular(10), // Bo tròn góc cho container chứa text
                      ),
                      child: const Text(
                        'Đặt vé xe khách online dễ dàng, an toàn và tiết kiệm',
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
              count: buyTicketImages.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.orange,
                dotColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Khung tìm kiếm
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label và Dropdown để chọn nhà xe
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text('Chọn nhà xe:'),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: selectedBus,
                          items: ['Chọn nhà xe', 'Nhà xe A', 'Nhà xe B', 'Nhà xe C']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedBus = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Label và Dropdown để chọn nơi xuất phát
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text('Nơi xuất phát:'),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: selectedStartPlace,
                          items: ['Nơi xuất phát', 'Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedStartPlace = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Label và Dropdown để chọn nơi đến
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text('Nơi đến:'),
                      ),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: selectedDestination,
                          items: ['Nơi đến', 'Nha Trang', 'Huế', 'Cần Thơ']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedDestination = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Label cho chọn ngày đi
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text('Ngày đi:'),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: selectedDate != null
                                    ? '${selectedDate!.toLocal()}'.split(' ')[0]
                                    : 'Chọn ngày',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),  
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Nút tìm kiếm nằm ở dưới cùng của khung
                  SizedBox(
                    width: double.infinity, // Chiều rộng đầy đủ
                    child: ElevatedButton(
                      onPressed: () {
                        // Thêm logic tìm kiếm ở đây
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 214, 72, 32), // Màu nền của nút
                        padding: const EdgeInsets.symmetric(vertical: 15), // Độ cao của nút
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Bo tròn các góc
                        ),
                      ),
                      child: const Text(
                        'Tìm kiếm', // Văn bản hiển thị trên nút
                        style: TextStyle(
                          fontSize: 16, // Kích thước chữ
                          color: Colors.white, // Màu chữ
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
