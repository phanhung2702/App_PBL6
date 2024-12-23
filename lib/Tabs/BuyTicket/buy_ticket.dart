import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:app_pbl6/Tabs/BuyTicket/order_info_page.dart';
import 'package:logger/logger.dart';

// Danh sách các hình ảnh cho tab Mua vé
final List<String> buyTicketImages = [
  'assets/homeimages/4.jpg',
  'assets/homeimages/5.jpg',
];

class BuyTicketPage extends StatefulWidget {
  @override
  BuyTicketPageState createState() => BuyTicketPageState();
}

class BuyTicketPageState extends State<BuyTicketPage> {
  final PageController _pageController = PageController();
  String selectedBus = 'Chọn nhà xe';
  String selectedStartPlace = 'Nơi xuất phát';
  String selectedDestination = 'Nơi đến';
  DateTime? selectedDate;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  bool showResults = false;
  //bool isExpanded = false;
  
  Map<int, bool> expandedStates = {};
  final Logger logger = Logger();
  late Future<List<String>> provincesFuture;
  // Hàm loại bỏ "Tỉnh" và "Thành phố" từ tên tỉnh thành
  String cleanProvinceName(String name) {
  return name.replaceAll(RegExp(r"^(Tỉnh|Thành phố)\s+"), "");
}

  final List<Map<String, dynamic>> results = [];
  List<String> busNames = []; // Danh sách nhà xe

  Future<List<String>> fetchBusNames() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8080/api/v1/bus-partner/businessName'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));

      // Kiểm tra nếu có dữ liệu trong trường "data" và trả về
      if (data['data'] != null) {
        return List<String>.from(data['data']);
      } else {
        throw Exception('Dữ liệu nhà xe không hợp lệ');
      }
    } else {
      throw Exception('Không thể tải dữ liệu nhà xe');
    }
  }

  // Hàm lấy dữ liệu các tỉnh thành từ API
  Future<List<String>> _getProvinces() async {
    final response =
        await http.get(Uri.parse('https://provinces.open-api.vn/api/?depth=1'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data
          .map<String>((province) => province['name'] as String)
          .toList();
    } else {
      throw Exception('Không thể tải dữ liệu các tỉnh thành');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBusSchedules({
  required String filter,
  required String departureLocation,
  required String arrivalProvince,
  required String departureDate,
}) async {
  // Log các tham số
  logger.i('Filter: $filter');
  logger.i('Departure Location: $departureLocation');
  logger.i('Arrival Province: $arrivalProvince');
  logger.i('Departure Date: $departureDate');

  // Tạo chuỗi truy vấn thủ công mà không bị mã hóa tự động
  final queryString = 'filter=busTrip.busPartner.businessPartner.businessName:\'$filter\'&'
      'departureLocation=$departureLocation&'
      'arrivalProvince=$arrivalProvince&'
      'departureDate=$departureDate';

  // Tạo URL với chuỗi truy vấn thủ công
  final uri = Uri.parse('http://10.0.2.2:8080/api/v1/user/busTripSchedules?$queryString');

  // Log thông tin gửi lên server
  logger.i('Thông tin gửi lên server: $uri');

  // Gửi yêu cầu GET
  final response = await http.get(uri);

  // Xử lý kết quả trả về
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData =
        json.decode(utf8.decode(response.bodyBytes));
    logger.i('Kết quả: $responseData');

    if (responseData['data'] != null && responseData['data']['result'] != null) {
      return List<Map<String, dynamic>>.from(responseData['data']['result']);
    } else {
      throw Exception('Dữ liệu không hợp lệ');
    }
  } else {
    throw Exception('Lỗi kết nối: ${response.statusCode}');
  }
}

// Hàm lấy tiện ích từ API
Future<List<Map<String, dynamic>>> fetchUtilities(String busTypeId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/api/v1/user/busTripSchedules/utilities/$busTypeId'),
  );
  
  if (response.statusCode == 200) {
     String responseBody = utf8.decode(response.bodyBytes);
    final responseData = jsonDecode(responseBody);
    return List<Map<String, dynamic>>.from(responseData['data']);
  } else {
    throw Exception('Failed to load utilities');
  }
}


// Hàm lấy chính sách từ API
Future<List<String>> fetchPolicies(String businessPartnerId) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/api/v1/user/busTripSchedules/policies/$businessPartnerId'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data['data'] != null) {
      return List<String>.from(data['data']);
    } else {
      throw Exception('Dữ liệu chính sách không hợp lệ');
    }
  } else {
    throw Exception('Không thể tải dữ liệu chính sách');
  }
}

  // Hàm lấy điểm đón trả
  Future<Map<String, dynamic>> fetchPickupDropOffLocations(String busTripScheduleId, String arrivalProvince) async {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/user/busTripSchedules/pickup-dropOff-locations';
  final Uri uri = Uri.parse('$apiUrl?busTripScheduleId=$busTripScheduleId&arrivalProvince=$arrivalProvince');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
    return responseData['data'] as Map<String, dynamic>; // Chỉ lấy phần data
  } else {
    throw Exception('Không thể tải dữ liệu điểm đón/trả.');
  }
}



  // Hàm chọn ngày đi
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBusNames().then((names) {
      setState(() {
        busNames = names;
      });
    }).catchError((error) {
      logger.e('Lỗi: $error');
    });
    provincesFuture = _getProvinces(); // Gọi API để lấy danh sách tỉnh thành
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container chứa hình ảnh cho trang Mua vé
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 200, // Chiều cao của container chứa hình ảnh
              child: Stack(
                children: [
                  // Sử dụng PageView.builder để hiển thị danh sách hình ảnh
                  PageView.builder(
                    controller: _pageController,
                    itemCount: buyTicketImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10), // Bo tròn các góc
                        child: Image.asset(
                          buyTicketImages[index],
                          fit: BoxFit
                              .cover, // Hiển thị toàn bộ hình ảnh trong khung
                          width: double.infinity,
                          height: 200,
                        ),
                      );
                    },
                  ),
                  // Văn bản được chồng lên hình ảnh
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300]?.withOpacity(0.7), // Màu nền mờ
                        borderRadius: BorderRadius.circular(
                            10), // Bo tròn góc cho container chứa text
                      ),
                      child: const Text(
                        'Đặt vé xe khách online dễ dàng, an toàn và tiết kiệm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 214, 72, 32),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Hiển thị SmoothPageIndicator
            SmoothPageIndicator(
              controller: _pageController,
              count: buyTicketImages.length,
              effect: const WormEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.orange,
                dotColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Khung tìm kiếm
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label và Dropdown để chọn nhà xe
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Chọn nhà xe:'),
                      SizedBox(
                        width:
                            300.0, // Giới hạn chiều rộng của DropdownButtonFormField
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          value: selectedBus,
                          items: [
                            'Chọn nhà xe',
                            ...busNames, // Hiển thị các nhà xe từ API
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedBus = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Label và Dropdown để chọn nơi xuất phát
                  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text('Nơi xuất phát:'),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<String>>(
        future: _getProvinces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Không có dữ liệu');
          } else {
            final provinces = snapshot.data!.map((province) => cleanProvinceName(province)).toList(); // Loại bỏ "Tỉnh" và "Thành phố"
            return SizedBox(
              width: 300.0,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: selectedStartPlace,
                items: ['Nơi xuất phát', ...provinces]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedStartPlace = newValue!;
                  });
                },
              ),
            );
          }
        },
      ),
    ),
  ],
),

                  const SizedBox(height: 10),

                  // Label và Dropdown để chọn nơi đến
                  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text('Nơi đến:'),
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<String>>(
        future: _getProvinces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Không có dữ liệu');
          } else {
            final provinces = snapshot.data!.map((province) => cleanProvinceName(province)).toList(); // Loại bỏ "Tỉnh" và "Thành phố"
            return SizedBox(
              width: 300.0,
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: selectedDestination,
                items: ['Nơi đến', ...provinces]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedDestination = newValue!;
                  });
                },
              ),
            );
          }
        },
      ),
    ),
  ],
),

                  const SizedBox(height: 10),

                  // Chọn ngày đi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Chọn ngày:'),
                      SizedBox(
                        width: 300.0, // Giới hạn chiều rộng của ô chọn ngày
                        child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              selectedDate != null
                                  ? dateFormat.format(selectedDate!)
                                  : 'Chọn ngày',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Button tìm kiếm vé
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          showResults =
                              false; // Đảm bảo kết quả cũ sẽ bị xóa khi tìm kiếm lại
                        });

                        try {
                          // Thực hiện gọi API để lấy danh sách vé xe
                          final busSchedules = await fetchBusSchedules(
                            filter: selectedBus,
                            departureLocation: selectedStartPlace,
                            arrivalProvince: selectedDestination,
                            departureDate: selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                                : '',
                          );
                          logger.i('Dữ liệu trả về từ API: $busSchedules');
                          setState(() {
                            showResults = true; // Hiển thị kết quả tìm kiếm
                            results.clear(); // Xóa kết quả cũ
                            results.addAll(
                                busSchedules); // Thêm dữ liệu mới vào danh sách kết quả
                          });
                        } catch (error) {
                          // Xử lý khi gặp lỗi
                          logger.e('Lỗi: $error');
                        }
                      },
                      child: const Text('Tìm vé'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Hiển thị kết quả tìm kiếm
            showResults
    ? Column(
        children: results.map((result) {
          int index = results.indexOf(result);  // Lấy chỉ số của vé trong danh sách
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            elevation: 5,
            child: Column(
              children: [
                // Image at the top
                Image.network(
  result['busInfo']['imageRepresentative'] ?? '',
  width: double.infinity,
  height: 150,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    // Nếu không thể tải ảnh từ network, sử dụng ảnh từ assets
    return Image.asset(
      'assets/thue_xe/cx5.jpg', // Đảm bảo ảnh mặc định tồn tại trong thư mục assets
      width: double.infinity,
      height: 150,
      fit: BoxFit.cover,
    );
  },
),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business name
                      Text(
                        result['businessPartnerInfo']['name'] ?? 'Không có tên',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Bus type
                      Text(
                        '${result['busInfo']['busType']['name']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),

                      // Departure & Arrival with icons and time
                      Column(
  children: [
    // Departure Location và Time
    Row(
      children: [
        const Icon(Icons.location_on, size: 20),
        const SizedBox(width: 4),
        Text(
          '${result['departureTime']} ${result['busTripInfo']['departureLocation']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
    const SizedBox(height: 8),

    // Arrival Location và Time
    Row(
      children: [
        const Icon(Icons.location_on, size: 20),
        const SizedBox(width: 4),
        Text(
          '${result['arrivalTime']} ${result['busTripInfo']['arrivalLocation']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ],
),
const SizedBox(height: 8),


                      
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            '${result['priceTicket']}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Thông tin chi tiết
                Row(
                children: [
                  const Text(
                    'Chi tiết chuyến xe',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(
                      expandedStates[index] == true ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        expandedStates[index] = !(expandedStates[index] ?? false); // Chuyển trạng thái khi nhấn
                      });
                    },
                  ),
    
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                           Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderInformationPage(
                                      busTripScheduleId: result['busTripScheduleId'],
                                      departureDate: DateFormat('yyyy-MM-dd').format(selectedDate!), // Ngày khởi hành (thay bằng ngày thực tế nếu cần)
                                    arrivalProvince: result['busTripInfo']['arrivalLocation'],
                                    ),
                                  ),
                                );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                        ),
                        child: const Text('Đặt ngay', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Kiểm tra nếu isExpanded là true thì mới hiển thị các thông tin chi tiết
                  expandedStates[index] == true
                      ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiện ích
          FutureBuilder<List<Map<String, dynamic>>>( 
            future: fetchUtilities(result['busInfo']['busType']['id'].toString()), // Đảm bảo truyền Future đúng
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();  // Đang tải
              } else if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');  // Nếu có lỗi
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Không có dữ liệu tiện ích');  // Nếu không có dữ liệu
              } else {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showUtilityDetails(context, snapshot.data!); // Hiển thị chi tiết tiện ích
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Tiện ích'),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 8),

          // Chính sách
          FutureBuilder<List<String>>(
            future: fetchPolicies(result['businessPartnerInfo']['id'].toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Lỗi chính sách: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Không có dữ liệu chính sách');
              } else {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showPolicyDetails(context, snapshot.data!); // Hiển thị chi tiết chính sách
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Chính sách'),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 8),

          // Nút Đón/Trả
          FutureBuilder<Map<String, dynamic>>(
  future: fetchPickupDropOffLocations(
    result['busTripScheduleId'].toString(),
    result['busTripInfo']['arrivalLocation'].toString(),
  ),
  builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator(); // Hiển thị vòng tròn đang tải
    } else if (snapshot.hasError) {
      return Text('Lỗi: ${snapshot.error}'); // Hiển thị lỗi
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text('Không có dữ liệu điểm đón/trả'); // Không có dữ liệu
    } else {
      return ElevatedButton(
        onPressed: () {
          _showPickupDropOffDetails(context, snapshot.data!); // Gọi hàm hiển thị thông tin
        },
        style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
        child: const Text('Điểm đón/trả'),
      );
    }
  },
),
        ],
      )
                      : const SizedBox(), // Nếu chưa click thì không hiển thị gì
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )
                      : const SizedBox.shrink(),

                            ],
                          ),
                        ),
                      );
                    }
                  }
                  // Hàm hiển thị tiện ích chi tiết
void _showUtilityDetails(BuildContext context, List<Map<String, dynamic>> utilities) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Tiện ích'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: utilities
                .map((utility) => Text(utility['name'] ?? 'Không có tên tiện ích'))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Đóng cửa sổ thông tin
            },
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}

// Hàm hiển thị chính sách chi tiết
void _showPolicyDetails(BuildContext context, List<String> policies) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Chính sách'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: policies
                .map((policy) => Text('• $policy'))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Đóng cửa sổ thông tin
            },
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}
void _showPickupDropOffDetails(BuildContext context, Map<String, dynamic> pickupDropOffData) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Điểm đón/trả'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Điểm đón:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...pickupDropOffData['pickupLocations']
                  .map<Widget>((pickup) => Text('- $pickup')) // Hiển thị từng điểm đón
                  .toList(),
              const SizedBox(height: 16),
              const Text('Điểm trả:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...pickupDropOffData['dropOffLocations']
                  .map<Widget>((dropOff) => Text('- $dropOff')) // Hiển thị từng điểm trả
                  .toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng hộp thoại
            },
            child: const Text('Đóng'),
          ),
        ],
      );
    },
  );
}
