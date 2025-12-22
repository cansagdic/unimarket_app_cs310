import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'services/chat_service.dart';
import 'models/chat_model.dart';
import 'chat_screen.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUserId = authProvider.user?.uid ?? '';
    final chatService = ChatService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Messages'),
        centerTitle: true,
      ),
      body: currentUserId.isEmpty
          ? const Center(child: Text('Please log in to see messages'))
          : StreamBuilder<List<Chat>>(
              stream: chatService.getUserChats(currentUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final chats = snapshot.data ?? [];

                if (chats.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No messages yet'),
                        SizedBox(height: 8),
                        Text(
                          'Start a conversation by contacting a seller!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    
                    // Get the other participant's name
                    String otherUserId = chat.participants.firstWhere(
                      (id) => id != currentUserId,
                      orElse: () => '',
                    );
                    String otherUserName = chat.participantNames[otherUserId] ?? 'User';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 0.5,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(otherUserName.isNotEmpty ? otherUserName[0] : '?'),
                        ),
                        title: Text(otherUserName),
                        subtitle: Text(
                          chat.lastMessage.isEmpty ? 'Start chatting!' : chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          _formatTime(chat.lastMessageTime),
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                chatId: chat.id,
                                receiverName: otherUserName,
                                receiverId: otherUserId,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} hours';
    return '${diff.inDays} days';
  }
}
