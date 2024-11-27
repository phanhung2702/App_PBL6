import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderInformationPage extends StatefulWidget {
  final DateTime purchaseTime;
  final String tripDate;
  final String departureTime;
  final String arrivalTime;
  final String departureLocation;
  final String arrivalLocation;
  final String vehicleType;
  final int ticketPrice;
  final int discount;
  final int totalAmount;

  const OrderInformationPage({
    super.key,
    required this.purchaseTime,
    required this.tripDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.vehicleType,
    required this.ticketPrice,
    required this.discount,
    required this.totalAmount,
  });

  @override
  OrderInformationPageState createState() => OrderInformationPageState();
}

class OrderInformationPageState extends State<OrderInformationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int _quantity = 1;

  int get updatedTotalAmount {
    int totalPrice = widget.ticketPrice * _quantity;
    int discountAmount = (totalPrice * widget.discount) ~/ 100;
    return totalPrice - discountAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'THÔNG TIN ĐƠN HÀNG',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Người đặt',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.orange[50],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
                filled: true,
                fillColor: Colors.orange[50],
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),

            // Thời gian mua vé với định dạng mới
            _buildInfoRow(
              'Thời gian mua vé',
              DateFormat('HH:mm dd-MM-yyyy').format(widget.purchaseTime),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Hành trình:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  'Ngày đi: ${widget.tripDate}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(widget.departureLocation),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(widget.departureTime),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(widget.arrivalLocation),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(widget.arrivalTime),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1),
            _buildInfoRow('Loại xe đặt:', widget.vehicleType),
            const Divider(height: 32, thickness: 1),
            _buildPaymentDetails(),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
              ),
              onPressed: () {
                _showPaymentDialog(context);
              },
              child: const Text(
                'Thanh toán',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bằng việc xác nhận thanh toán, bạn đã đồng ý với tất cả chính sách chuyến xe yêu cầu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chi tiết thanh toán:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text('Tiền vé xe: ${widget.ticketPrice} VND'),
        Row(
          children: [
            const Text('Số lượng:'),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                setState(() {
                  if (_quantity > 1) _quantity--;
                });
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$_quantity', style: const TextStyle(fontSize: 16)),
            IconButton(
              onPressed: () {
                setState(() {
                  _quantity++;
                });
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        Text('Giảm giá: -${widget.discount} %'),
        const SizedBox(height: 8),
        Divider(thickness: 1, color: Colors.grey[300]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tổng tiền cần thanh toán:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('$updatedTotalAmount VND',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red)),
          ],
        ),
      ],
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thanh toán thành công'),
        content: const Text('Đơn hàng của bạn đã được thanh toán thành công!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
