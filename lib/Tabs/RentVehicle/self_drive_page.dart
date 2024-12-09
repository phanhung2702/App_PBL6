import 'package:app_pbl6/Tabs/RentVehicle/seflvehicle_detail.dart';
import 'package:flutter/material.dart';

class SelfDrivePage extends StatefulWidget {
  @override
  SelfDrivePageState createState() => SelfDrivePageState();
}

class SelfDrivePageState extends State<SelfDrivePage> {
  final ScrollController _scrollController = ScrollController();
  double scrollAmount = 100; // Số pixel để cuộn mỗi lần
  String selectedCategory = 'Tất cả';
  String sortOption = 'Mặc định'; // Giá trị mặc định
  List<Map<String, dynamic>> vehicles = [
    {
      'image': 'assets/thue_xe/ex155.jpg',
      'discount': 20,
      'name': 'Exciter 155 VVA',
      'location': 'Quận Hải Châu, Đà Nẵng',
      'engineCapacity': '155cc',
      'year': 2021,
      'rating': 4.5,
      'pricePerHour': 100000,
      'discountedPricePerHour': 80000,
    },
    {
      'image': 'assets/thue_xe/vision.jpg',
      'discount': 15,
      'name': 'Vision 2022',
      'location': 'Quận Sơn Trà, Đà Nẵng',
      'engineCapacity': '125cc',
      'year': 2022,
      'rating': 4.7,
      'pricePerHour': 90000,
      'discountedPricePerHour': 76500,
    },
    {
      'image': 'assets/thue_xe/sh1.jpg',
      'discount': 10,
      'name': 'SH 2021',
      'location': 'Quận Thanh Khê, Đà Nẵng',
      'engineCapacity': '150cc',
      'year': 2021,
      'rating': 4.6,
      'pricePerHour': 95000,
      'discountedPricePerHour': 85500,
    },
  ];

  void _sortVehicles() {
    setState(() {
      if (sortOption == 'Giá cao đến thấp') {
        vehicles.sort((a, b) => b['discountedPricePerHour'].compareTo(a['discountedPricePerHour']));
      } else if (sortOption == 'Giá thấp đến cao') {
        vehicles.sort((a, b) => a['discountedPricePerHour'].compareTo(b['discountedPricePerHour']));
      }
    });
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
                            _scrollController.offset + scrollAmount,
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
                        Text(
                          'Sắp xếp',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),

          // Dòng trạng thái sắp xếp
          Center(
            child: Text(
              'Sắp xếp: $sortOption',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Danh sách các xe
          ...vehicles.map((vehicle) => _buildVehicleCard(
                image: vehicle['image'],
                discount: vehicle['discount'],
                name: vehicle['name'],
                location: vehicle['location'],
                engineCapacity: vehicle['engineCapacity'],
                year: vehicle['year'],
                rating: vehicle['rating'],
                pricePerHour: vehicle['pricePerHour'],
                discountedPricePerHour: vehicle['discountedPricePerHour'],
              )),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, IconData icon) {
    final isSelected = selectedCategory == title;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = title;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color.fromARGB(255, 214, 72, 32) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: isSelected ? Colors.black : const Color.fromARGB(255, 214, 72, 32),
            ),
            const SizedBox(width: 4.0),
            Text(
              title,
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
    required int discount,
    required String name,
    required String location,
    required String engineCapacity,
    required int year,
    required double rating,
    required int pricePerHour,
    required int discountedPricePerHour,
  }) {
    return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelfDriveDetailsPage(
            vehicle: {
              'image': image,
              'discount': discount,
              'name': name,
              'location': location,
              'engineCapacity': engineCapacity,
              'year': year,
              'rating': rating,
              'pricePerHour': pricePerHour,
              'discountedPricePerHour': discountedPricePerHour,
            },
          ),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8.0),
                ),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    '-$discount%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dung tích: $engineCapacity',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Năm: $year',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.orange,
                        ),
                        Text(
                          ' $rating',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        text: '$discountedPricePerHour₫/giờ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '  $pricePerHour₫',
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
