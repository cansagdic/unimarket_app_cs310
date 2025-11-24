import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  // GÜNCEL PARAMETRELER
  final String receiverName;
  final String receiverId;
  final String? avatarPath;
  final List<Map<String, dynamic>> initialMessages;

  const ChatScreen({
    super.key,
    required this.receiverName,
    required this.receiverId,
    this.avatarPath,
    required this.initialMessages,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<_ChatItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.initialMessages
        .map(
          (m) => _ChatItem(
            text: m['text'] as String,
            isMe: (m['isMe'] as bool?) ?? false,
            isDate: (m['isDate'] as bool?) ?? false,
          ),
        )
        .toList();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _items.add(
        _ChatItem(
          text: text,
          isMe: true,
          isDate: false,
        ),
      );
    });

    _controller.clear();
  }

  // Son gelen karşı taraf mesajının index'ini bul
  int? _lastIncomingIndex() {
    for (int i = _items.length - 1; i >= 0; i--) {
      if (!_items[i].isDate && !_items[i].isMe) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastIncoming = _lastIncomingIndex();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.avatarPath != null
                  ? AssetImage(widget.avatarPath!)
                  : null,
              child: widget.avatarPath == null
                  ? Text(
                      // receiverName kullanıldı
                      widget.receiverName.isNotEmpty
                          ? widget.receiverName[0]
                          : '?',
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // receiverName kullanıldı
                  widget.receiverName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Active',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];

                if (item.isDate) {
                  // Ortadaki tarih/saat yazısı
                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        item.text,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                final isMe = item.isMe;

                // Benim mesajlarım (sağ tarafta, siyah)
                if (isMe) {
                  final bgColor = Colors.black87;
                  final textColor = Colors.white;

                  final radius = BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: const Radius.circular(16),
                    bottomRight: const Radius.circular(0),
                  );

                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: radius,
                      ),
                      child: Text(
                        item.text,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  );
                }

                // Karşı taraf mesajları (solda)
                final bgColor = Colors.grey.shade300;
                final textColor = Colors.black87;

                final radius = BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: const Radius.circular(0),
                  bottomRight: const Radius.circular(16),
                );

                // Sadece son gelen mesajda avatar göster
                final bool showAvatar = lastIncoming == index;

                Widget avatarWidget;
                if (!showAvatar) {
                  avatarWidget = const SizedBox(width: 24);
                } else {
                  if (widget.avatarPath != null) {
                    avatarWidget = CircleAvatar(
                      radius: 12,
                      backgroundImage:
                          AssetImage(widget.avatarPath!),
                    );
                  } else {
                    avatarWidget = CircleAvatar(
                      radius: 12,
                      child: Text(
                        // receiverName kullanıldı
                        widget.receiverName.isNotEmpty
                            ? widget.receiverName[0]
                            : '?',
                      ),
                    );
                  }
                }

                return Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 6.0, top: 8),
                        child: avatarWidget,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: radius,
                        ),
                        child: Text(
                          item.text,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onSubmitted: (_) => _sendMessage(),
                              decoration: const InputDecoration(
                                hintText: 'Message...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.mic_none,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.emoji_emotions_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.image_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: _sendMessage,
                            icon: const Icon(
                              Icons.send,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatItem {
  final String text;
  final bool isMe;
  final bool isDate;

  _ChatItem({
    required this.text,
    this.isMe = false,
    this.isDate = false,
  });
}