import 'package:flutter/material.dart';
import 'package:messenger_ui/elements/chat_widget.dart';

class ListChatshWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListChatsWidgetState();
  }
}

class _ListChatsWidgetState extends State<ListChatshWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          for (int i = 0; i < 20; i++) ...[
            ChatWidget(nickname: 'nickname'),
            const SizedBox(height: 2),
          ],
        ],
      ),
    );
  }
}
