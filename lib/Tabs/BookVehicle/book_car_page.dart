import 'package:flutter/material.dart';

class BookCarPage extends StatefulWidget {
  @override
  BookCarPageState createState() => BookCarPageState();
}

class BookCarPageState extends State<BookCarPage> {
  // Biến lưu trạng thái lựa chọn phương thức thanh toán
  String? _paymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        title: const Text('Tìm và chọn xe đặt'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView( // Sử dụng SingleChildScrollView để tránh lỗi overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vị trí đón và điểm đến
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vị trí đón bạn'),
                  Text('Vị trí mặc định là vị trí định vị của người đặt'),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nơi bạn muốn đến'),
                  Text('Trường DH Bách Khoa, DHĐN'),
                ],
              ),
              const SizedBox(height: 20),

              // Danh sách xe
              const Text(
                'DANH SÁCH XE DÀNH CHO BẠN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(5, (index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: const Icon(Icons.directions_car, color: Colors.orange),
                      title: const Text('Xe oto...4 chỗ, 3 chỗ'),
                      subtitle: const Text('4 xe - 100.000đ'),
                      trailing: const Icon(Icons.lock, color: Colors.orange),
                      onTap: () {
                        // Logic khi người dùng chọn xe
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Phương thức thanh toán
              const Text(
                'PHƯƠNG THỨC THANH TOÁN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Thanh toán bằng tiền mặt'),
                leading: Radio<String>(
                  value: 'cash',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Thanh toán qua tài khoản ngân hàng liên kết'),
                leading: Radio<String>(
                  value: 'bank',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Mã giảm giá
              const Text(
                'MÃ GIẢM GIÁ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text('50% - Xe oto...4 chỗ'),
                  subtitle: Text('Có hiệu lực từ 01/11/2024 đến 30/11/2024'),
                  trailing: Icon(Icons.info),
                ),
              ),
              const Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text('50% - Xe oto...4 chỗ'),
                  subtitle: Text('Có hiệu lực từ 01/11/2024 đến 30/11/2024'),
                  trailing: Icon(Icons.info),
                ),
              ),
              const SizedBox(height: 20),

              // Nút đặt xe
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Logic khi người dùng nhấn đặt xe
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Đặt xe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
