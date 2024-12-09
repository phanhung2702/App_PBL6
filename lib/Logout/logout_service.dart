
import 'package:app_pbl6/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class LogoutService {
  final AuthService authService = AuthService();
  final Logger logger = Logger(); // Tạo logger
  Future<bool> callLogoutApi(String token) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/v1/auth/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        logger.i("Đăng xuất thành công");
        return true;
      } else if (response.statusCode == 401) {
        // Token hết hạn, thử làm mới token
        logger.w("Token hết hạn, thử làm mới...");
        final isRefreshed = await authService.refreshAccessToken();

        if (isRefreshed) {
          final prefs = await SharedPreferences.getInstance();
          final newToken = prefs.getString('token'); // Lấy token mới
          return await callLogoutApi(newToken!); // Gọi lại API logout
        } else {
          logger.w("Không thể làm mới token");
          return false; // Thất bại khi làm mới token
        }
      } else {
        logger.w("Gọi API logout thất bại: ${response.body}");
        return false;
      }
    } catch (e) {
      logger.e("Lỗi khi gọi API logout: $e");
      return false;
    }
  }
}
