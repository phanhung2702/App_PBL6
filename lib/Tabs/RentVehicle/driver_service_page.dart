import 'dart:convert';
import 'package:app_pbl6/utils/sharedpre.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DriverServicePage extends StatefulWidget {
  @override
  DriverServicePageState createState() => DriverServicePageState();
}

class DriverServicePageState extends State<DriverServicePage> {
  final ScrollController _scrollController = ScrollController();
  String selectedCategory = 'Tất cả';
  String sortOption = 'Mặc định';
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  // Hàm lấy token từ SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Hàm tải dữ liệu xe từ API
  Future<void> _loadVehicles() async {
    final token = await getToken();
    if (token != null) {
      try {
        final response = await fetchVehicles(token);
        if (response != null) {
          setState(() {
            vehicles = response;
          });
        }
      } catch (e) {
        logger.e('Error loading vehicles: $e');
      }
    }
  }

  // Hàm gọi API để lấy danh sách xe
  Future<List<Map<String, dynamic>>?> fetchVehicles(String token) async {
    final url = Uri.parse('http://10.0.2.2:8080/user/vehicle-register/all?service_type=1&status=available&car_rental_partner_id=-1');
    
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List vehicles = data['data'];

      return vehicles.map((vehicle) {
        return {
          'id': vehicle['id'],
          'price': vehicle['price'],
          'location': vehicle['location'],
          'manufacturer': vehicle['manufacturer'],
          'vehicleLife': vehicle['vehicleLife'],
          'vehicle_type': vehicle['vehicle_type'],
          'discount_percentage': vehicle['discount_percentage'],
          'amount': vehicle['amount'],
          'imagesVehicleRegister': vehicle['imagesVehicleRegister'],
          'rating_total': vehicle['rating_total'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  // Hàm sắp xếp xe theo giá
  void _sortVehicles() {
    setState(() {
      if (sortOption == 'Giá cao đến thấp') {
        vehicles.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (sortOption == 'Giá thấp đến cao') {
        vehicles.sort((a, b) => a['price'].compareTo(b['price']));
      }
    });
  }

  // Widget hiển thị danh sách xe
  Widget _buildVehicleCard({
    required String image,
    required String name,
    required String location,
    required String engineCapacity,
    required String year,
    required double rating,
    required double pricePerHour,
    required double discountedPricePerHour,
    required int discount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Hình ảnh xe
          SizedBox(
            height: 100,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          // Thông tin xe
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$location | $engineCapacity', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(year, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Đánh giá: $rating', style: const TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text(
                      'Giá: ${discountedPricePerHour.toStringAsFixed(0)}đ',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Giảm giá: $discount%', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thuê xe tự lái',
          style: TextStyle(
            color: Color.fromARGB(255, 214, 72, 32), // Chỉnh màu chữ
            fontWeight: FontWeight.bold, // Đậm chữ
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 230, 224),
        centerTitle: true, // Căn chữ ra giữa
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Danh mục
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  constraints: const BoxConstraints(maxHeight: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildCategoryButton('Tất cả', Icons.category),
                              _buildCategoryButton('Khu vực xe', Icons.location_on),
                              _buildCategoryButton('Hãng xe', Icons.directions_car),
                              _buildCategoryButton('Loại xe', Icons.motorcycle),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.offset + 100,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Sắp xếp
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 214, 72, 32), width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        sortOption = value;
                        _sortVehicles();
                      });
                    },
                    offset: const Offset(0, 30),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Giá cao đến thấp',
                        child: Text('Giá cao đến thấp'),
                      ),
                      const PopupMenuItem(
                        value: 'Giá thấp đến cao',
                        child: Text('Giá thấp đến cao'),
                      ),
                    ],
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort, color: Color.fromARGB(255, 214, 72, 32), size: 20),
                        SizedBox(width: 4),
                        Text('Sắp xếp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Hiển thị danh sách xe
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return _buildVehicleCard(
                image: vehicle['imagesVehicleRegister'].isNotEmpty
                    ? vehicle['imagesVehicleRegister'][0]
                    : 'assets/images/default_car.png', // Hình ảnh mặc định
                name: vehicle['manufacturer'],
                location: vehicle['location'],
                engineCapacity: vehicle['vehicle_type'],
                year: vehicle['vehicleLife'],
                rating: vehicle['rating_total'],
                pricePerHour: vehicle['price'],
                discountedPricePerHour: vehicle['price'] * (1 - vehicle['discount_percentage'] / 100),
                discount: vehicle['discount_percentage'].toInt(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          backgroundColor: selectedCategory == category
              ? const Color.fromARGB(255, 214, 72, 32)
              : Colors.transparent,
          iconColor: selectedCategory == category ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(category, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
