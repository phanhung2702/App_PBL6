import 'package:flutter/material.dart';

class SaleWidget extends StatefulWidget {
  @override
 
  SaleWidgetState createState() => SaleWidgetState();
}

class SaleWidgetState extends State<SaleWidget> {
  bool _isCodeTaken = false; // Biến trạng thái để theo dõi mã đã lấy hay chưa

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khuyến mãi'.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 214, 72, 32),
            ),
          ),
          const SizedBox(height: 10),
          // Thêm mã giảm giá
          Container(
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 193, 83, 55), // Màu đầu
                  Color.fromARGB(255, 197, 162, 149), // Màu cuối
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Hiển thị hình dạng phiếu giảm giá
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giảm giá 50%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mã giảm giá: SAFETRAVEL20',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Nút lấy mã
                ElevatedButton(
                  onPressed: () {
                    // Xử lý lấy mã giảm giá
                    setState(() {
                      _isCodeTaken = true; // Đánh dấu mã đã được lấy
                    });

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Mã giảm giá'),
                        content: const Text('Mã giảm giá của bạn: SAFETRAVEL20'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Đóng'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    _isCodeTaken ? 'Đã lấy' : 'Lấy mã',
                    style: TextStyle(
                      color: _isCodeTaken
                          ? Colors.green
                          : const Color.fromARGB(255, 60, 51, 51),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
