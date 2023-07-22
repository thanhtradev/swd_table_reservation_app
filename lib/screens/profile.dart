import 'package:flutter/material.dart';
import 'package:table_reservation_app/repositories/user_repository.dart';
import 'package:table_reservation_app/screens/welcome_screen.dart';
import 'package:table_reservation_app/utils/shared_preferences_util.dart';

import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    UserRepository().getCurrentUser().then((value) {
      setState(() {
        user = value;
        // Initialize the phone controller with the current user's phone number
        _phoneController.text = user?.phone ?? '';
        _fullNameController.text = user?.fullName ?? '';
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        user != null
            ? Text(
                'Welcome, ${user!.username}',
                textAlign: TextAlign.center,
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        // Show user info
        ListTile(
          title: const Text('Full Name'),
          subtitle: Text(user?.fullName ?? ''),
        ),
        ListTile(
          title: const Text('Phone'),
          subtitle: Text(user?.phone ?? ''),
        ),
        const SizedBox(height: 20),
        // Edit button to navigate to the edit screen
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                  user: user,
                  phoneController: _phoneController,
                  fullNameController: _fullNameController,
                ),
              ),
            ).then((updatedUser) {
              if (updatedUser != null) {
                // Update the user info if it was edited
                setState(() {
                  user = updatedUser;
                });
              }
            });
          },
          child: const Text('Edit Profile'),
        ),
        const SizedBox(height: 20),
        // Logout button, red color
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            SharedPreferencesUtil.removeUserToken().then((value) {
              if (value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()));
              }
            });
          },
          child: const Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final User? user;
  final TextEditingController phoneController;
  final TextEditingController fullNameController;

  const EditProfileScreen(
      {super.key,
      required this.user,
      required this.phoneController,
      required this.fullNameController});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
                title: const Text('Full Name'),
                subtitle: TextFormField(
                  controller: widget.fullNameController,
                )),
            ListTile(
              title: const Text('Phone'),
              subtitle: TextFormField(
                controller: widget.phoneController,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the edited phone number and return to the previous screen
                final updatedUser = widget.user?.copyWith(
                  phone: widget.phoneController.text,
                  fullName: widget.fullNameController.text,
                );
                UserRepository()
                    .updateProfile(
                      widget.user!.id!,
                      updatedUser!.fullName!,
                      updatedUser.phone!,
                    )
                    .then((value) => {
                          Navigator.pop(context, updatedUser),
                        });
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
