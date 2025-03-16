import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';
import 'screen/login.dart';
import 'screen/MainScreen.dart';
import 'screen/profile_screen.dart';
import 'screen/chat-app.dart';
import 'screen/settings_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BalWijzer',
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => const ChatPage(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
