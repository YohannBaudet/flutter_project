import 'dart:convert';

import 'package:http/http.dart' as http;

class Carte {
  final String name;

  const Carte({
    required this.name,
  });

  static Carte fromJson(Map<String, dynamic> json) => Carte(
    name: json['name'],
  );
}

class CarteApi {
  static Future<List<Carte>> getCarteSuggestions(String query) async {
    final url = Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php?language=fr&num=1&offset=0');
    final response = await http.get(url);



    if (response.statusCode == 200) {
      final List cartes = json.decode(response.body);
      return cartes.map((json) => Carte.fromJson(json)).where((carte) {
        final nameLower = carte.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}