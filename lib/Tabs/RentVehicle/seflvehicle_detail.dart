// import 'package:app_pbl6/Tabs/RentVehicle/order_selfVehicle.dart';
// import 'package:flutter/material.dart';

// class SelfDriveDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> vehicle;

//   const SelfDriveDetailsPage({super.key, required this.vehicle});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           vehicle['name'],
//           style: const TextStyle(
//             color: Color.fromARGB(255, 214, 72, 32),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 255, 230, 224),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hình ảnh xe
//             Stack(
//               children: [
//                 Image.asset(
//                   vehicle['image'],
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 4.0),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(4.0),
//                     ),
//                     child: Text(
//                       '-${vehicle['discount']}%',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Tên xe
//                   Text(
//                     vehicle['name'],
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Địa chỉ
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: Colors.red),
//                       const SizedBox(width: 8),
//                       Text(
//                         vehicle['location'],
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // Giá thuê
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                           text: '${vehicle['discountedPricePerHour']}₫/giờ',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: '  ${vehicle['pricePerHour']}₫',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 decoration: TextDecoration.lineThrough,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   // Tabs Thông tin, Điều khoản, Đánh giá
//                   DefaultTabController(
//                     length: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const TabBar(
//                           labelColor: Color.fromARGB(255, 214, 72, 32),
//                           unselectedLabelColor: Colors.black,
//                           indicatorColor: Color.fromARGB(255, 214, 72, 32),
//                           tabs: [
//                             Tab(text: 'Thông tin'),
//                             Tab(text: 'Điều khoản'),
//                             Tab(text: 'Đánh giá'),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         SizedBox(
//                           height: 200, // Chiều cao của nội dung Tab
//                           child: TabBarView(
//                             children: [
//                               // Tab Thông tin
//                               SingleChildScrollView(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const Row(
//                                           children: [
//                                             Icon(Icons.person,
//                                                 color: Colors.blue),
//                                             SizedBox(width: 8),
//                                             Text(
//                                               'Chủ xe: Phan Quốc Hùng',
//                                               style: TextStyle(fontSize: 16),
//                                             ),
//                                           ],
//                                         ),
//                                         ElevatedButton(
//                                           onPressed: () {
//                                             // Xử lý sự kiện "Nhắn tin"
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               const SnackBar(
//                                                 content: Text(
//                                                   'Tính năng nhắn tin đang được phát triển!',
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor:
//                                                 const Color.fromARGB(
//                                                     255, 214, 72, 32),
//                                           ),
//                                           child: const Text(
//                                             'Nhắn tin',
//                                             style: TextStyle(
//                                                 color: Colors.white),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 8),
//                                     const Row(
//                                       children: [
//                                         Icon(Icons.phone,
//                                             color: Colors.orange),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           'SĐT: 0346928407',
//                                           style: TextStyle(fontSize: 16),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 16),
//                                     const Text(
//                                       'Đặc điểm',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             const Icon(Icons.motorcycle,
//                                                 color: Colors.green),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Loại xe: \n${vehicle['engineCapacity']}',
//                                               style: const TextStyle(
//                                                   fontSize: 14),
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             const Icon(Icons.event,
//                                                 color: Color.fromARGB(
//                                                     255, 214, 72, 32)),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               'Đời xe: \n${vehicle['year']}',
//                                               style: const TextStyle(
//                                                   fontSize: 14),
//                                             ),
//                                           ],
//                                         ),
//                                         const Row(
//                                           children: [
//                                             Icon(Icons.inventory,
//                                                 color: Colors.teal),
//                                             SizedBox(width: 8),
//                                             Text(
//                                               'Còn: \n5 chiếc',
//                                               style: TextStyle(fontSize: 14),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Tab Điều khoản
//                               const Center(
//                                 child: Text(
//                                   'Các điều khoản thuê xe sẽ được hiển thị tại đây.',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                               // Tab Đánh giá
//                               const Center(
//                                 child: Text(
//                                   'Các đánh giá sẽ được hiển thị tại đây.',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Thêm Container phía dưới
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Thời gian thuê
//                         // Thời gian nhận
// // Thời gian nhận
// const Row(
//   children: [
//     Text(
//       'Thời gian nhận:',
//       style: TextStyle(fontSize: 16),
//     ),
//     SizedBox(width: 8),
//     Icon(Icons.access_time, color: Colors.blue),
//     SizedBox(width: 8),
//     Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         '15:00',
//         style: TextStyle(fontSize: 16),
//       ),
//     ),
//     SizedBox(width: 8),
//     Icon(Icons.calendar_today, color: Colors.blue),
//     SizedBox(width: 8),
//     Text(
//       '19/12/2024',
//       style: TextStyle(fontSize: 16),
//     ),
//   ],
// ),

// // Thời gian trả
// const Row(
//   children: [
//     Text(
//       'Thời gian trả:',
//       style: TextStyle(fontSize: 16),
//     ),
//     SizedBox(width: 8),
//     Icon(Icons.access_time, color: Colors.blue),
//     SizedBox(width: 8),
//     Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         '15:00',
//         style: TextStyle(fontSize: 16),
//       ),
//     ),
//     SizedBox(width: 8),
//     Icon(Icons.calendar_today, color: Colors.blue),
//     SizedBox(width: 8),
//     Text(
//       '21/12/2024',
//       style: TextStyle(fontSize: 16),
//     ),
//   ],
// ),
//                         const SizedBox(height: 8),
//                         // Phí thuê
//                         const Row(
//                           children: [
//                             Icon(Icons.attach_money, color: Colors.green),
//                             SizedBox(width: 8),
//                             Text(
//                               'Phí thuê: 240.000đ',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         // Mã giảm giá
//                         const Row(
//                           children: [
//                             Icon(Icons.discount, color: Colors.orange),
//                             SizedBox(width: 8),
//                             Text(
//                               'Mã giảm giá: ABC123',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         // Tiền cọc
//                         const Row(
//                           children: [
//                             Icon(Icons.monetization_on, color: Colors.red),
//                             SizedBox(width: 8),
//                             Text(
//                               'Tiền cọc: 1.000.000đ',
//                               style: TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           'Tiền cọc sẽ được hoàn trả khi hoàn thành thủ tục trả xe.',
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         const SizedBox(height: 16),
//                         // Nút Thuê xe
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Chuyển đến OrderSelfVehiclePage
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => OrderSelfVehiclePage(vehicle: vehicle),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:
//                                   const Color.fromARGB(255, 214, 72, 32),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 12),
//                             ),
//                             child: const Text(
//                               'Thuê xe',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:app_pbl6/Tabs/RentVehicle/order_selfVehicle.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class SelfDriveDetailsPage extends StatefulWidget {
//   final int vehicleRentalServiceId;

//   const SelfDriveDetailsPage({super.key, required this.vehicleRentalServiceId});

//   @override
//   State<SelfDriveDetailsPage> createState() => _SelfDriveDetailsPageState();
// }

// class _SelfDriveDetailsPageState extends State<SelfDriveDetailsPage> {
//   Map<String, dynamic>? vehicle;
//   bool isLoading = true;
//   String? token;

//   @override
//   void initState() {
//     super.initState();
//     loadTokenAndFetchVehicleDetails();
//   }

//   // Lấy token từ SharedPreferences và fetch dữ liệu
//   Future<void> loadTokenAndFetchVehicleDetails() async {
//     final prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('access_token'); // Lấy token từ SharedPreferences
//     if (token == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Bạn cần đăng nhập để tiếp tục!')),
//         );
//         return;
//       }
//     }
//     fetchVehicleDetails();
//   }

//   // Fetch dữ liệu chi tiết xe từ API
//   Future<void> fetchVehicleDetails() async {
//     final url =
//         'http://10.0.2.2:8080/user/vehicle-register/get-vehicle-register?vehicle_rental_service_id=${widget.vehicleRentalServiceId}';
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(utf8.decode(response.bodyBytes));
//         setState(() {
//           vehicle = data['data'];
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load vehicle details');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Lỗi: ${e.toString()}')),
//         );
//       }
//     }
//   }

//   void handleRentVehicle() {
//     // Điều hướng sang trang OrderSelfVehiclePage
//     if (vehicle != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => OrderSelfVehiclePage(vehicle: vehicle!),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Dữ liệu xe không khả dụng!')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (vehicle == null) {
//       return const Scaffold(
//         body: Center(child: Text('Không thể tải dữ liệu xe.')),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           vehicle!['manufacturer'] ?? 'Chi tiết xe',
//           style: const TextStyle(
//             color: Color.fromARGB(255, 214, 72, 32),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 255, 230, 224),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hình ảnh
//             if (vehicle!['imagesVehicleRegister'] != null &&
//                 vehicle!['imagesVehicleRegister'].isNotEmpty)
//               Stack(
//                 children: [
//                   Image.network(
//                     vehicle!['imagesVehicleRegister'][0],
//                     width: double.infinity,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                   if (vehicle!['discount_percentage'] != null)
//                     Positioned(
//                       top: 8,
//                       left: 8,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8.0, vertical: 4.0),
//                         decoration: BoxDecoration(
//                           color: Colors.red.withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(4.0),
//                         ),
//                         child: Text(
//                           '-${vehicle!['discount_percentage']}%',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Tên xe
//                   Text(
//                     vehicle!['manufacturer'] ?? '',
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Địa chỉ
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: Colors.red),
//                       const SizedBox(width: 8),
//                       Text(
//                         vehicle!['location'] ?? '',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // Giá thuê
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       RichText(
//                         text: TextSpan(
//                           text:
//                               '${vehicle!['reservation_fees']?.toStringAsFixed(0)}₫/giờ',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.red,
//                           ),
//                           children: [
//                             TextSpan(
//                               text:
//                                   '  ${vehicle!['price']?.toStringAsFixed(0)}₫',
//                               style: const TextStyle(
//                                 fontSize: 14,
//                                 decoration: TextDecoration.lineThrough,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   // Thông tin
//                   Text(
//                     vehicle!['description'] ?? '',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   // Nút Thuê xe
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: handleRentVehicle,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(255, 214, 72, 32),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 40, vertical: 12),
//                       ),
//                       child: const Text(
//                         'Thuê xe',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:app_pbl6/Tabs/RentVehicle/order_selfVehicle.dart';
import 'package:app_pbl6/utils/sharedpre.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfDriveDetailsPage extends StatefulWidget {
  final int vehicleRentalServiceId;

  const SelfDriveDetailsPage({super.key, required this.vehicleRentalServiceId});

  @override
  SelfDriveDetailsPageState createState() => SelfDriveDetailsPageState();
}

class SelfDriveDetailsPageState extends State<SelfDriveDetailsPage> {
  Map<String, dynamic>? vehicleDetails;
  bool isLoading = true;
  String? token;
  String? startTime;
  String? endTime;
  int quantity = 1;
  double rentalFee = 0.0;
  double? discountedPrice;
  double carDeposit = 0.0; // Sẽ được cập nhật sau khi lấy từ API
  double reservationFees = 0.0; // Sẽ được cập nhật sau khi lấy từ API
  String formatCurrency(double amount) {
    final numberFormat =
        NumberFormat('#,###', 'vi_VN'); // Định dạng theo chuẩn Việt Nam
    return numberFormat.format(amount);
  }

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchDetails();
  }

  Future<void> _loadTokenAndFetchDetails() async {
    token = await _getToken();
    if (token != null) {
      await _fetchVehicleDetails();
    } else {
      setState(() {
        isLoading = false;
      });
      logger.e("Token is null. Cannot fetch details.");
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _fetchVehicleDetails() async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/user/vehicle-register/get-vehicle-register?vehicle_rental_service_id=${widget.vehicleRentalServiceId}');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['data'] != null) {
          setState(() {
            vehicleDetails = data['data'];
            // Đảm bảo rằng tất cả dữ liệu cần thiết có sẵn
            final double price = vehicleDetails?['selfDriverPrice'] ?? 0.0;
            final double discountPercentage =
                vehicleDetails?['discount_percentage'] ?? 0.0;
            discountedPrice = price * (1 - discountPercentage / 100);
            
            isLoading = false;
          });
          logger.i('$vehicleDetails');
          logger.i('$discountedPrice');
          logger.i('$carDeposit');
          logger.i('$reservationFees');
        } else {
          logger.e('Không có dữ liệu trả về từ server.');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        logger.e('Lấy thông tin xe thất bại: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      logger.e('Lỗi khi lấy thông tin xe: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm tính phí thuê
  Future<void> calculateRentalFee() async {
    if (startTime != null && endTime != null && discountedPrice != null) {
      final url = Uri.parse(
          'http://10.0.2.2:8080/api/v1/vehicle-rental-order/calculate-price-by-start-and-end-time?start_time=$startTime&end_time=$endTime&priceADay=$discountedPrice');

      logger.i('Sending request to calculate rental fee:');
      logger.i(
          'Start time: $startTime, End time: $endTime, Price per day: $discountedPrice');
      try {
        final response = await http.get(url, headers: {
          'Authorization': 'Bearer $token',
        });
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            rentalFee = data['data'];
          });
        } else {
          logger.e(
              'Tính toán phí thuê xe thất bại: ${response.statusCode}, ${response.body}');
        }
      } catch (e) {
        logger.e('Lỗi khi tính toán phí thuê xe: $e');
      }
    } else {
      logger.e(
          'Thời gian bắt đầu, thời gian kết thúc, hoặc giá thuê xe là null.');
    }
  }

  // Hàm định dạng ngày giờ
  String formatDateTime(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('HH:mm dd-MM-yyyy');
    return dateFormat.format(dateTime);
  }

  // Hàm chọn ngày
  Future<void> _selectDateTime(bool isStartDate) async {
    if (!mounted) return; // Kiểm tra mounted trước khi showDatePicker

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!mounted) return; // Kiểm tra lại mounted sau showDatePicker

    if (pickedDate != null) {
      if (!mounted) return; // Kiểm tra trước khi showTimePicker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (!mounted) return; // Kiểm tra lại mounted sau showTimePicker

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            startTime = DateFormat('HH:mm dd-MM-yyyy').format(selectedDateTime);
          } else {
            endTime = DateFormat('HH:mm dd-MM-yyyy').format(selectedDateTime);
          }
        });

        // Tính lại phí thuê
        calculateRentalFee();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (vehicleDetails == null) {
      return const Scaffold(
        body: Center(
          child: Text('Không thể tải thông tin chi tiết xe.'),
        ),
      );
    }

    final double price = vehicleDetails?['selfDriverPrice'] ?? 0.0;
    final double discountPercentage =
        vehicleDetails?['discount_percentage'] ?? 0.0;
    final discountedPrice = price * (1 - discountPercentage / 100);
    final double carDeposit = vehicleDetails?['car_deposit'] ?? 0.0; // Sẽ được cập nhật sau khi lấy từ API
    final double reservationFees = vehicleDetails?['reservation_fees'] ?? 0.0; // Sẽ được cập nhật sau khi lấy từ API

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết xe tự lái',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFFFF0E8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh xe
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image:
                        vehicleDetails?['imagesVehicleRegister']?.isNotEmpty ==
                                true
                            ? NetworkImage(
                                vehicleDetails?['imagesVehicleRegister'][0])
                            : const AssetImage('assets/thue_xe/ex155.jpg')
                                as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tên xe
              Center(
                child: Text(
                  vehicleDetails?['manufacturer'] ?? 'Tên xe',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              // Địa điểm và giá xe
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        vehicleDetails?['location'] ?? 'Địa điểm',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      
                      Text(
                        '${formatCurrency(price)}đ/ngày',
                        style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${formatCurrency(discountedPrice)}đ/ngày',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tabs for thông tin, điều khoản, đánh giá
              const Divider(),
              DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.red,
                      tabs: [
                        Tab(text: 'Thông tin'),
                        Tab(text: 'Điều khoản'),
                        Tab(text: 'Đánh giá'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        children: [
                          // Tab Thông tin
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person,
                                            color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(
                                          vehicleDetails?['partnerName'] ??
                                              'N/A',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Logic đặt xe
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Nhắn tin',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.phone,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text(
                                      vehicleDetails?['partnerPhoneNumber'] ??
                                          'N/A',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text('Đặc điểm',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.directions_bike,
                                        color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Loại xe: ${vehicleDetails?['vehicle_type'] ?? 'N/A'}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: Colors.yellow),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Đời xe: ${vehicleDetails?['vehicleLife'] ?? 'N/A'}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_cart,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Còn ${vehicleDetails?['amount'] ?? 0} chiếc',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Mô tả
                                const Text('Mô tả',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(
                                  vehicleDetails?['description'] ??
                                      'Mô tả không có',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 16),
                                // Tiện ích
                                const Text('Tiện ích',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(
                                  vehicleDetails?['ulties'] ??
                                      'Tiện ích không có',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),

                          // Tab Điều khoản
                          SingleChildScrollView(
                            child: Text(
                              vehicleDetails?['policy'] ??
                                  'Điều khoản không có',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),

                          // Tab Đánh giá
                          const Center(
                              child: Text(
                            'Chưa có đánh giá.',
                            style: TextStyle(fontSize: 18),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thời gian thuê:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Column(
  children: [
    // Thời gian nhận
    Row(
      children: [
        const Text(
          'Thời gian nhận:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(), // Đảm bảo TextButton nằm ở phía bên phải
        ),
        TextButton(
          onPressed: () => _selectDateTime(true),
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200],
          ),
          child: Text(
            startTime ?? 'Chọn ngày & giờ',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
    const SizedBox(height: 16), // Khoảng cách giữa 2 hàng
    // Thời gian trả
    Row(
      children: [
        const Text(
          'Thời gian trả:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(), // Đảm bảo TextButton nằm ở phía bên phải
        ),
        TextButton(
          onPressed: () => _selectDateTime(false),
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[200],
          ),
          child: Text(
            endTime ?? 'Chọn ngày & giờ',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    ),
  ],
),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Số lượng thuê:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
      child: Container(), // Đảm bảo phần số lượng nằm phía bên phải
    ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) quantity--;
                                });
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Phí thuê:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${formatCurrency(rentalFee)}đ',
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text("Chi phí khác:",
                        style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    // Tiền cọc xe
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tiền cọc xe:"),
                        Text("${formatCurrency(carDeposit)}đ"),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Tiền giữ chỗ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Tiền giữ chỗ:"),
                        Text("${formatCurrency(reservationFees)}đ"),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Nút "Thuê xe"
                    Center(
                      child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSelfVehiclePage( // Thay OrderSelfVehiclePage bằng trang thực tế của bạn
      rentalFee : rentalFee, // Truyền giá trị giá thuê sau khi giảm giá
      quantity: quantity, // Truyền số lượng
      carDeposit: carDeposit, // Truyền tiền cọc
      reservationFees: reservationFees, // Truyền tiền giữ chỗ
      vehicleRentalServiceId: vehicleDetails?['vehicle_register_id'],
      startRentalTime: startTime,
      endRentalTime: endTime,
      pickUpLocation: vehicleDetails?['location'],
      ),
      ),
    );
                        
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: Text("Thuê xe"),
                    ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
