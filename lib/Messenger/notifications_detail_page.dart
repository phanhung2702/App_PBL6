import 'package:flutter/material.dart';
import 'package:app_pbl6/models/notifications.dart' as custom_notifications;  // Import the custom Notification class

class NotificationDetailPage extends StatelessWidget {
  final custom_notifications.CustomNotification notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(notification.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(notification.detail),
      ),
    );
  }
}
