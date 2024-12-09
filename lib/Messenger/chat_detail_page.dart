import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;
  final String initialMessage;
  const ChatDetailPage({super.key, required this.userName, required this.initialMessage});

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add({'sender': 'partner', 'message': widget.initialMessage, 'time': '30/08/2024, 8:00 AM'}); // Đối tác gửi tin nhắn ban đầu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.userName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['sender'] == 'me';  // Kiểm tra xem tin nhắn có phải của người dùng không

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Align(
                    // Nếu là tin nhắn của người dùng, căn phải, nếu là của đối tác, căn trái
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        // Avatar tin nhắn
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(isMe ? 'assets/avatar/avt2.jpg' : 'assets/avatar/avt1.jpg'),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        // Tin nhắn
                        Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.deepOrange : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                message['message']!,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message['time']!,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Viết tin nhắn...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    setState(() {
                      if (_controller.text.isNotEmpty) {
                        _messages.add({
                          'sender': 'me',
                          'message': _controller.text,
                          'time': '30/08/2024, 8:10 AM',
                        });
                        _controller.clear();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
