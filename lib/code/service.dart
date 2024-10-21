import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart'; // Use web_socket_channel plugin
import 'model.dart'; // Import your ChatResponse model

class WebSocketService {
  WebSocketChannel? _channel;
  String? _userId;
  String _room = 'default';
  final StreamController<ChatResponse> _messageController = StreamController<ChatResponse>.broadcast();

  // Stream for incoming ChatResponse objects
  Stream<ChatResponse> get messageStream => _messageController.stream;

  // Initialize the WebSocket connection using web_socket_channel
  void connect(String userId, {String room = 'default'}) {
    _userId = userId;
    _room = room;

    final url = 'ws://localhost:8080/chat/$userId/?room=$room';
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Set up WebSocket listeners
    _channel?.stream.listen(
      (data) {
        print('Received message: $data');
        if (data is String) {
          try {
            // Parse the message into a ChatResponse object using fromRawJson
            final response = ChatResponse.fromRawJson(data);
            _messageController.add(response); // Add the ChatResponse to the stream
          } catch (e) {
            print('Error parsing message: $e');
          }
        }
      },
      onError: (error) {
        print('WebSocket Error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
        _messageController.close(); // Close the message stream on disconnect
      },
    );
  }

  // Send a message to the WebSocket server
  void sendMessage(String content, {String? receiver, String? chatroom}) {
    if (_channel != null) {
      final message = ChatResponse(
        content: content,
        sender: _userId ?? '',
        receiver: receiver ?? 'All',
        time: DateTime.now(),
        chatroom: chatroom ?? _room,
      );

      // Send the message as JSON to the WebSocket server
      _channel?.sink.add(jsonEncode(message.toJson()));
      print('Sent message: $content');
    } else {
      print('WebSocket is not connected');
    }
  }

  // Change chat room
  void changeRoom(String newRoom) {
    if (_channel != null) {
      sendMessage('/join $newRoom');
      _room = newRoom;
      print('Changing room to $newRoom');
    }
  }

  // Disconnect the WebSocket connection
  void disconnect() {
    _channel?.sink.close();
  }
}
