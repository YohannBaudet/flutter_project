import 'dart:convert';
import 'package:flutter_project/services/PreferenceUtils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_project/Carte.dart';

import 'Deck.dart';

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
  PreferenceUtils preferenceUtils = PreferenceUtils();
  List mesDeck = [];
  Map<String, setCarte> mapSet = {};
  Map<String, Deck> mapDeck = {};

  @override
  void initState() {
    super.initState();
    listeDetail = getDetailsCarte(carte.id);
    mesDeck = preferenceUtils.getDeck;
    mapDeck = getMapDeck(mesDeck);
    print(mesDeck);
  }

  Map<String, Deck> getMapDeck(List decks){
    Map<String, Deck> map = {};
    for(Deck deck in decks){
      map[deck.name] = deck;
    }
    return map;
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
              body: ListView(
                children: [
                  Column(
                    children: [
                      Image(
                        image: NetworkImage(snapshot.data?['data'][0]['card_images'][0]['image_url']),
                      ),

                      MyStatefulWidget(listeDetail: snapshot.data,),
                      Center(
                        child: Row(
                          children: [
                            MyStatefulWidget(listeDetail: snapshot.data,),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                              onPressed: () { },
                              child: Text('TextButton'),
                            )
                          ],
                        ),
                      )



                    ],

                  )
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
    MyStatefulWidget({Key? key, this.listeDetail}) : super(key: key);
    Map<String, dynamic>? listeDetail;
    @override
    State<MyStatefulWidget> createState() => _MyStatefulWidgetState(listeDetail: listeDetail);
  }

  class _MyStatefulWidgetState extends State<MyStatefulWidget> {
    _MyStatefulWidgetState({this.listeDetail});
    Map<String, dynamic>? listeDetail;

  String dropdownValue = '';
  List<String> valueDropdown = [];

    @override
    void initState() {
      super.initState();
      valueDropdown = getListeSets(listeDetail);
      dropdownValue = valueDropdown[0];
    }

  @override
  Widget build(BuildContext context) {

    print(dropdownValue);
    print(valueDropdown);
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
            print("aaaaaaaaaaaaaaaaa");
              dropdownValue = newValue!;
              print(dropdownValue);
        });
      },
        items: valueDropdown
      .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
      }).toList(),
      );
    }

    List<String> getListeSets(Map<String, dynamic>? listeDetails){
    //print(listeDetails);
        List<String> sets = [];
        if(listeDetails != null){
          for(Map<String, dynamic> set in listeDetails['data'][0]['card_sets']){
            print(set);
            String val = set['set_name'] + " - " + set['set_rarity_code'] + " - " + set['set_price'] + "€";
            sets.add(val);

          }
          return sets;
        }
        return [];
    }

  }

class setCarte{
  int idCarte;
  String set_;
  String rarete;
  int prix;

  setCarte({required this.idCarte,required this.set_, required this.rarete, required this.prix});
}
