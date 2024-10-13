// models/review.dart
class Review {
  final String customerName;
  final String content;
  final int rating; // Điểm đánh giá từ 1 đến 5

  Review({required this.customerName, required this.content, required this.rating});
}
