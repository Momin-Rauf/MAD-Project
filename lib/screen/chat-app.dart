import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = []; // Stores the chat messages

  // This function simulates chatbot replies with football-related data
  void _sendMessage() {
    if (_controller.text.isEmpty) return;

    setState(() {
      // Add user message to the list
      _messages.add({'sender': 'user', 'message': _controller.text});

      // Simulate a bot response after a slight delay
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          String userQuery = _controller.text.toLowerCase();
          if (userQuery.contains('match') || userQuery.contains('score')) {
            _messages.add({
              'sender': 'bot',
              'message':
                  'Here are the match stats:\n\nTeam A: 2 - 1 Team B\n\nTop Scorer: Player A (1 goal)'
            });
          } else if (userQuery.contains('player stats') || userQuery.contains('player')) {
            _messages.add({
              'sender': 'bot',
              'message': 'Player A Stats: 3 Goals, 1 Assist, 2 Yellow Cards'
            });
          } else {
            _messages.add({
              'sender': 'bot',
              'message': 'How can I help you!'
            });
          }
        });
      });

      // Clear the text input
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football ChatBot'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isUser = message['sender'] == 'user';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message['message'] ?? '',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
