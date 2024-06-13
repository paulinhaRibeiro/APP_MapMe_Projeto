import 'package:flutter/material.dart';

class DrawerUserAccount extends StatelessWidget {
  const DrawerUserAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: const Text(
        "John Doe",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      accountEmail: const Text("john.doe@example.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: const Icon(
          Icons.mail_lock_rounded,
          size: 40,
        ),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 41, 4),
            Color.fromARGB(255, 0, 106, 11),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
    );
  }
}
