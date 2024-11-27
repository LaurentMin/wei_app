import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';

class PageScan extends StatelessWidget {
  const PageScan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Scan'),
      ),
      body: const Center(
        child: Text('Fonctionnalité de scan ici.'),
      ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
