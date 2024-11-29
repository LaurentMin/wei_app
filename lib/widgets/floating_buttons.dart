import 'package:flutter/material.dart';
import '../pages/user_page.dart';
import '../pages/scan_page.dart';
import '../pages/home_page.dart';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned( // Users Button
          right: 20,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PageUtilisateur()),
              );
            },
            child: const Icon(Icons.account_circle),
          ),
        ),
        Positioned( // Scan Button
          right: 160,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PageScan()),
              );
            },
            child: const Icon(Icons.add_circle),
          ),
        ),
        Positioned( // Home Button
          right: 300,
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
            child: const Icon(Icons.folder),
          ),
        ),
      ],
    );
  }
}
