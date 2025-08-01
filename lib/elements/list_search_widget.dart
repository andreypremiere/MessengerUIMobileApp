import 'package:flutter/material.dart';
import 'package:messenger_ui/elements/chat_widget.dart';
import 'package:messenger_ui/elements/finded_user_widget.dart';

class ListSearchWidget extends StatefulWidget {
  final findedUsers;

  ListSearchWidget({required this.findedUsers});

  @override
  State<StatefulWidget> createState() {
    return _ListSearchWidgetState();
  }
}

class _ListSearchWidgetState extends State<ListSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: widget.findedUsers.map<Widget>((user) {
          return Column(
            children: [
              FindedUserWidget(user: user),
              const SizedBox(height: 2),
            ],
          );
        }).toList(),
      ),
    );
  }
}
