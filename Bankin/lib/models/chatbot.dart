class ChatBotResponse {
  final String message;

  const ChatBotResponse({this.message});

  factory ChatBotResponse.fromJson(Map<String, dynamic> parsedJson) {
    return ChatBotResponse(
      message: parsedJson['message'] as String,
    );
  }
}
