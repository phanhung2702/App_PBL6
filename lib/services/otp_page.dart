import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_pbl6/Register/register_info_page.dart';

class OtpPage extends StatefulWidget {
  final String email; // Nhận email từ trang trước

  const OtpPage({required this.email});

  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  String otp = "";
  Timer? _timer;
  int _remainingTime = 60; // Thời gian đếm ngược 60 giây

  @override
  void initState() {
    super.initState();
    _startCountdown(); // Bắt đầu đếm ngược
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy bộ đếm khi thoát khỏi trang
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> verifyOtp(String email, String otp) async {
    final url = Uri.parse("http://10.0.2.2:8080/api/v1/auth/verify");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Xác minh OTP thành công")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterInfoPage(email: widget.email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? "Xác minh OTP thất bại")),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi kết nối: $error")),
        );
      }
    }
  }

  Future<void> resendOtp(String email) async {
    final url = Uri.parse("http://10.0.2.2:8080/api/v1/auth/resend_otp?email=$email");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      final responseData = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "OTP đã được gửi lại")),
        );
        setState(() {
          _remainingTime = 60; // Đặt lại thời gian đếm ngược
          _startCountdown(); // Bắt đầu lại đếm ngược
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['error'] ?? "Không thể gửi lại OTP")),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi kết nối: $error")),
        );
      }
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
    setState(() {
      otp = _controllers.map((controller) => controller.text).join('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhập mã OTP"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Nhập mã OTP 6 chữ số",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "OTP hết hạn sau: $_remainingTime giây",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "0",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _onOtpChanged(index, value);
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (otp.length == 6) {
                    verifyOtp(widget.email, otp);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vui lòng nhập đủ 6 chữ số OTP")),
                    );
                  }
                },
                child: const Text("Xác nhận OTP"),
              ),
              const SizedBox(height: 20),
              if (_remainingTime == 0)
                TextButton(
                  onPressed: () {
                    resendOtp(widget.email);
                  },
                  child: const Text("Gửi lại OTP"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
