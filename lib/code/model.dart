import 'dart:convert';

class ChatResponse {
    String? id;
    String content;
    String sender;
    String receiver;
    DateTime time;
    String chatroom;

    ChatResponse({
         this.id,
        required this.content,
        required this.sender,
        required this.receiver,
        required this.time,
        required this.chatroom,
    });

    factory ChatResponse.fromRawJson(String str) => ChatResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        id: json["id"] ?? null,
        content: json["content"],
        sender: json["sender"],
        receiver: json["receiver"],
        time: DateTime.parse(json["time"]),
        chatroom: json["chatroom"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "sender": sender,
        "receiver": receiver,
        "time": time.toIso8601String(),
        "chatroom": chatroom,
    };
}
