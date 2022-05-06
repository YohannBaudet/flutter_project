import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_project/Carte.dart';

//import 'ListeDetailCarte.dart';
//import 'api/carte_details_api.dart';

class CarteDetails extends StatefulWidget {
  CarteDetails({Key? key, required this.carte}) : super(key: key);
  final Carte carte;
  @override
  _CarteDetailsState createState() => _CarteDetailsState(carte:carte);
}

class _CarteDetailsState extends State<CarteDetails> {

  _CarteDetailsState({required this.carte});

  final Carte carte;
  late Future<Map<String, dynamic>> listeDetail;

  @override
  void initState() {
    super.initState();
    listeDetail = getDetailsCarte(carte.id);
  }

  Future<Map<String, dynamic>> getDetailsCarte(int idCarte) async {
    final response = await http.get(Uri.parse(
        'https://db.ygoprodeck.com/api/v7/cardinfo.php?language=fr&id=$idCarte'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      //print(data);
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listeDetail,
        builder: (context, AsyncSnapshot<Map<String, dynamic>>snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text((snapshot.data?['data'][0]['name']).toString()),
              ),
              body: Column(
                children: [
                  Image(
                    image: NetworkImage(snapshot.data?['data'][0]['card_images'][0]['image_url']),
                  ),
                  MyStatefulWidget(),
                ],

              )
            );
          }
          return CircularProgressIndicator();
        }
    );
  }
}
  class MyStatefulWidget extends StatefulWidget {
    const MyStatefulWidget({Key? key}) : super(key: key);
    @override
    State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
  }

  class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
          setState(() {
              dropdownValue = newValue!;
        });
      },
        items: <String>['One', 'Two', 'Free', 'Four']
      .map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
  value: value,
  child: Text(value),
  );
  }).toList(),
  );
  }
  }

