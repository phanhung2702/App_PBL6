import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Kiểm tra nếu không có thay đổi gì
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Định dạng ngày tháng kiểu dd/mm/yyyy
    String newText = newValue.text.replaceAll('/', '');

    // Thêm dấu gạch chéo vào vị trí hợp lý
    if (newText.length >= 2 && newText.length <= 4) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2)}';
    } else if (newText.length > 4) {
      newText = '${newText.substring(0, 2)}/${newText.substring(2, 4)}/${newText.substring(4, 8)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
