import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String urlApi = 'https://api.skeuly.com';

  // Récupérer la liste des produits
  static Future<List<dynamic>?> fetchItems() async {
    const String url = '$urlApi/items';

    try {
      print("fetchItems running");
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("ApiFetch OK");
        return jsonDecode(response.body);
      } else {
        print('Erreur : ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la connexion : $e');
      return null;
    }
  }

  // Ajouter une image
  static Future<void> uploadImage(File imageFile, int idProduit) async {
  const String url = '$urlApi/upload-image';

  try {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['idProduit'] = idProduit.toString();
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Image envoyée avec succès');
    } else {
      print('Erreur lors de l\'envoi : ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur : $e');
  }
}
}
