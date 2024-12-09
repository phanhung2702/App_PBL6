import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để format thời gian (nếu cần)

class ConfirmBookingPage extends StatefulWidget {
  final String paymentMethod;

  const ConfirmBookingPage({required this.paymentMethod});

  @override
  ConfirmBookingPageState createState() => ConfirmBookingPageState();
}

class ConfirmBookingPageState extends State<ConfirmBookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? name;
  String? phoneNumber;

  // Các dữ liệu khác cần truyền vào trang này
  final String carType = "Xe oto";
  final String pickupLocation = "17 Hòa Minh 28, Liên Chiểu, Đà Nẵng";
  final String dropoffLocation = "146 Duy Tân, Hải Châu Đà Nẵng";
  final String bookingTime =
      DateFormat("HH:mm dd/MM/yyyy").format(DateTime.now());
  final double bookingFee = 100000;
  final double discount = 0;
  final double totalAmount = 100000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Xác nhận đặt xe",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thông tin đơn hàng",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Tên người đặt",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Số điện thoại",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Color.fromARGB(255, 214, 72, 32)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Thời gian đặt xe:\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: bookingTime,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.directions_car,
                          color: Color.fromARGB(255, 214, 72, 32)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Địa điểm đón:\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: pickupLocation,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Color.fromARGB(255, 214, 72, 32)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Địa điểm đến:\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: dropoffLocation,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Loại xe:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(carType),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Phương thức thanh toán:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Flexible(
                        child: Text(
                          widget.paymentMethod,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Phí đặt xe:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${bookingFee.toStringAsFixed(0)}đ"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Giảm giá:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${discount.toStringAsFixed(0)}%"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tổng thanh toán:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("${totalAmount.toStringAsFixed(0)}đ"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Vui lòng nhập đầy đủ thông tin!')),
                          );
                          return;
                        }
                        // Tiến hành xác nhận và xử lý đơn hàng
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 214, 72, 32),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 48,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "XÁC NHẬN",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
