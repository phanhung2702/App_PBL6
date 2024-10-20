import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_pbl6/models/user_model.dart'; // Import model User

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<User?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/flutter_api/login.php'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var userData = json.decode(response.body);
      if (userData['success']) {
        return User.fromJson(userData['user']); // Trả về đối tượng User nếu đăng nhập thành công
      } else {
        // Xử lý khi đăng nhập không thành công
        return null;
      }
    } else {
      // Xử lý lỗi
      return null;
    }
  }
}