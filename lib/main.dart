import 'package:app_pbl6/Tabs/BookVehicle/book_vehicle.dart';
import 'package:app_pbl6/Tabs/RentVehicle/rent_vehicle.dart';
import 'package:app_pbl6/Tabs/Partners/partners.dart';
import 'package:app_pbl6/splash_screen.dart';
import 'package:app_pbl6/Screen/app_bar_widget.dart';
import 'package:app_pbl6/Screen/booking_widget.dart';
import 'package:app_pbl6/Screen/car_rental_widget.dart';
import 'package:app_pbl6/Screen/describe_app.dart';
import 'package:app_pbl6/Screen/highlight_numbers_widget.dart';
import 'package:app_pbl6/Screen/partners_widget.dart';
import 'package:app_pbl6/Screen/popular_routes_widget.dart';
import 'package:app_pbl6/Screen/reason_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_pbl6/Screen/sale_widget.dart';
import 'package:app_pbl6/Screen/customer_reviews_widget.dart';
import 'package:app_pbl6/Tabs/BuyTicket/buy_ticket.dart';

void main() {
  runApp(SafetyTravelApp());
}

class SafetyTravelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safety Travel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreen(), 
      
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final PageController _pageControllerRoutes = PageController();
  final PageController _pageControllerCarRental = PageController();
  final PageController _pageControllerBooking = PageController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {});
    });
  }

  // Hàm chuyển đổi giữa các trang của BottomNavigationBar
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mảng lưu các màn hình khi nhấn vào từng nút
    final List<Widget> screens = [
      buildHomePage(),
      BuyTicketPage(),
      RentVehiclePage(),
      BookVehiclePage(),
      PartnersPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(),

      body: screens[_currentIndex], // Hiển thị nội dung theo tab hiện tại
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Chỉ mục của tab hiện tại
        onTap: _onTabTapped, // Hàm thay đổi tab
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 214, 72, 32), // Màu sắc khi tab được chọn
        unselectedItemColor: Colors.grey, // Màu sắc khi tab không được chọn
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Mua vé',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Thuê xe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Đặt xe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Làm đối tác',
          ),
        ],
      ),
    );
  }

  // Hàm xây dựng trang chủ
  Widget buildHomePage() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildDescribeApp(_pageController, images),
            const SizedBox(height: 20),
            // Phần Con số nổi bật
            HighlightNumbersWidget(),
            const SizedBox(height: 20),
            // Phần Các tuyến đường phổ biến
            PopularRoutesWidget(
                popularRoutes: popularRoutes,
                pageControllerRoutes: _pageControllerRoutes,
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                }),
            const SizedBox(height: 20),
            //Phần Thuê xe tự lái hoặc có tài xế
            CarRentalWidget(
              carRentalOptions: carRentalOptions,
              pageControllerCarRental: _pageControllerCarRental,
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            const SizedBox(height: 20),
            // Phần mục đặt xe
            BookingWidget(
              bookingOptions: bookingOptions,
              pageControllerBooking: _pageControllerBooking,
              onBookingTap: () {
                setState(() {
                  _currentIndex = 3; // Chuyển đến tab "Đặt xe" (chỉ mục 3)
                });
              },
            ),
            const SizedBox(height: 20),
            // ĐỐI TÁC CỦA SAFELY TRAVEL
            PartnersWidget(
              partners: partners,
              onPartnerTap: () {
                setState(() {
                  _currentIndex = 4; // Chuyển đến tab "Làm đối tác" (chỉ mục 4)
                });
              },
            ),
            const SizedBox(height: 20),
            // Phần Khuyến mãi
            SaleWidget(),
            const SizedBox(height: 50),
            // Phần đánh giá
            const CustomerReviewsWidget(),
            const SizedBox(height: 50),
            // Phần Tại sao nên lựa chọn Safety Travel
            const ReasonWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}     
