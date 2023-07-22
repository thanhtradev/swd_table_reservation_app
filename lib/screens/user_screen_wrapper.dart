import 'package:flutter/material.dart';
import 'package:table_reservation_app/screens/history.dart';
import 'package:table_reservation_app/screens/home_screen.dart';
import 'package:table_reservation_app/screens/profile.dart';

class UserScreenWrapper extends StatefulWidget {
  @override
  _UserScreenWrapperState createState() => _UserScreenWrapperState();
}

class _UserScreenWrapperState extends State<UserScreenWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // Replace these with your actual screens/widgets
    const HomeScreen(),
    const HistoryScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
