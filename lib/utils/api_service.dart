import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String urlApi = 'https://api.skeuly.com/items';

  static Future<List<dynamic>?> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(urlApi));
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
}
