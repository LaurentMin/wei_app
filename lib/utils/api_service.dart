import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ApiService {
  static const String urlApi = 'https://api.skeuly.com';

  // Récupérer la liste des produits
  static Future<List<dynamic>?> fetchItems() async {
    const String url = '$urlApi/items';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
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

  // Rechercher un item par reference
  static Future<List<dynamic>?> fetchItemRef(String refToFind) async {
    String url = '$urlApi/items/$refToFind';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
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

  static Future<bool> getLocation(String locateStr) async {
    const String url = '$urlApi/locations/get';
    List<String> splitted = locateStr.split('-');

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['allee'] = splitted[0];
      request.fields['rangee'] = splitted[1];
      request.fields['etage'] = splitted[2];

      final response = await request.send();
      if (response.statusCode == 200) {
        print('Existing location.');
        return true;
      } else {
        print('Erreur lors de l\'envoi : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erreur : $e');
      return false;
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
