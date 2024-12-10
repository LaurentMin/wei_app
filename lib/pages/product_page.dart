import 'package:flutter/material.dart';
import 'package:wei_app/pages/upload_image_page.dart';
import '../widgets/floating_buttons.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';


// ignore: must_be_immutable
class PageProduit extends StatelessWidget {
  bool isExist = false;

  final int idProduit;
  final String nameProduit;
  final String ref;
  final String size;
  final String color;
  final String photo;

  PageProduit({
    super.key,
    required this.idProduit,
    required this.nameProduit,
    required this.ref,
    required this.size,
    required this.color,
    this.photo = ""
  });

  Future<bool> getImage(String imageName) async {
    const String apiUrl = "https://api.skeuly.com/image";
    try {
      // Essaie de charger l'image
      await rootBundle.load('images/$imageName');
      isExist = true;
      return true;
    } catch (e) {
      // Si l'image n'existe pas, une exception sera levée
      print('Image non trouvée localement, tentative de téléchargement...');
    }

    // Si l'image n'est pas dans les assets, la télécharger depuis le serveur
    try {
      print('$apiUrl/$imageName');
      final response = await http.get(Uri.parse('$apiUrl/$imageName'));
      if (response.statusCode == 200) {
        // Sauvegarder l'image localement dans le répertoire des fichiers temporaires
        const String directory = "../../images";
        final filePath = '$directory/$imageName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('Image téléchargée et enregistrée localement : $filePath');
        return true;
      } else {
        print('Erreur lors du téléchargement de l\'image : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion au serveur : $e');
    }
    return false; // Retourne null si le téléchargement échoue
  }

  Future<Map<String, dynamic>> postRequest(int value) async {
  var url = Uri.parse('https://io.adafruit.com/api/v2/vivic13/feeds/action/data');
  var body = jsonEncode({
    'value': value.toString(),
  });

  print('Body: $body');

  var response = await http.post(
    url,
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
      'X-AIO-Key': 'aio_yMOR488HJjYjup53pUB3ldrS4b5o'
    },
    body: body,
  );

  return jsonDecode(response.body);
}

  @override
  Widget build(BuildContext context) {
    getImage(photo);
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
                  image: AssetImage('images/$photo'),
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
                  'Reference : $ref',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Size : $size',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Colore : $color',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Boutons "Trouver", "Déposer/Déplacer" et "Ajouter une image"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Find appuyé');
                        postRequest(5);
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Find'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        print('Déposer/Déplacer appuyé');
                        // Implémente la logique ici
                      },
                      icon: const Icon(Icons.move_to_inbox),
                      label: const Text('Drop off/Relocate'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        print("Ajouter une image appuyé");
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => UploadImagePage(),
                          )
                        );
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text("Add an image"),
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
