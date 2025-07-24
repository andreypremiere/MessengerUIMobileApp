import 'package:flutter/material.dart';
import 'package:messenger_ui/authorization_page.dart';
import 'package:messenger_ui/code_page.dart';
import 'package:messenger_ui/main_page.dart';
import 'package:messenger_ui/utils/stdout_message.dart';
import 'package:messenger_ui/utils/user_service.dart';
import 'utils/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AuthService().clearToken();
  await AuthService().loadToken();
  await UserSession().loadUser();
  printColorMessage('token: ${AuthService().token}');
  printColorMessage(UserSession().currentUser.toString());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        // '/': (context) => const CodePage(),
        '/auth': (context) => const AuthorizationPage(),
        '/main': (context) => const MainPage(),
        '/code_page': (context) => const CodePage(),
      },
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay(context);

      // final isLoggedIn = AuthService().isLoggedIn;
      // if (isLoggedIn) {
      //   Navigator.pushReplacementNamed(context, '/main');
      // } else {
      //   Navigator.pushReplacementNamed(context, '/auth');
      // }
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  void _navigateAfterDelay(BuildContext context) async {
    // Планируем выполнение после построения UI, чтобы избежать ошибки навигации до рендеринга
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1)); // Ждём 5 секунд

      final isLoggedIn = AuthService().isLoggedIn; // Проверка авторизации

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    });
  }
}
