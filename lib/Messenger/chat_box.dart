import 'package:flutter/material.dart';
import 'chat_detail_page.dart'; // Nhớ import file chứa ChatDetailPage

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  ChatBoxState createState() => ChatBoxState();
}

class ChatBoxState extends State<ChatBox> {
  // Giảm số lượng tin nhắn xuống còn 1 để dễ dàng kiểm tra
  final List<String> _messages = [
    'Chào bạn....',
  ];

  final List<bool> _isRead = [
    false, // Tin nhắn 1 chưa đọc
  ];

  bool _showUnread = false;

  List<String> get filteredMessages {
    if (_showUnread) {
      return [
        for (int i = 0; i < _messages.length; i++) if (!_isRead[i]) _messages[i]
      ];
    }
    return _messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Tin nhắn',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Chức năng tìm kiếm
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh điều hướng "Tất cả" và "Chưa đọc"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showUnread = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !_showUnread ? const Color.fromARGB(255, 255, 230, 219) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Tất cả',
                        style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showUnread = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _showUnread ? const Color.fromARGB(255, 255, 230, 219) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Chưa đọc',
                        style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // Danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                final isUnread = _isRead[_messages.indexOf(message)] == false;

                return GestureDetector(
                  onTap: () {
                    // Điều hướng đến trang chat chi tiết
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailPage(
                          userName: 'Nguyễn Tiến Dũng', // Thay bằng tên người gửi tin nhắn
                          initialMessage: message, // Tin nhắn ban đầu
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/avatar/avt1.jpg'),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Nguyễn Tiến Dũng',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '25/11/2024',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            if (isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
