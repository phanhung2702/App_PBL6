import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManagementPage extends StatefulWidget {
  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  String? avatarUrl;
  String? email;
  String? name;
  String? phoneNumber;
  String? gender;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      avatarUrl = prefs.getString('avatar');
      email = prefs.getString('email');
      name = prefs.getString('name');
      phoneNumber = prefs.getString('phoneNumber');
      gender = prefs.getString('gender');
    });

    _nameController.text = name ?? '';
    _phoneController.text = phoneNumber ?? '';
    _genderController.text = gender ?? '';
  }

  Future<void> _saveAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    String? updatedAvatarUrl = prefs.getString('avatar') ?? avatarUrl;

    // Gửi thông tin tài khoản và avatar qua API
    try {
      final uri = Uri.parse('http://10.0.2.2:8080/api/v1/accounts');
      final request = http.MultipartRequest('PUT', uri)
        ..fields['email'] = email ?? ''
        ..fields['name'] = _nameController.text
        ..fields['phoneNumber'] = _phoneController.text
        ..fields['gender'] = _genderController.text;

      // Nếu có avatar, gửi file hình ảnh
      if (updatedAvatarUrl != null && updatedAvatarUrl.isNotEmpty) {
        var avatarFile = File(updatedAvatarUrl);
        request.files.add(await http.MultipartFile.fromPath('fileAvatar', avatarFile.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Có lỗi xảy ra: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        avatarUrl = pickedFile.path; // Lưu đường dẫn ảnh local tạm thời
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar', pickedFile.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật ảnh đại diện thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý tài khoản"),
        backgroundColor: const Color.fromARGB(255, 214, 72, 32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar với nút Upload
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                      ? FileImage(File(avatarUrl!)) // Hiển thị ảnh từ local
                      : null,
                ),
                Positioned(
                  bottom: -5,
                  child: ElevatedButton(
                    onPressed: _uploadAvatar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Upload", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Email (không chỉnh sửa)
            _buildInfoTile("Email", email, editable: false),
            const SizedBox(height: 10),
            // Họ và Tên
            _buildInfoTile("Họ và Tên", name, controller: _nameController),
            const SizedBox(height: 10),
            // Số điện thoại
            _buildInfoTile("Số điện thoại", phoneNumber, controller: _phoneController),
            const SizedBox(height: 10),
            // Giới tính
            _buildInfoTile("Giới tính", gender, controller: _genderController),
            const SizedBox(height: 30),
            // Nút lưu
            ElevatedButton(
              onPressed: _saveAccountData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 214, 72, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                'Lưu thay đổi',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value, {bool editable = true, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        editable
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(value ?? "Chưa cập nhật"),
              ),
      ],
    );
  }
}
