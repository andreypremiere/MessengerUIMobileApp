import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_ui/models/user.dart';
import 'package:messenger_ui/utils/routes_backend.dart';
import 'package:messenger_ui/utils/stdout_message.dart';
import 'package:messenger_ui/utils/user_service.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({super.key});

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          // Весь экран с padding
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Color(0xFFF5FCFF)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                // Виджет переключения входа и регистрации
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isLogin
                              ? [
                                  BoxShadow(
                                    color: const Color.fromRGBO(0, 0, 0, 0.10),
                                    blurRadius: 8,
                                    offset: Offset(0, 0),
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isLogin = true;
                            });
                          },
                          child: Text('Войти'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isLogin
                              ? []
                              : [
                                  BoxShadow(
                                    color: const Color.fromRGBO(0, 0, 0, 0.10),
                                    blurRadius: 8,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isLogin = false;
                            });
                          },
                          child: Text('Регистрация'),
                        ),
                      ),
                    ),
                  ],
                ),
                // Виджет с белой рамкой, тенью, полями ввода и кнопкой
                isLogin ? LoginForm() : RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  UserSession userSession = UserSession();

  Future<void> _sendRequest() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final text = _controller.text.trim();
    if (text.isEmpty) {
      printColorMessage('Поле ввода пустое');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(RoutesBackend.authenticateUserByAny),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"value": text}),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        User? user;
        try {
          user = User.fromJson(data);
          userSession.saveUser(user);
          printColorMessage('Вход выполнен: ${user.toString()}');
          nextPage();
        } catch (e) {
          printColorMessage('Ошибка при парсинге: $e');
          clearForm();
        }
      } else {
        printColorMessage('Ошибка: ${response.statusCode}');
        clearForm();
      }
    } catch (e) {
      printColorMessage('Ошибка соединения: $e');
      clearForm();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void nextPage() {
    Navigator.pushNamed(context, '/code_page');
  }

  void clearForm() {
    _controller.text = '';
    printColorMessage('Произошла ошибка, форма очищена');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Никнейм, почта или телефон',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 210, 210, 210),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 136, 136, 136),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A6FF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // скругление углов
              ),
            ),
            onPressed: () {
              _sendRequest();
            },
            child: Text(
              'Войти',
              style: TextStyle(fontFamily: 'Inter', fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterFormState();
  }

}

class RegisterFormState extends State<RegisterForm> {
  final TextEditingController _controllerNumberPhone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerNickname = TextEditingController();

  bool _isLoading = false;
  UserSession userSession = UserSession();

  Future<void> _sendRequest() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final numberPhone = _controllerNumberPhone.text.trim();
    final email = _controllerEmail.text.trim();
    final nickname = _controllerNickname.text.trim();

    if (numberPhone.isEmpty || email.isEmpty || nickname.isEmpty) {
      printColorMessage('Поле ввода пустое');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(RoutesBackend.createUser),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"unique_nickname": nickname,
        "email": email, "number_phone": numberPhone}),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        User? user;
        try {
          user = User.fromJson(data);
          userSession.saveUser(user);
          printColorMessage('Вход выполнен: ${user.toString()}');
          nextPage();
        } catch (e) {
          printColorMessage('Ошибка при парсинге: $e');
        }
      } else {
        printColorMessage('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      printColorMessage('Ошибка соединения: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void nextPage() {
    Navigator.pushNamed(context, '/code_page');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _controllerNumberPhone,
            decoration: InputDecoration(
              hintText: 'Номер телефона',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 210, 210, 210),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 136, 136, 136),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          TextField(
            controller: _controllerEmail,
            decoration: InputDecoration(
              hintText: 'Электронная почта',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 210, 210, 210),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 136, 136, 136),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          TextField(
            controller: _controllerNickname,
            decoration: InputDecoration(
              hintText: 'Никнейм',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 210, 210, 210),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 136, 136, 136),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A6FF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // скругление углов
              ),
            ),
            onPressed: () {
              _sendRequest();
            },
            child: Text(
              'Зарегистрироваться',
              style: TextStyle(fontFamily: 'Inter', fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
