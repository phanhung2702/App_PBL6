import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
class AuthService {
  final Logger logger = Logger(); // Tạo logger
  // Hàm gọi API refresh token
  Future<bool> refreshAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken'); // Lấy refresh token từ SharedPreferences

      if (refreshToken == null) {
        logger.e(" Không tìm thấy refresh token");
        return false; // Không có refresh token
      }

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/v1/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Lưu access token mới
        await prefs.setString('token', responseData['accessToken']);
        logger.i("Làm mới token thành công!");
        return true;
      } else {
        logger.w("Làm mới token thất bại: ${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("Lỗi khi gọi API refresh token: $e");
      return false;
    }
  }
}
