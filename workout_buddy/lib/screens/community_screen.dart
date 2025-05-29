// lib/screens/community_screen.dart
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late io.Socket socket;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _connectToChatServer();
  }

  void _connectToChatServer() {
    socket = io.io('http://your-nodejs-server:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.on('message', (data) {
      setState(() => _messages.add(ChatMessage.fromJson(data)));
    });
  }
}
