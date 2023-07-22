import 'package:flutter/material.dart';
import 'package:table_reservation_app/constants/contant.dart';
import 'package:table_reservation_app/screens/admin_screen_wrapper.dart';
import 'package:table_reservation_app/screens/register_screen.dart';
import 'package:table_reservation_app/screens/user_screen_wrapper.dart';
import 'package:table_reservation_app/utils/shared_preferences_util.dart';

import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    SharedPreferencesUtil.getUserToken().then((token) {
      if (token != null) {
        SharedPreferencesUtil.getIsAdmin().then((isAdmin) {
          if (isAdmin != null) {
            if (isAdmin) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminScreenWrapper()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserScreenWrapper()));
            }
          }
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      width: 180,
                      height: 180,
                    ),
                  ),
                  // Rounded text button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
  }
}
