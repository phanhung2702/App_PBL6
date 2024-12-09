import 'package:app_pbl6/models/notifications.dart' as custom_notifications;  // Alias the custom Notification class
import 'package:flutter/material.dart';
import 'package:app_pbl6/Messenger/notifications_detail_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  List<custom_notifications.CustomNotification> notifications = [  // Use the aliased class
    custom_notifications.CustomNotification(
      title: 'Cứ đi Safety Travel là có ưu đãi',
      detail: '''1/ Ưu đãi 33% tối đa 33.000đ

- Ưu đãi 33% (tối đa 33.000đ) cho các chuyến xe GrabExpress Siêu Tốc/GrabExpress Siêu Tốc COD/ GrabExpress Siêu Tốc Premium/ GrabExpress Siêu Tốc (Giao tận tay)/ GrabExpress Siêu Tốc (Thực Phẩm)/ GrabExpress (Thẻ/ví)/ GrabExpress Siêu Tốc (Siêu thị).
- Áp dụng tại thành phố Hồ Chí Minh và Hà Nội.
- Áp dụng cho mọi phương thức thanh toán.
- Ưu đãi không bao gồm phụ phí nền tảng, người dùng vui lòng thanh toán phần phụ phí (nếu có) với Đối tác tài xế.
- Chỉ áp dụng cho người dùng nhận được thông báo.
- Chỉ áp dụng với phiên bản app mới nhất.

2/ Đồng giá 1.000đ 

- Đồng giá 1.000đ cho các chuyến xe GrabExpress Siêu Tốc/GrabExpress Siêu Tốc COD/ GrabExpress Siêu Tốc Premium/ GrabExpress Siêu Tốc (Giao tận tay)/ GrabExpress Siêu Tốc (Thực Phẩm)/ GrabExpress (Thẻ/ví)/ GrabExpress Siêu Tốc (Siêu thị).
- Áp dụng cho các chuyến xe có cước phí dưới hoặc bằng 30.000đ.
- Với các chuyến xe có cước phí từ 31.000đ trở lên, ưu đãi tối đa 29.000đ.
- Áp dụng tại thành phố Hồ Chí Minh và Hà Nội.
- Áp dụng cho mọi phương thức thanh toán.
- Ưu đãi không bao gồm phụ phí nền tảng, người dùng vui lòng thanh toán phần phụ phí (nếu có) với Đối tác tài xế.
- Chỉ áp dụng cho người dùng nhận được thông báo.
- Chỉ áp dụng với phiên bản app mới nhất.

3/ Ưu đãi 33%

- Ưu đãi 33% cho các chuyến xe GrabExpress Siêu Tốc/GrabExpress Siêu Tốc COD/ GrabExpress Siêu Tốc Premium/ GrabExpress Siêu Tốc (Giao tận tay)/ GrabExpress Siêu Tốc (Thực Phẩm)/ GrabExpress (Thẻ/ví)/ GrabExpress Siêu Tốc (Siêu thị).
- Áp dụng tại thành phố Hồ Chí Minh và Hà Nội.
- Áp dụng cho mọi phương thức thanh toán.
- Ưu đãi không bao gồm phụ phí nền tảng, người dùng vui lòng thanh toán phần phụ phí (nếu có) với Đối tác tài xế.
- Chỉ áp dụng cho người dùng nhận được thông báo.
- Chỉ áp dụng với phiên bản app mới nhất.''',
    ),
    // Thêm các thông báo khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Báo'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications, color: Color.fromARGB(255, 214, 72, 32)),
            title: Text(notifications[index].title), // Hiển thị tiêu đề thông báo
            onTap: () {
              // Điều hướng đến trang chi tiết khi người dùng nhấn vào thông báo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDetailPage(
                    notification: notifications[index], // Truyền thông báo vào trang chi tiết
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
