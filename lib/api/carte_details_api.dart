import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Carte.dart';
import '../ListeDetailCarte.dart';


class DetailsCarteApi {

  Future<List<ListeDetailCarte>> getDetailsCarte(int idCarte) async {
    final response = await http.get(Uri.parse('https://db.ygoprodeck.com/api/v7/cardinfo.php?language=fr&id=$idCarte'));
    if (response.statusCode == 200) {
      List<ListeDetailCarte> values = new List<ListeDetailCarte>.from(json.decode(response.body).map((data) => ListeDetailCarte.fromJson(data)));
      return values;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception();
    }
  }
}