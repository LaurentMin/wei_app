import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';

class PageUtilisateur extends StatelessWidget {
  const PageUtilisateur({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Utilisateur'),
      ),
      body: const Center(
        child: Text('Détails ou gestion utilisateur ici.'),
      ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
