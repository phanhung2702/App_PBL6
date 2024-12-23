import 'dart:convert';
import 'package:app_pbl6/Tabs/BuyTicket/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class OrderInformationPage extends StatefulWidget {
  final int busTripScheduleId;
  final String departureDate;
  final String arrivalProvince;

  const OrderInformationPage({
    super.key,
    required this.busTripScheduleId,
    required this.departureDate,
    required this.arrivalProvince,
  });

  @override
  OrderInformationPageState createState() => OrderInformationPageState();
}

class OrderInformationPageState extends State<OrderInformationPage> {
  Map<String, dynamic>? tripDetails;
  bool isLoading = true;
  String? errorMessage;
  Logger logger = Logger();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int _quantity = 1;
  String get formattedTotalAmount {
    final formatter = NumberFormat("#,##0", "vi_VN"); // Định dạng cho Việt Nam
    return formatter.format(updatedTotalAmount); // Định dạng tổng tiền
  }

  int get updatedTotalAmount {
    if (tripDetails == null) return 0;

    // Lấy giá vé và loại bỏ các ký tự không phải số
    final int ticketPrice = int.tryParse(tripDetails!['priceTicket']
            .replaceAll('.', '')
            .replaceAll(' VND', '')) ??
        0;

    // Tính phần trăm giảm giá
    final int discountPercentage =
        (tripDetails!['discountPercentage'] ?? 0).toDouble().toInt();

    // Tổng tiền trước giảm giá
    final int totalPrice = ticketPrice * _quantity;

    // Tiền giảm giá
    final int discountAmount = (totalPrice * discountPercentage) ~/ 100;

    // Tổng tiền sau giảm giá
    return totalPrice - discountAmount;
  }

  @override
  void initState() {
    super.initState();
    _fetchTripDetails();
  }

  Future<void> _fetchTripDetails() async {
    final url =
        'http://10.0.2.2:8080/api/v1/user/busTripSchedules/detail?busTripScheduleId=${widget.busTripScheduleId}&departureDate=${widget.departureDate}&arrivalProvince=${Uri.encodeComponent(widget.arrivalProvince)}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['statusCode'] == 200) {
          final data = json.decode(utf8.decode(response.bodyBytes));
          setState(() {
            tripDetails = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Lỗi không xác định';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage =
              'Lỗi kết nối với máy chủ (Status: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Đã xảy ra lỗi: $e';
        isLoading = false;
      });
    }
  }

  void _submitOrder() async {
  if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
    _showErrorDialog('Vui lòng nhập đầy đủ Họ và Tên và Số điện thoại!');
    return;
  }

  // Lấy access_token từ SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  String formattedDate =
      DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.departureDate));
  String? token = prefs.getString('access_token');
  if (token == null) {
    _showErrorDialog('Không tìm thấy token. Vui lòng đăng nhập lại.');
    return;
  }

  // Tạo body cho API
  final Map<String, dynamic> requestBody = {
    "customerName": _nameController.text,
    "customerPhoneNumber": _phoneController.text,
    "busTripScheduleId": widget.busTripScheduleId,
    "province": widget.arrivalProvince,
    "numberOfTicket": _quantity,
    "departureDate": formattedDate,
    
  };

  final url = Uri.parse('http://10.0.2.2:8080/api/v1/orderBusTrips');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['statusCode'] == 201) {
        final keyOrder = data['data']['keyOrder']; // Lấy keyOrder
        // Lấy URL thanh toán
        _fetchPaymentUrl(keyOrder);
      } else {
        logger.e('Lỗi API: ${data['message']}');
      }
    } else {
      logger.e('Lỗi khi gọi API. Mã lỗi: ${response.statusCode}');
      logger.e('Chi tiết lỗi: ${response.body}');
    }
  } catch (e) {
    logger.e('Lỗi khi gửi yêu cầu API: $e');
  }
}

void _fetchPaymentUrl(String keyOrder) async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  if (token == null) {
    _showErrorDialog('Không tìm thấy token. Vui lòng đăng nhập lại.');
    return;
  }

  final paymentUrlApi = Uri.parse(
      'http://10.0.2.2:8080/api/v1/orders/create-payment?key=$keyOrder');

  try {
    final response = await http.get(
      paymentUrlApi,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['statusCode'] == 201) {
        final paymentUrl = data['data']['paymentUrl'];
        _navigateToPaymentPage(paymentUrl);
      } else {
        _showErrorDialog('Lỗi: ${data['message']}');
      }
    } else {
      _showErrorDialog('Lỗi khi gọi API thanh toán. Mã lỗi: ${response.statusCode}');
    }
  } catch (e) {
    _showErrorDialog('Đã xảy ra lỗi khi lấy URL thanh toán: $e');
  }
}
  void _navigateToPaymentPage(String paymentUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentPage(paymentUrl: paymentUrl),
    ),
  );
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : tripDetails == null
                  ? const Center(child: Text('Không có dữ liệu.'))
                  : _buildOrderInformation(),
    );
  }

  Widget _buildOrderInformation() {
    return Padding(
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
          _buildInfoRow('Thời gian mua vé',
              DateFormat('HH:mm dd-MM-yyyy').format(DateTime.now())),
          const SizedBox(height: 16),
          _buildJourneyDetails(),
          const Divider(height: 32, thickness: 1),
          _buildInfoRow('Nhà xe', tripDetails!['businessPartnerInfo']['name']),
          _buildInfoRow('Biển số xe', tripDetails!['busInfo']['licensePlate']),
          _buildInfoRow(
              'Loại xe đặt', tripDetails!['busInfo']['busType']['name']),
          _buildInfoRow(
              'Loại ghế', tripDetails!['busInfo']['busType']['chairType']),
          const Divider(height: 32, thickness: 1),
          _buildPaymentDetails(),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.orange,
            ),
            onPressed: _submitOrder, // Gọi hàm _submitOrder
            child: const Text(
              'Thanh toán',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
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
    );
  }

  Widget _buildJourneyDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Text(tripDetails!['busTripInfo']['departureLocation']),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.orange),
                const SizedBox(width: 8),
                Text(tripDetails!['departureTime']),
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
                Text(tripDetails!['busTripInfo']['arrivalLocation']),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.orange),
                const SizedBox(width: 8),
                Text(tripDetails!['arrivalTime']),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
              textAlign: TextAlign.end,
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
        _buildInfoRow('Tiền vé xe', tripDetails!['priceTicket']),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Căn các phần tử trái và phải
          children: [
            const Text('Số lượng:'),
            Row(
              children: [
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
          ],
        ),
        _buildInfoRow('Giảm giá', '-${tripDetails!['discountPercentage']} %'),
        const SizedBox(height: 8),
        Divider(thickness: 1, color: Colors.grey[300]),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng tiền cần thanh toán:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${NumberFormat('#,##0').format(updatedTotalAmount)} VND',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red, // Màu đỏ cho tổng tiền
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
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
