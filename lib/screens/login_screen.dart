import 'package:flutter/material.dart';
import 'package:table_reservation_app/screens/admin_screen_wrapper.dart';
import 'package:table_reservation_app/screens/home_screen.dart';
import 'package:table_reservation_app/screens/user_screen_wrapper.dart';
import 'package:table_reservation_app/utils/api_service.dart';

import '../constants/contant.dart';
import '../utils/shared_preferences_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 180,
              height: 180,
            ),
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // The button should be disabled if the username or password is empty
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  }),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  }),
            ),
            buildButton(true, "Login", () async {
              debugPrint("Username: $username");
              debugPrint("Password: $password");
              if (username == "" || password == "") {
                showAlertDialog(
                    context, "Error", "Username or password is empty");
                return null;
              } else {
                ApiService().post('/auth/login', {
                  "username": username,
                  "password": password,
                }).then((data) {
                  if (data['result'] == true) {
                    // Save user token
                    SharedPreferencesUtil.saveUserToken(data['data']['token']);
                    // Check if the user is admin or not
                    List<String> roles = data['data']['roles'].cast<String>();
                    if (roles.contains("ROLE_ADMIN")) {
                      SharedPreferencesUtil.saveIsAdmin(true);
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminScreenWrapper()));
                    } else {
                      SharedPreferencesUtil.saveIsAdmin(false);
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserScreenWrapper()));
                    }
                  }
                }).catchError((err) {
                  debugPrint("Error: $err");
                  showAlertDialog(context, "Error", err.toString());
                });
              }
            }),
          ],
        ),
      ),
    );
  }
}
