import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
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
  String? birthDay;
  String? gender;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final Logger _logger = Logger();
  
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
      birthDay = prefs.getString('birthDay');
      gender = prefs.getString('gender');
    });

    _nameController.text = name ?? '';
    _phoneController.text = phoneNumber ?? '';
    _genderController.text = gender ?? '';
    _birthDayController.text = birthDay ?? '';
  }

  Future<void> _saveAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    String? updatedAvatarUrl = prefs.getString('avatar') ?? avatarUrl;
    String? token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chưa có token xác thực!'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final uri = Uri.parse('http://10.0.2.2:8080/api/v1/accounts');
      final request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token';

      // 1. Add JSON data (account_info)
      request.fields['account_info'] = jsonEncode({
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
        'birthDay': _birthDayController.text,
        'gender': _genderController.text,
      });

      // 2. If avatarUrl is a URL, download the image first
      if (updatedAvatarUrl != null && updatedAvatarUrl.startsWith('http')) {
        var response = await http.get(Uri.parse(updatedAvatarUrl));
        if (response.statusCode == 200) {
          var bytes = response.bodyBytes;
          var file = await _saveImageToFileSystem(bytes);
          request.files.add(
            await http.MultipartFile.fromPath('fileAvatar', file.path),
          );
        } else {
          // Handle error downloading image
          throw Exception("Failed to download image");
        }
      } else if (updatedAvatarUrl != null && updatedAvatarUrl.isNotEmpty) {
        var avatarFile = File(updatedAvatarUrl);
        request.files.add(
            await http.MultipartFile.fromPath('fileAvatar', avatarFile.path));
      }

      // 3. Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật tài khoản thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${response.statusCode}, $responseBody'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<File> _saveImageToFileSystem(List<int> bytes) async {
    final directory = await Directory.systemTemp.createTemp();
    final file = File('${directory.path}/avatar.jpg');
    await file.writeAsBytes(bytes);
    return file;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật ảnh đại diện thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
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
            _buildInfoTile("Số điện thoại", phoneNumber,
                controller: _phoneController),
            const SizedBox(height: 10),
            // Ngày sinh
            _buildInfoTile('Ngày sinh', birthDay,
                controller: _birthDayController),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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

  Widget _buildInfoTile(String label, String? value,
      {bool editable = true, TextEditingController? controller}) {
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
                width: double.infinity,
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
