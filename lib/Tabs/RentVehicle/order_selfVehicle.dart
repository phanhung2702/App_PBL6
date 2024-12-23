import 'package:app_pbl6/Tabs/RentVehicle/payment_webview.dart';
import 'package:app_pbl6/utils/sharedpre.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderSelfVehiclePage extends StatefulWidget {
  final int quantity;
  final double carDeposit;
  final double reservationFees;
  final String? startRentalTime;
  final String? endRentalTime;
  final String pickUpLocation;
  final double rentalFee;
  final int vehicleRentalServiceId;

  const OrderSelfVehiclePage({
    super.key,
    required this.quantity,
    required this.carDeposit,
    required this.reservationFees,
    required this.vehicleRentalServiceId,
    required this.startRentalTime,
    required this.endRentalTime,
    required this.pickUpLocation,
    required this.rentalFee,
  });

  @override
  OrderSelfVehiclePageState createState() => OrderSelfVehiclePageState();
}

class OrderSelfVehiclePageState extends State<OrderSelfVehiclePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String formatCurrency(double amount) {
    final numberFormat =
        NumberFormat('#,###', 'vi_VN'); // Định dạng theo chuẩn Việt Nam
    return numberFormat.format(amount);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to create the order
  Future<void> createRentalOrder() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    final int? accountId = prefs.getInt('userId');
    final String? token = prefs.getString('access_token');

    if (accountId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không tìm thấy thông tin tài khoản!')),
        );
        return;
      }
    }

    if (name.isEmpty || phone.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Vui lòng nhập đầy đủ họ tên và số điện thoại')),
        );
        return;
      }
    }

    double totalPrice = (widget.rentalFee * widget.quantity) +
        widget.carDeposit +
        widget.reservationFees;

    Map<String, dynamic> orderData = {
      "start_rental_time": widget.startRentalTime,
      "end_rental_time": widget.endRentalTime,
      "pickup_location": widget.pickUpLocation,
      "total": totalPrice,
      "status": "confirmed",
      "voucher_value": 0,
      "voucher_percentage": 0,
      "amount": widget.quantity,
      "car_deposit": widget.carDeposit,
      "reservation_fee": widget.reservationFees,
      "price": widget.rentalFee,
      "vehicle_rental_service_id": widget.vehicleRentalServiceId,
      "customerName": name,
      "customerPhoneNumber": phone,
      "account_id": accountId,
    };
    logger.i("Dữ liệu gửi lên API Order: $orderData");

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/v1/vehicle-rental-order/ordering'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        final String? keyOrder = responseData['data']?['keyOrder'];
        if (keyOrder == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Không tìm thấy keyOrder trong phản hồi!')),
            );
            return;
          }
        }

        final paymentResponse = await http.get(
          Uri.parse(
              'http://10.0.2.2:8080/api/v1/orders/create-payment?key=$keyOrder'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (paymentResponse.statusCode == 201) {
          final paymentData = jsonDecode(paymentResponse.body);
          logger.i("Phản hồi từ API thanh toán: $paymentData");
          final String? paymentUrl = paymentData['data']['paymentUrl'];

          if (paymentUrl != null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đang chuyển tới trang thanh toán...')),
              );

              // Mở thanh toán trong WebView
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PaymentWebViewPage(paymentUrl: paymentUrl),
                ),
              );
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Không tìm thấy đường dẫn thanh toán!')),
                );
              }
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Lỗi khi tạo thanh toán: ${paymentResponse.body}')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi tạo đơn hàng: ${response.body}')),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi kết nối: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = (widget.rentalFee * widget.quantity) +
        widget.carDeposit +
        widget.reservationFees;
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin đơn hàng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField for Name
              Text(
                'Họ và tên:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nhập họ và tên',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // TextField for Phone Number
              Text(
                'Số điện thoại:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              // Hiển thị thời gian thuê
              Text(
                'Thời gian thuê:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Từ: ${widget.startRentalTime}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Đến: ${widget.endRentalTime}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              Text(
                'Địa điểm nhận xe:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    widget.pickUpLocation,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Số lượng thuê
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Số lượng thuê:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.quantity}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Phí thuê 1 chiếc
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Phí thuê 1 chiếc:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${formatCurrency(widget.rentalFee)}đ',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Tiền cọc xe
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tiền cọc xe:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${formatCurrency(widget.carDeposit)}đ',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Phí giữ chỗ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Phí giữ chỗ:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${formatCurrency(widget.reservationFees)}đ',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 16),

              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng tiền:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${formatCurrency(totalPrice)}đ',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Button to submit the form and create rental order
              Center(
                child: ElevatedButton(
                  onPressed: createRentalOrder,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: Text("Thanh toán"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
