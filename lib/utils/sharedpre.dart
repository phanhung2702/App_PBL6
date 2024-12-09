import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final logger = Logger(); // Khởi tạo Logger

Future<void> checkSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Lấy tất cả các khóa và giá trị
  final allKeys = prefs.getKeys();
  
  if (allKeys.isEmpty) {
    logger.i('SharedPreferences đang trống.');
  } else {
    // In ra tất cả các khóa và giá trị
    for (var key in allKeys) {
      final value = prefs.get(key);
      logger.i('$key: $value'); // Ghi log thông tin về khóa và giá trị
    }
  }
}
