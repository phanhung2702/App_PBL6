import 'package:flutter/material.dart';

class SelfDrivePage extends StatefulWidget {
  @override
  SelfDrivePageState createState() => SelfDrivePageState();
}

class SelfDrivePageState extends State<SelfDrivePage> {
  final ScrollController _scrollController = ScrollController();
  double scrollAmount = 100; // Số pixel để cuộn mỗi lần

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Drive'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16.0), // Thêm margin bên trái
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        constraints: const BoxConstraints(
          maxWidth: 300,
          maxHeight: 30,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController, // Gán ScrollController
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCategoryButton('Tất cả'),
                    _buildCategoryButton('Khu vực xe'),
                    _buildCategoryButton('Hãng xe'),
                    _buildCategoryButton('Loại xe'),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 12), // Icon mũi tên
              onPressed: () {
                // Cuộn đến danh sách tiếp theo
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
    );
  }

  Widget _buildCategoryButton(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          // Hành động khi nhấn nút
        },
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
