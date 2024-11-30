import 'package:flutter/material.dart';
import '../widgets/floating_buttons.dart';

class PageProduit extends StatelessWidget {
  final int idProduit;
  final String nameProduit;
  final String ref;
  final String size;
  final String color;
  final String image;

  const PageProduit({
    super.key,
    required this.idProduit,
    required this.nameProduit,
    required this.ref,
    required this.size,
    required this.color,
    this.image = ""
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameProduit),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du produit
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder background
              image: DecorationImage(
                  image: AssetImage('images/$image'),
                  fit: BoxFit.cover,
                  )
            ),
          ),
          const SizedBox(height: 10),
          
          // Informations sur le produit
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Référence : $ref',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Taille : $size',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Couleur : $color',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Boutons "Trouver" et "Déposer/Déplacer"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Trouver appuyé');
                        // Implémente la logique ici
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Trouver'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Déposer/Déplacer appuyé');
                        // Implémente la logique ici
                      },
                      icon: const Icon(Icons.move_to_inbox),
                      label: const Text('Déposer/Déplacer'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        print("Ajouter une image appuyé");
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text("Ajouter une image"),
                    )
                  ]
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingButtons(),
    );
  }
}
