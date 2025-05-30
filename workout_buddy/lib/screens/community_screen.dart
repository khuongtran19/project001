import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// Define the ChatMessage class
class ChatMessage {
  final String text;
  final String sender;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.sender, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late io.Socket socket;
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectToChatServer();
  }

  void _connectToChatServer() {
    socket = io.io('http://your-nodejs-server:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Connected to chat server');
    });

    socket.on('message', (data) {
      setState(() {
        _messages.add(ChatMessage(text: data['text'], sender: data['sender']));
      });
    });

    socket.on('error', (error) => print('Socket error: $error'));
    socket.on('disconnect', (_) => print('Disconnected from chat server'));
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      socket.emit('message', {
        'text': message,
        'sender': 'You', // Replace with actual username
      });

      setState(() {
        _messages.add(ChatMessage(text: message, sender: 'You'));
      });

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Chat')),
      body: Column(
        children: [
          // Chat messages display
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages.reversed.toList()[index];
                return ChatBubble(
                  message: message.text,
                  isMe: message.sender == 'You',
                  sender: message.sender,
                );
              },
            ),
          ),

          // Message input area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Chat bubble widget for better UI
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String sender;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                sender,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            Text(message),
          ],
        ),
      ),
    );
  }
}
