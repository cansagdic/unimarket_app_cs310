import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _chatsRef => _firestore.collection('chats');
  CollectionReference get _messagesRef => _firestore.collection('messages');

  // Get or create a chat between two users
  Future<String> getOrCreateChat({
    required String userId1,
    required String userName1,
    required String userId2,
    required String userName2,
  }) async {
    // Check if chat already exists
    final query = await _chatsRef
        .where('participants', arrayContains: userId1)
        .get();
    
    for (var doc in query.docs) {
      final chat = Chat.fromFirestore(doc);
      if (chat.participants.contains(userId2)) {
        return doc.id; // Chat already exists
      }
    }
    
    // Create new chat
    final chatDoc = await _chatsRef.add({
      'participants': [userId1, userId2],
      'participantNames': {
        userId1: userName1,
        userId2: userName2,
      },
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
    
    return chatDoc.id;
  }

  Stream<List<Chat>> getUserChats(String userId) {
    return _chatsRef
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
    });
  }

  // Get messages for a chat
  Stream<List<Message>> getChatMessages(String chatId) {
    return _messagesRef
        .where('chatId', isEqualTo: chatId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    // Add message
    await _messagesRef.add({
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Update chat's last message
    await _chatsRef.doc(chatId).update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }
}
