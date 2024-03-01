import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math';
import 'message.dart';
import 'package:whatsapp/chat.dart';
import 'package:whatsapp/chatscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Chat> chats = [];
  final ScrollController _scrollController = ScrollController();
  List<String> names = [
    for (var i = 1; i <= 20; i++) "Person $i",
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _generateMockChats();
  }

  void _generateMockChats() {
    chats.clear();
    for (var name in names) {
      chats.add(Chat(
        name,
        _generateMockText(),
        _generateMockTime(),
        messages: _generateMockMessages(name),
      ));
    }
  }

  String _generateMockText() {
    List<String> mockTexts = [
      "Hello!",
      "How are you?",
      "What's up?",
      "I'm good, thanks!",
      "See you later!",
    ];

    // Select a random message from the list
    final random = Random();

    // Select a random index from the list length
    final int randomIndex = random.nextInt(mockTexts.length);

    // Return the chosen message at the random index
    return mockTexts[randomIndex];
  }

  String _generateMockTime() {
    // Create a random time within the last 24 hours
    final random = Random();
    final now = DateTime.now();
    final randomMinutes = Random().nextInt(60);
    final randomHours = random.nextInt(24); // Up to 24 hours

    // Subtract random hours and minutes from current time
    final mockTime =
        now.subtract(Duration(hours: randomHours, minutes: randomMinutes));

    // Format the time as HH:MM
    return mockTime
        .toString()
        .substring(11, 16); // Extract HH:MM from formatted DateTime string
    // ... same as before
  }

  List<Message> _generateMockMessages(String name) {
    final List<Message> messages = [];
    for (int i = 0; i < 10; i++) {
      messages.add(Message(i % 2 == 0, 'This is message $i from $name'));
    }
    return messages;
  }

  void _openChatScreen(Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(chat: chat)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("121B22"),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: HexColor("1F2C34"),
              title: Text('WhatsApp'),
              actions: [
                IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
              floating: true,
              pinned: false,
              snap: false,
            ),
          ];
        },
        body: Column(
          children: [
            BottomNavigationBar(
              backgroundColor: HexColor("1F2C34"),
              items: const [
                BottomNavigationBarItem(
                  icon: Text(''),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Text(''),
                  label: 'Updates',
                ),
                BottomNavigationBarItem(
                  icon: Text(''),
                  label: 'Calls',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: HexColor("128c7e"),
              onTap: _onItemTapped,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ListTile(
                    leading: CircleAvatar(
                        // ... set image based on data (optional)
                        ),
                    title: Text(chat.name),
                    subtitle: Text(chat.lastMessage),
                    trailing: Text(chat.time),
                    onTap: () => _openChatScreen(chat),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("128c7e"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Icon(Icons.chat),
        onPressed: () {},
      ),
    );
  }
}
