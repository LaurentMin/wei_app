import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';

class PageProduit extends StatelessWidget {
  final int idProduit;
  final String nameProduit;
  final String ref;
  final String size;
  final String color;

  const PageProduit({
    super.key,
    required this.idProduit,
    required this.nameProduit,
    required this.ref,
    required this.size,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameProduit),
      ),
      body: Center(
        child: Text('Détails du produit $nameProduit (ID : $idProduit)\n$size * $color * $ref'),
      ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
