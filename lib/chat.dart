import 'package:whatsapp/message.dart';

class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final List<Message> messages;

  Chat(this.name, this.lastMessage, this.time, {this.messages = const []});
}
