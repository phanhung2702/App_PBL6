
import 'dart:convert';
import 'package:app_pbl6/Tabs/RentVehicle/seflvehicle_detail.dart';
import 'package:app_pbl6/utils/sharedpre.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SelfDrivePage extends StatefulWidget {
  @override
  SelfDrivePageState createState() => SelfDrivePageState();
}

class SelfDrivePageState extends State<SelfDrivePage> {
  final ScrollController _scrollController = ScrollController();
  String sortOption = 'Mặc định';
  List<Map<String, dynamic>> vehicles = [];
  List<Map<String, dynamic>> allVehicles = [];
  List<Map<String, String>> provinces = [];

  String selectedVehicleType = 'Tất cả';
  String selectedBrand = 'Tất cả';
  String selectedProvince = 'Tất cả';
  Set<String> selectedCategories = {};

  String formatCurrency(double amount) {
    final numberFormat =
        NumberFormat('#,###', 'vi_VN'); // Định dạng theo chuẩn Việt Nam
    return numberFormat.format(amount);
  }

  @override
  void initState() {
    super.initState();
    _loadVehicles();
    _loadProvinces();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> _loadVehicles() async {
    final token = await getToken();
    if (token != null) {
      try {
        final response = await fetchVehicles(token);
        if (response != null) {
          setState(() {
            allVehicles = response;
            vehicles = allVehicles;
          });
        }
      } catch (e) {
        logger.e('Error loading vehicles: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>?> fetchVehicles(String token) async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/user/vehicle-register/all?service_type=0&status=available&car_rental_partner_id=-1');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List vehicles = data['data'];
      return vehicles.map((vehicle) {
        return {
          'vehicle_register_id': vehicle['vehicle_register_id'],
          'selfDriverPrice': vehicle['selfDriverPrice'],
          'location': vehicle['location'],
          'manufacturer': vehicle['manufacturer'],
          'vehicleLife': vehicle['vehicleLife'],
          'vehicle_type': vehicle['vehicle_type'],
          'discount_percentage': vehicle['discount_percentage'],
          'amount': vehicle['amount'],
          'imagesVehicleRegister': vehicle['imagesVehicleRegister'],
          'rating_total': vehicle['rating_total'],
          'vehicle_type_id': vehicle['vehicle_type_id'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<void> _loadProvinces() async {
    try {
      final data = await fetchProvinces();
      setState(() {
        provinces = [
              {
                'code': '-1',
                'name': 'Tất cả'
              } // Đồng nhất giá trị `code` thành kiểu String
            ] +
            data;
      });
    } catch (e) {
      logger.e('Error loading provinces: $e');
    }
  }

  Future<List<Map<String, String>>> fetchProvinces() async {
    final url = Uri.parse('https://provinces.open-api.vn/api/?depth=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as List;
      return data.map((province) {
        return {
          'code': province['code'].toString(), // Chuyển thành String
          'name': province['name']
              .toString()
              .replaceAll('Tỉnh ', '')
              .replaceAll('Thành phố ', ''), // Lược bỏ "Tỉnh" và "Thành phố"
        };
      }).toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  void _filterVehicles() {
    setState(() {
      if (selectedCategories.isEmpty) {
        // Nếu không có bộ lọc, hiển thị toàn bộ danh sách xe
        vehicles = allVehicles;
        return;
      }
      vehicles = allVehicles.where((vehicle) {
        bool matchesCategory = true;

        // Lọc theo loại xe
        if (selectedCategories.contains('Loại xe')) {
          if (selectedVehicleType == 'Xe máy') {
            matchesCategory &= vehicle['vehicle_type_id'] == 1;
          } else if (selectedVehicleType == 'Xe máy điện') {
            matchesCategory &= vehicle['vehicle_type_id'] == 2;
          }
        }

        // Lọc theo khu vực
        if (selectedCategories.contains('Khu vực xe')) {
          matchesCategory &= vehicle['location'] == selectedProvince;
        }

        // Lọc theo hãng xe
        if (selectedCategories.contains('Hãng xe')) {
          matchesCategory &= vehicle['manufacturer'] == selectedBrand;
        }

        return matchesCategory;
      }).toList();
    });
  }

  void _filterVehiclesByBrand(String? brandName) {
    setState(() {
      if (brandName == 'Tất cả') {
        vehicles = allVehicles; // Hiển thị tất cả xe nếu chọn "Tất cả"
      } else {
        vehicles = allVehicles.where((vehicle) {
          return vehicle['manufacturer'] == brandName; // Lọc theo hãng xe
        }).toList();
      }
    });
  }

  void _showSubCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final subCategories = ['Tất cả', 'Xe máy', 'Xe máy điện'];
        return AlertDialog(
          title: const Text('Chọn loại xe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: subCategories.map((subCategory) {
              return RadioListTile<String>(
                title: Text(subCategory),
                value: subCategory,
                groupValue: selectedVehicleType,
                activeColor: const Color.fromARGB(255, 214, 72, 32),
                onChanged: (value) {
                  setState(() {
                    selectedVehicleType = value ?? 'Tất cả';
                    _filterVehicles();
                    Navigator.pop(context); // Close the dialog
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showProvinceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn khu vực'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: provinces.map((province) {
                return RadioListTile<String>(
                  title: Text(
                    province['name']!.replaceAll('Tỉnh ', '').replaceAll(
                        'Thành phố ', ''), // Lược bỏ "Tỉnh" và "Thành phố"
                  ),
                  value: province['name']!,
                  groupValue: selectedProvince,
                  activeColor: const Color.fromARGB(255, 214, 72, 32),
                  onChanged: (value) {
                    setState(() {
                      selectedProvince = value ?? 'Tất cả';
                      _filterVehiclesByProvince(selectedProvince);
                      Navigator.pop(context); // Đóng dialog
                    });
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showBrandDialog() {
    const brands = ['Honda', 'Yamaha', 'Vinfast', 'Toyota'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn hãng xe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: brands.map((brand) {
                return RadioListTile<String>(
                  title: Text(brand),
                  value: brand,
                  groupValue:
                      selectedBrand, // Dùng lại selectedSubCategory để lưu trạng thái
                  activeColor: const Color.fromARGB(255, 214, 72, 32),
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value ?? 'Tất cả';
                      _filterVehiclesByBrand(selectedBrand);
                      Navigator.pop(context); // Đóng dialog
                    });
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryButton(String title, IconData icon) {
   
    
    // Hiển thị tên động cho từng nút
    String displayTitle = title;
    if (title == 'Loại xe' && selectedCategories.contains('Loại xe')) {
      displayTitle = selectedVehicleType;
    } else if (title == 'Khu vực xe' &&
        selectedCategories.contains('Khu vực xe')) {
      displayTitle = selectedProvince;
    } else if (title == 'Hãng xe' && selectedCategories.contains('Hãng xe')) {
      displayTitle = selectedBrand;
    }

    final isSelected =
        selectedCategories.contains(title); // Kiểm tra trạng thái được chọn

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              selectedCategories.remove(title); // Bỏ chọn
            } else {
              selectedCategories.add(title); // Thêm vào danh sách được chọn
            }

            // Hiển thị dialog khi cần
            if (title == 'Loại xe') {
              _showSubCategoryDialog();
            } else if (title == 'Khu vực xe') {
              _showProvinceDialog();
            } else if (title == 'Hãng xe') {
              _showBrandDialog();
            }

            _filterVehicles(); // Lọc lại danh sách xe dựa trên trạng thái
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 214, 72, 32)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: isSelected
                  ? Colors.black
                  : const Color.fromARGB(255, 214, 72, 32),
            ),
            const SizedBox(width: 4.0),
            Text(
              displayTitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard({
    required String image,
    required String name,
    required String location,
    required String engineCapacity,
    required String year,
    required int amount,
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
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    image.isNotEmpty ? image : 'assets/thue_xe/ex155.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Giảm giá: $discount%',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(location, style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.directions_car,
                        size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(engineCapacity, style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_filled,
                        size: 20, color: Color.fromARGB(255, 255, 234, 47)),
                    const SizedBox(width: 8),
                    Text(year, style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.shopping_cart,
                        size: 20, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('Số lượng còn $amount chiếc',
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 4),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 255, 230, 224)),
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 251, 252, 245),
                      ),
                      child: Row(
                        children: [
                          Text('$rating', style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          const Icon(Icons.star,
                              size: 20, color: Colors.yellow),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 255, 230, 224)),
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 255, 230, 224),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${formatCurrency(pricePerHour)}đ/ngày',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.account_balance,
                                  size: 20,
                                  color: Color.fromARGB(255, 214, 72, 32)),
                              const SizedBox(width: 8),
                              Text(
                                '${formatCurrency(discountedPricePerHour)}đ/ngày',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
            color: Color.fromARGB(255, 214, 72, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 230, 224),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // Container bọc các CategoryButton
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1), // Viền đen
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryButton('Khu vực xe', Icons.location_on),
                        _buildCategoryButton('Hãng xe', Icons.directions_car),
                        _buildCategoryButton('Loại xe', Icons.motorcycle),
                      ],
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.black),
              ],
            ),
          ),
          // Sắp xếp nút riêng biệt
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 214, 72, 32),
                      width: 1.5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      sortOption = value;
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
                      Icon(Icons.sort,
                          color: Color.fromARGB(255, 214, 72, 32), size: 20),
                      SizedBox(width: 4),
                      Text('Sắp xếp',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return GestureDetector(
      onTap: () {
        // Chuyển hướng đến OrderSelfVehiclePage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelfDriveDetailsPage(vehicleRentalServiceId: vehicle['vehicle_register_id'],),
          ),
        );
      },
              child:  _buildVehicleCard(
                image: vehicle['imagesVehicleRegister'].isNotEmpty
                    ? vehicle['imagesVehicleRegister'][0]
                    : 'assets/thue_xe/ex155.jpg',
                name: vehicle['manufacturer'],
                location: vehicle['location'],
                engineCapacity: vehicle['vehicle_type'],
                year: vehicle['vehicleLife'],
                amount: vehicle['amount'],
                rating: vehicle['rating_total'],
                pricePerHour: vehicle['selfDriverPrice'],
                discountedPricePerHour: vehicle['selfDriverPrice'] *
                    (1 - vehicle['discount_percentage'] / 100),
                discount: vehicle['discount_percentage'].toInt(),
              ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _filterVehiclesByProvince(String? provinceName) {
    setState(() {
      if (provinceName == 'Tất cả') {
        vehicles = allVehicles; // Hiển thị tất cả xe nếu chọn "Tất cả"
      } else {
        vehicles = allVehicles.where((vehicle) {
          return vehicle['location'] == provinceName; // So sánh với String
        }).toList();
      }
    });
  }
}
