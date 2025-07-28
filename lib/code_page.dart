import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_ui/styles/app_styles.dart';
import 'package:messenger_ui/utils/auth_service.dart';
import 'package:messenger_ui/utils/routes_backend.dart';
import 'package:messenger_ui/utils/stdout_message.dart';
import 'package:messenger_ui/utils/user_service.dart';

class CodePage extends StatefulWidget {
  const CodePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CodePageState();
  }
}

class _CodePageState extends State<CodePage> {
  final TextEditingController _controller = TextEditingController();
  final UserSession _userSession = UserSession();
  bool _isLoading = false;

  Future<void> _sendRequest() async {
    if (_isLoading == true) return;

    final String text = _controller.text.trim();

    if (text.isEmpty) {
      printColorMessage('Код введен неверно');
      setState(() {
        _isLoading = false;
        _controller.text = '';
      });
      return;
    } else if (text.length != 6) {
      printColorMessage('Код не шестизначный');
      setState(() {
        _isLoading = false;
        _controller.text = '';
      });
      return;
    }

    final String userId;

    final user = _userSession.currentUser;
    if (user != null) {
      userId = user.userId;
    } else {
      printColorMessage('Пользователь был null');
      setState(() {
        _isLoading = false;
        _controller.text = '';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(RoutesBackend.verifyUserById),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'code': text}),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        await AuthService().saveToken("${data['type']} ${data['token']}");
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      }
    } catch (e) {
      printColorMessage(
        'Ошибка во время выполнения интернет запроса code_page',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        backgroundColor: AppColors.mainBackground,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: [
              // Центрированный виджет ввода
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                // color: Color(0xFFF5FCFF),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecorationForm.formDecoration,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        Text(
                          'Введите полученный код',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        TextField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                          ],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: AppInputStyles.inputDecoration(''),
                          onChanged: (value) {
                            if (value.length == 6) {
                              _sendRequest();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Кнопки снизу
              Positioned(
                left: 16,
                right: 16,
                bottom: 16, // поднимаем на высоту клавиатуры
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.textBlack,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // скругление углов
                          side: BorderSide(
                            color: AppColors.borderInput,
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Назад'),
                    ),
                    ElevatedButton(
                      style: AppButtonStyle.styleButton,
                      onPressed: () {
                        _sendRequest();
                      },
                      child: Text('Далее'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
