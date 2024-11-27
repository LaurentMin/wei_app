import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';

class PageProduit extends StatelessWidget {
  final int idProduit;
  final String nameProduit;

  const PageProduit({
    super.key,
    required this.idProduit,
    required this.nameProduit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produit : $nameProduit'),
      ),
      body: Center(
        child: Text('Détails du produit $nameProduit (ID : $idProduit)'),
      ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
