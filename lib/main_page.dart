import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messenger_ui/elements/search_stroke.dart';
import 'package:messenger_ui/styles/app_styles.dart';
import 'package:messenger_ui/utils/stdout_message.dart';

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
    setState(() {});
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Содержимое основной страницы
                Expanded(child: Center(child: Text("Это основной контент"))),
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
                color: const Color.fromARGB(220, 255, 255, 255),
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
                          fit: BoxFit.fill,
                          width: 100,
                          height: 100,
                          imageUrl:
                              "https://storage.yandexcloud.net/storage-avatars/742b026f-4039-4243-a154-807e5dec5ba0_big",
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
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
                              printColorMessage("Выход");
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
