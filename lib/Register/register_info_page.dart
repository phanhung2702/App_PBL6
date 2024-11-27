import 'dart:async';
import 'package:app_pbl6/Login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:logger/logger.dart';


class RegisterInfoPage extends StatefulWidget {
  final String email;
  const RegisterInfoPage({super.key, required this.email});


  @override
  RegisterInfoPageState createState() => RegisterInfoPageState();
}

class RegisterInfoPageState extends State<RegisterInfoPage> {
  late TextEditingController _emailController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String _gender = 'MALE'; // Default gender
  DateTime? _birthday;
  final Logger _logger = Logger();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Gán giá trị email từ OtpPage vào controller
    _emailController = TextEditingController(text: widget.email);
  }

  // Hàm gửi dữ liệu lên server
  Future<void> sendFormData(
    String email,
    String fullName,
    String phoneNumber,
    DateTime birthday,
    String gender,
  ) async {
    try {
      _logger.i('Sending form data...');

      // Định dạng ngày sinh
      String formattedDate = DateFormat('dd-MM-yyyy').format(birthday);

      // Tạo dữ liệu accountInfo
      Map<String, dynamic> accountInfo = {
        'username': email,
        'name': fullName,
        'phoneNumber': phoneNumber,
        'birthDay': formattedDate,
        'gender': gender,
      };

      _logger.i('Form data: $accountInfo');

      // Chuyển accountInfo thành chuỗi JSON
      String jsonAccountInfo = jsonEncode(accountInfo);

      // Tạo FormData và gửi accountInfo dưới dạng chuỗi JSON
      FormData formData = FormData.fromMap({
        'account_info': MultipartFile.fromString(
          jsonAccountInfo,
          contentType: MediaType('application', 'json'), // Đặt rõ Content-Type
        ),
      });

      _logger.i('FormData fields: ${formData.fields}');

      // Tạo đối tượng Dio để gửi yêu cầu
      Dio dio = Dio();
      dio.options.headers = {
        'Content-Type': 'multipart/form-data', // Content-Type của form-data
      };

      // Gửi yêu cầu POST
      Response response = await dio.post(
        "http://10.0.2.2:8080/api/v1/auth/register-info",
        data: formData,
      );

      if (response.statusCode == 200) {
        _logger.i('Request successful: ${response.data}');
        // Điều hướng sang trang đăng nhập khi đăng kí thông tin thành công
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        _logger.w('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        _logger.e('Dio error: ${e.response?.data ?? e.message}');
      } else {
        _logger.e('Unexpected error: $e');
      }
    }
  }

  // Hàm submit form khi người dùng nhấn nút gửi
  Future<void> _submitForm() async {
    if (isSubmitting) return; // Nếu đang gửi thì không làm gì nữa
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _birthday == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    setState(() {
      isSubmitting = true; // Đánh dấu là đang gửi dữ liệu
    });

    try {
      await sendFormData(
        _emailController.text,
        _nameController.text,
        _phoneController.text,
        _birthday!,
        _gender,
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      _logger.e("Lỗi khi gửi form: $e");
    } finally {
      setState(() {
        isSubmitting = false; // Reset cờ sau khi gửi xong
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg/bg2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Nội dung chính
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.85,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông Tin Cá Nhân',
                        style: TextStyle(
                          fontSize: 30,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 214, 72, 32),
                                Color.fromARGB(255, 65, 40, 3)
                              ],
                              tileMode: TileMode.clamp,
                            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Trường nhập liệu email
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email,
                              color: Color.fromARGB(255, 214, 72, 32)),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        enabled: false, // Không cho chỉnh sửa email
                      ),
                      const SizedBox(height: 20),
                      // Trường nhập họ và tên
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Họ và tên',
                          prefixIcon: const Icon(Icons.person,
                              color: Color.fromARGB(255, 214, 72, 32)),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Trường nhập số điện thoại
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Số điện thoại',
                          prefixIcon: const Icon(Icons.phone,
                              color: Color.fromARGB(255, 214, 72, 32)),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      // Chọn ngày sinh
                      TextButton.icon(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _birthday = pickedDate;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 214, 72, 32),
                        ),
                        label: Text(
                          _birthday == null
                              ? 'Chọn ngày sinh'
                              : 'Ngày sinh: ${DateFormat('dd-MM-yyyy').format(_birthday!)}',
                          style: const TextStyle(
                              color: Color.fromARGB(255, 214, 72, 32)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Chọn giới tính
                      DropdownButtonFormField<String>(
                        value: _gender,
                        items: const [
                          DropdownMenuItem(
                              value: 'MALE', child: Text('Nam')),
                          DropdownMenuItem(
                              value: 'FEMALE', child: Text('Nữ')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Giới tính',
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Color.fromARGB(255, 214, 72, 32),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Nút gửi thông tin
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 214, 72, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                          ),
                          child: const Text(
                            'Gửi thông tin',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}