import 'package:flutter/material.dart';
import 'package:table_reservation_app/screens/admin_home_screen.dart';
import 'package:table_reservation_app/screens/home_screen.dart';
import 'package:table_reservation_app/screens/profile.dart';

class AdminScreenWrapper extends StatefulWidget {
  const AdminScreenWrapper({super.key});

  @override
  _AdminScreenWrapperState createState() => _AdminScreenWrapperState();
}

class _AdminScreenWrapperState extends State<AdminScreenWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // Replace these with your actual screens/widgets
    const HomeScreen(),
    const AdminHomeScreen(),
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
