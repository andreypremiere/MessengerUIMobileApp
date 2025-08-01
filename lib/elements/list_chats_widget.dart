import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_ui/elements/chat_widget.dart';
import 'package:messenger_ui/models/chat.dart';
import 'package:messenger_ui/utils/auth_service.dart';
import 'package:messenger_ui/utils/routes_backend.dart';
import 'package:messenger_ui/utils/stdout_message.dart';
import 'package:messenger_ui/utils/user_service.dart';

class ListChatshWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListChatsWidgetState();
  }
}

class _ListChatsWidgetState extends State<ListChatshWidget> {
  List<Chat> _chatList = [];

  @override
  void initState() {
    super.initState();
    _getUserChats();
  }

  void _logout() {
    AuthService().clearToken();
    UserSession().clearUser();
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  Future<void> _getUserChats() async {
    String? token = AuthService().token;

    printColorMessage('Сообщение выполняется');

    try {
      final response = await http.get(
        Uri.parse(RoutesBackend.getUserChats),
        headers: {'Content-Type': 'application/json', 'Authorization': token!},
      );

      if (response.statusCode == 401) {
        _logout();
        printColorMessage('Ошибка авторизации, был выполнен выход');
        return;
      }

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(response.body);

        try {
          setState(() {
            _chatList = data
                .map((e) => Chat.fromJson(e as Map<String, dynamic>))
                .toList();
          });
        } catch (e) {
          printColorMessage('Ошибка преобразования тела запроса.');
        }
      } else {
        printColorMessage('Пришло пустое тело или код ответа не 200.');
      }
    } catch (e) {
      printColorMessage(
        'Ошибка во время выполнения интернет запроса _getUserChats',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: _chatList.map((chat) {
          return Column(
            children: [
              ChatWidget(
                chat: chat
              ),
              const SizedBox(height: 2),
            ],
          );
        }).toList(),
      ),
    );
  }
}
