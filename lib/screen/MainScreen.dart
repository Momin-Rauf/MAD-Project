import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'chat-app.dart';
import 'settings_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import '../models/profile_dto.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late Map<String, dynamic> userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get user data from route arguments
    userData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {
              'name': 'Guest User',
              'email': 'guest@example.com',
              'imageName': 'assets/profile.png',
              'phone': '',
              'address': '',
            };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        // Ensure the content doesn't overlap with system UI
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(userData: userData),
            const ChatPage(),
            const SettingsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 3) {
              // Profile tab index
              Navigator.pushNamed(
                context,
                '/profile',
                arguments: ProfileDTO(
                  name: userData['name'],
                  imageName: userData['imageName'],
                  phone: userData['phone'] ?? '',
                  email: userData['email'] ?? '',
                  biometric: userData['biometric'] ?? false,
                  address: userData['address'] ?? '',
                ),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }
}
