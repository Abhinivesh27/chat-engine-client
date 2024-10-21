# CHAT ENGINE CLIENT

Flutter client for ATmega's chat-engine

# Getting Started


[![License: MIT][license_badge]][license_link]
[![Powered by ATmega](https://atmega.in)]

An simple chat application built with dart_frog

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT

Here is a sample API documentation for your WebSocket service in markdown format:

### CHAT WebSocket Service API Documentation

This document describes the WebSocket service API that allows clients to communicate with the Dart backend via WebSockets. It utilizes a `ChatResponse` model to handle messages in a structured format. The service supports connecting, sending and receiving messages, changing rooms, and disconnecting.

## Connection Endpoint

### WebSocket URL
```plaintext
ws://localhost:8080/chat/<userId>/?room=<room>
```

- `userId`: Unique identifier of the user (required).
- `room`: Name of the chat room to join (optional, defaults to "default").

### Example WebSocket URL
```plaintext
ws://localhost:8080/chat/user123/?room=default
```

## Data Format

The messages exchanged between the client and the server must follow the `ChatResponse` format.

### ChatResponse Model

```dart
class ChatResponse {
  String id;
  String content;
  String sender;
  String receiver;
  DateTime time;
  String chatroom;

  // Includes toJson, fromJson, and fromRawJson functions
}
```

### Sample Message (JSON Format)
#### Outgoing Message (Sent to Server)
```json
{
  "id": "user123",
  "content": "Hello, World!",
  "sender": "user123",
  "receiver": "All",
  "time": "2024-10-21T12:34:56.789Z",
  "chatroom": "default"
}
```

#### Incoming Message (Received from Server)
```json
{
  "id": "server_generated_id",
  "content": "Welcome to the chat!",
  "sender": "System",
  "receiver": "user123",
  "time": "2024-10-21T12:34:56.789Z",
  "chatroom": "default"
}
```

## WebSocketService Class

### `connect(userId: String, {room: String})`

Initializes a WebSocket connection to the server.

- **Parameters**:
  - `userId` (required): The unique identifier for the user.
  - `room` (optional): The chat room to join, defaults to `default`.
  
- **Usage**:
  ```dart
  _webSocketService.connect('user123', room: 'default');
  ```

- **Example**:
  ```plaintext
  Connected to WebSocket as User user123 in Room default
  ```

### `sendMessage(content: String, {receiver: String, chatroom: String})`

Sends a message to the WebSocket server.

- **Parameters**:
  - `content`: The content of the message to send.
  - `receiver` (optional): The receiver of the message. If not specified, defaults to `All`.
  - `chatroom` (optional): The chat room to send the message to. If not specified, defaults to the current room.
  
- **Usage**:
  ```dart
  _webSocketService.sendMessage('Hello, everyone!');
  ```

- **Example**:
  ```plaintext
  Sent message: Hello, everyone!
  ```

### `changeRoom(newRoom: String)`

Changes the current chat room for the user.

- **Parameters**:
  - `newRoom`: The name of the new chat room to join.
  
- **Usage**:
  ```dart
  _webSocketService.changeRoom('newRoom');
  ```

- **Example**:
  ```plaintext
  Changing room to newRoom
  ```

### `disconnect()`

Disconnects the user from the WebSocket server.

- **Usage**:
  ```dart
  _webSocketService.disconnect();
  ```

- **Example**:
  ```plaintext
  WebSocket connection closed
  ```

## Stream

### `messageStream`

A broadcast stream that listens for incoming `ChatResponse` messages from the WebSocket server. You can subscribe to this stream to handle real-time messages.

- **Stream Type**: `Stream<ChatResponse>`

- **Usage**:
  ```dart
  _webSocketService.messageStream.listen((chatResponse) {
    print('Message from ${chatResponse.sender}: ${chatResponse.content}');
  });
  ```

- **Example**:
  ```plaintext
  Received message: {"id":"server_generated_id","content":"Welcome to the chat!","sender":"System","receiver":"user123","time":"2024-10-21T12:34:56.789Z","chatroom":"default"}
  ```

## Error Handling

The WebSocket service will print any errors that occur during communication with the server:
- **Example**:
  ```plaintext
  WebSocket Error: <error_description>
  ```

## Closing the WebSocket

The WebSocket connection is automatically closed when the client calls the `disconnect` method or when the server closes the connection.

### WebSocket Disconnection Example:
```plaintext
WebSocket connection closed
```

## Example Usage in Flutter Web:

### Connecting and Sending Messages:

```dart
void main() {
  final WebSocketService _webSocketService = WebSocketService();
  
  _webSocketService.connect('user123', room: 'default');

  _webSocketService.messageStream.listen((chatResponse) {
    print('Message from ${chatResponse.sender}: ${chatResponse.content}');
  });

  _webSocketService.sendMessage('Hello, world!');
}
```

### Disconnecting:

```dart
_webSocketService.disconnect();
```

---

This API allows real-time chat functionality using WebSockets, enabling users to send and receive messages in structured JSON format (`ChatResponse`).