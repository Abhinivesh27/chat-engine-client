import 'package:chat_tester/code/model.dart';
import 'package:flutter/material.dart';
import 'code/service.dart'; // Import your WebSocket service

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final WebSocketService _webSocketService = WebSocketService();
  final TextEditingController _messageController = TextEditingController();
  final List<ChatResponse> _messages = [];

  @override
  void initState() {
    super.initState();

    // Connect to the WebSocket when the page is initialized
    _webSocketService.connect('user123'); // Use the actual userId

    // Listen to the WebSocket messages stream
    _webSocketService.messageStream.listen((message) {
      setState(() {
        _messages.add(message); // Add new message to the chat
      });
    });
  }

  @override
  void dispose() {
    _webSocketService.disconnect(); // Disconnect from WebSocket when page is disposed
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      _webSocketService.sendMessage(message, receiver: '1');
      _messageController.clear(); // Clear input field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index].content),
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
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
