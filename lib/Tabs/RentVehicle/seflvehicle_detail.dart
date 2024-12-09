import 'package:flutter/material.dart';

class SelfDriveDetailsPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const SelfDriveDetailsPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vehicle['name'],
          style: const TextStyle(
            color: Color.fromARGB(255, 214, 72, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 230, 224),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh xe
            Stack(
              children: [
                Image.asset(
                  vehicle['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      '-${vehicle['discount']}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên xe
                  Text(
                    vehicle['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Địa chỉ
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        vehicle['location'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Giá thuê
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '${vehicle['discountedPricePerHour']}₫/giờ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          children: [
                            TextSpan(
                              text: '  ${vehicle['pricePerHour']}₫',
                              style: const TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Tabs Thông tin, Điều khoản, Đánh giá
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TabBar(
                          labelColor: Color.fromARGB(255, 214, 72, 32),
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Color.fromARGB(255, 214, 72, 32),
                          tabs: [
                            Tab(text: 'Thông tin'),
                            Tab(text: 'Điều khoản'),
                            Tab(text: 'Đánh giá'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200, // Chiều cao của nội dung Tab
                          child: TabBarView(
                            children: [
                              // Tab Thông tin
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.person,
                                                color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text(
                                              'Chủ xe: Phan Quốc Hùng',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Xử lý sự kiện "Nhắn tin"
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Tính năng nhắn tin đang được phát triển!',
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 214, 72, 32),
                                          ),
                                          child: const Text(
                                            'Nhắn tin',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Row(
                                      children: [
                                        Icon(Icons.phone,
                                            color: Colors.orange),
                                        SizedBox(width: 8),
                                        Text(
                                          'SĐT: 0346928407',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Đặc điểm',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.motorcycle,
                                                color: Colors.green),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Loại xe: \n${vehicle['engineCapacity']}',
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.event,
                                                color: Color.fromARGB(
                                                    255, 214, 72, 32)),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Đời xe: \n${vehicle['year']}',
                                              style: const TextStyle(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          children: [
                                            Icon(Icons.inventory,
                                                color: Colors.teal),
                                            SizedBox(width: 8),
                                            Text(
                                              'Còn: \n5 chiếc',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Tab Điều khoản
                              const Center(
                                child: Text(
                                  'Các điều khoản thuê xe sẽ được hiển thị tại đây.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              // Tab Đánh giá
                              const Center(
                                child: Text(
                                  'Các đánh giá sẽ được hiển thị tại đây.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Thêm Container phía dưới
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thời gian thuê
                        // Thời gian nhận
// Thời gian nhận
const Row(
  children: [
    Text(
      'Thời gian nhận:',
      style: TextStyle(fontSize: 16),
    ),
    SizedBox(width: 8),
    Icon(Icons.access_time, color: Colors.blue),
    SizedBox(width: 8),
    Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '15:00',
        style: TextStyle(fontSize: 16),
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.calendar_today, color: Colors.blue),
    SizedBox(width: 8),
    Text(
      '01/12/2024',
      style: TextStyle(fontSize: 16),
    ),
  ],
),

// Thời gian trả
const Row(
  children: [
    Text(
      'Thời gian trả:',
      style: TextStyle(fontSize: 16),
    ),
    SizedBox(width: 8),
    Icon(Icons.access_time, color: Colors.blue),
    SizedBox(width: 8),
    Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '18:00',
        style: TextStyle(fontSize: 16),
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.calendar_today, color: Colors.blue),
    SizedBox(width: 8),
    Text(
      '01/12/2024',
      style: TextStyle(fontSize: 16),
    ),
  ],
),
                        const SizedBox(height: 8),
                        // Phí thuê
                        const Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Phí thuê: 240.000đ',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Mã giảm giá
                        const Row(
                          children: [
                            Icon(Icons.discount, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Mã giảm giá: ABC123',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Tiền cọc
                        const Row(
                          children: [
                            Icon(Icons.monetization_on, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Tiền cọc: 1.000.000đ',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tiền cọc sẽ được hoàn trả khi hoàn thành thủ tục trả xe.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        // Nút Thuê xe
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Xử lý sự kiện "Thuê xe"
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã thuê xe thành công!'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 214, 72, 32),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                            ),
                            child: const Text(
                              'Thuê xe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
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
          ],
        ),
      ),
    );
  }
}
