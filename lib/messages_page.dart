import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  // Wireframe'e uygun konuşma listesi
  List<Map<String, dynamic>> get _conversations => [
        {
          'name': 'Erdem Akay (Student)',
          'lastMessage': 'You: Hey. Is this still available',
          'time': '1 min',
          'unread': 0,
          'avatar': null,
          'messages': [
            {
              'text': 'Nov 8, 2025, 3:03 PM',
              'isDate': true,
            },
            {
              'text': 'What is the price of the sofa?',
              'isMe': true,
            },
            {
              'text': 'Would you consider 50 dollars?',
              'isMe': false,
            },
            {
              'text': 'Nov 30, 2025, 10:40 AM',
              'isDate': true,
            },
            {
              'text': 'Hey. Is this still available?',
              'isMe': true,
            },
          ],
        },
        {
          'name': 'Baran Utku Güler (Student)',
          'lastMessage': '*I also have a freezer if you ar...',
          'time': '10 min',
          'unread': 1, // sadece logic için, UI'da badge yok
          'avatar': null,
          'messages': [
            {
              'text': 'Nov 30, 2025, 11:31 AM',
              'isDate': true,
            },
            {
              // SENİN MESAJIN
              'text': 'I want to buy the sofa.',
              'isMe': true,
            },
            {
              'text': 'Great!',
              'isMe': false,
            },
            {
              'text': 'I also have a freezer if you are interested.',
              'isMe': false,
            },
          ],
        },
        {
          'name': 'Sude Nil Varli',
          'lastMessage': 'You: Great, that works for me!',
          'time': '2 hours',
          'unread': 1,
          'avatar': 'assets/images/sude_profile.png',
          'messages': [
            {
              'text': 'Nov 30, 2025, 9:41 AM',
              'isDate': true,
            },
            {
              'text': 'Hi! Is this chair still available?',
              'isMe': true,
            },
            {
              'text': 'Yes, it is!',
              'isMe': false,
            },
            {
              'text': 'You can pick it up near the IC if that works.',
              'isMe': false,
            },
            {
              'text': 'I will be available after 4 pm.',
              'isMe': false,
            },
            {
              'text': 'Great, that works for me!',
              'isMe': true,
            },
          ],
        },
      ];

  @override
  Widget build(BuildContext context) {
    final conversations = _conversations;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Messages'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final c = conversations[index];
          final name = c['name'] as String;
          final avatarPath = c['avatar'] as String?;

          // SADECE Baran için kalın
          final isBaran =
              name.startsWith('Baran Utku Güler'); // tek bold o olacak

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 0.5,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    avatarPath != null ? AssetImage(avatarPath) : null,
                child: avatarPath == null
                    ? Text(name.isNotEmpty ? name[0] : '?')
                    : null,
              ),
              title: Text(
                name,
                style: TextStyle(
                  fontWeight:
                      isBaran ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                c['lastMessage'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight:
                      isBaran ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Text(
                c['time'] as String,
                style: TextStyle(
                  fontWeight:
                      isBaran ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      userName: name,
                      avatarPath: avatarPath,
                      initialMessages:
                          (c['messages'] as List<Map<String, dynamic>>),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
