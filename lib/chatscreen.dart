import 'package:flutter/material.dart';
import 'package:whatsapp/chat.dart';
import 'message.dart';
import 'package:hexcolor/hexcolor.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final threshold = 100.0;
    if (_scrollController.offset >= threshold && _isAppBarVisible) {
      setState(() => _isAppBarVisible = false);
    } else if (_scrollController.offset < threshold && !_isAppBarVisible) {
      setState(() => _isAppBarVisible = true);
    }
  }

  final TextEditingController _textController = TextEditingController();
  bool _isSending = false; // Flag for sending state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: HexColor("1F2C34"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ), // Trigger back navigation
          title: Text(widget.chat.name),
          actions: [
            IconButton(
              icon: Icon(Icons.video_camera_back),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ]),
      body: Stack(children: [
        Image.asset(
          'assets/background.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.chat.messages.length,
                  itemBuilder: (context, index) {
                    final message = widget.chat.messages[index];
                    return ChatMessageBubble(
                      message: message,
                      isSent: message.isSent,
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: HexColor("1F2C34"),
                  borderRadius:
                      BorderRadius.circular(22.0), // Set corner radius
                ),
                child: Positioned(
                  child: _buildChatInput(),
                  bottom: 10.0,
                  right: 10.0,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildChatInput() {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Icon(Icons.emoji_emotions),
        Expanded(
          child: TextField(
            controller: _textController,
            enabled: !_isSending,
            decoration: InputDecoration(
              hintText: "  Message",
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final bool isSent;

  const ChatMessageBubble(
      {Key? key, required this.message, required this.isSent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSent
        ? Color.fromRGBO(18, 140, 126, 1.000)
        : Color.fromRGBO(31, 44, 52, 1.000);
    double borderRadius = isSent ? 15.0 : 5.0;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSent)
            CircleAvatar(
              radius: 15.0,
            ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: Text(message.message),
          ),
        ],
      ),
    );
  }
}
