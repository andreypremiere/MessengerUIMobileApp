import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:messenger_ui/elements/list_chats_widget.dart';
import 'package:messenger_ui/elements/list_search_widget.dart';
import 'package:messenger_ui/elements/search_stroke.dart';
import 'package:messenger_ui/models/chat.dart';
import 'package:messenger_ui/styles/app_styles.dart';
import 'package:messenger_ui/utils/auth_service.dart';
import 'package:messenger_ui/utils/routes_backend.dart';
import 'package:messenger_ui/utils/stdout_message.dart';
import 'package:messenger_ui/utils/user_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  bool _isSidebarOpen = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  List _findedUsers = [];

  @override
  void initState() {
    _searchController.addListener(() {
      printColorMessage('Текущий текст пользователя ${_searchController.text}');
    });

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        printColorMessage('isFocused $_isFocused');
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _clearInput() {
    FocusScope.of(context).unfocus();
    _searchController.clear();
    _findedUsers.clear();
    setState(() {});
  }

  void _logout() {
    AuthService().clearToken();
    UserSession().clearUser();
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  Future<void> _searchUsers() async {
    String? token = AuthService().token;

    try {
      final response = await http.post(
        Uri.parse(RoutesBackend.findUserByAny),
        headers: {'Content-type': 'application/json', 'Authorization': token!},
        body: jsonEncode({
          "value": _searchController.text.trim()
        })
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(response.body);

        try {
          setState(() {
            _findedUsers.clear();
            _findedUsers.addAll(
              data.map((e) => UserChat.fromJson(e as Map<String, dynamic>)),
            );
          });
        } catch (e) {
          printColorMessage('Ошибка во время парса результата $e');
        }
      }
    } catch (e) {
      printColorMessage('Ошибка при выполнении запроса поиска пользователей');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        child: Stack(
          children: [
            /// Основной экран
            Column(
              children: [
                // Кастомный AppBar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: BoxBorder.all(color: Colors.black, width: 2),
                  ),
                  height: 56,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      _isFocused
                          ? IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/arrow_back.svg',
                                width: 32,
                                height: 32,
                                color: AppColors.iconGray,
                              ),
                              onPressed: _clearInput,
                            )
                          : IconButton(
                              icon: SvgPicture.asset(
                                'assets/icons/burger.svg',
                                width: 24,
                                height: 24,
                                color: AppColors.iconGray,
                              ),
                              onPressed: _toggleSidebar,
                            ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 0,
                            top: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          child: SearchStroke(
                            controller: _searchController,
                            focusNode: _focusNode,
                            searchUsers: _searchUsers,
                            findedUsers: _findedUsers,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Содержимое основной страницы
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: !_isFocused
                        ? ListChatshWidget()
                        : ListSearchWidget(findedUsers: _findedUsers,),
                  ),
                ),
              ],
            ),

            /// Затемнение экрана при открытии панели
            if (_isSidebarOpen)
              GestureDetector(
                onTap: _toggleSidebar,
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),

            /// Анимированная боковая панель
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              left: _isSidebarOpen ? 0 : -250,
              top: 0,
              bottom: 0,
              width: 250,
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(
                        left: 16,
                        top: 0,
                        right: 0,
                        bottom: 0,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          // color: Colors.blueAccent,
                          fit: BoxFit.fitHeight,
                          width: 100,
                          height: 100,
                          imageUrl:
                              "https://avatars.mds.yandex.net/get-mpic/5366523/2a0000018c2905e8ad28c089c633138c8e02/orig",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 22,
                              ), // Внутренние отступы
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.transparent, // Цвет фона
                              foregroundColor: const Color.fromRGBO(
                                63,
                                63,
                                63,
                                1,
                              ), // Цвет текста и ripple
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              printColorMessage("Профиль");
                            },
                            child: const Text(
                              "Профиль",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 22,
                              ), // Внутренние отступы
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.transparent, // Цвет фона
                              foregroundColor:
                                  AppColors.textBlack, // Цвет текста и ripple
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              printColorMessage("Настройки");
                            },
                            child: const Text(
                              "Настройки",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Spacer(),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 22,
                              ), // Внутренние отступы
                              alignment: Alignment.centerLeft,
                              backgroundColor: Colors.transparent, // Цвет фона
                              foregroundColor: const Color.fromARGB(
                                255,
                                255,
                                0,
                                0,
                              ), // Цвет текста и ripple
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _logout();
                            },
                            child: const Text(
                              "Выход",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
