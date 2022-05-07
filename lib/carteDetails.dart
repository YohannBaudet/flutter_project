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
  GlobalKey<_CarteDetailsState> globalKey = GlobalKey();
  PreferenceUtils preferenceUtils = PreferenceUtils();
  List<String> listeDropdown = [];
  List mesDeck = [];
  List<String> mesDeckToString = [];
  List<int> mesDeckToStringId = [];
  Map<String, SetCarte> mapSet = {};
  Map<int, Deck> mapDeck = {};
  String val = 'HHHHHHH';

  @override
  void initState() {
    super.initState();
    listeDetail = getDetailsCarte(carte.id);
    mesDeck = preferenceUtils.getDeck;
    mapDeck = getMapDeck(mesDeck);
    print(mesDeck);
  }

  Map<int, Deck> getMapDeck(List decks){
    Map<int, Deck> map = {};
    if(decks.isEmpty){
      return map;
    }
    for(Deck deck in decks){
      map[deck.id] = deck;
      mesDeckToString.add(deck.getName());
      mesDeckToStringId.add(deck.id);
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

  List<String> getListeSets(Map<String, dynamic>? listeDetails){
    //print(listeDetails);
    print("dans le getlisteset");
    List<String> sets = [];
    if(listeDetails != null){
      for(Map<String, dynamic> set in listeDetails['data'][0]['card_sets']){
        print(set);
        String val = set['set_name'] + " | " + set['set_rarity_code'] + " | " + set['set_price'] + "€";
        sets.add(val);
        SetCarte setc = SetCarte(idCarte: carte.getId(), set_: set['set_name'], rarete: set['set_rarity_code'], prix: double.parse(set['set_price']));
        mapSet[set['set_name']] = setc;
      }
      return sets;
    }
    return [];
  }

  List<Widget> _createChildren() {
    return List<Widget>.generate(mesDeckToString.length, (int index) {
      return Row(children : [
          Text(mesDeckToString[index]),
        TextButton(

          onPressed: () {
            print(mapDeck[mesDeckToStringId[index]]?.getName());
            print("AVANT");
            print(val);
            print("APRES");
          },
          child: Text('Ajouter au deck'),
        )
      ],

      );

    });
  }
  void setVal(String val_){
    print("dans le setVal");
      val = val_;
      print(val);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listeDetail,
        builder: (context, AsyncSnapshot<Map<String, dynamic>>snapshot) {
          if (snapshot.hasData) {
            listeDropdown = getListeSets(snapshot.data);
            return Scaffold(
              appBar: AppBar(
                title: Text((snapshot.data?['data'][0]['name']).toString()),
              ),
              body: ListView(
                children: [
                  Column(
                    children: [
                      Image(
                        height: 500,
                        image: NetworkImage(snapshot.data?['data'][0]['card_images'][0]['image_url']),
                      ),

                      MyStatefulWidget(listeDropdown: listeDropdown,message: "Aucun set n'existe pour cette carte",setVal: setVal,),
                      Center(
                        child: Column(
                          children:
                            _createChildren(),
                            /*MyStatefulWidget(listeDropdown: mesDeckToString,message: "Vous n'avez aucun deck",test: test,),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                              onPressed: () {
                                print(test);
                              },
                              child: Text('TextButton'),
                            )*/

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
    MyStatefulWidget({Key? key, required this.listeDropdown, required this.message, required this.setVal}) : super(key: key);
    List<String> listeDropdown;
    String message;
    Function(String) setVal;
    @override
    State<MyStatefulWidget> createState() => _MyStatefulWidgetState(listeDropdown: listeDropdown, message: message, setVal: setVal,);
  }

  class _MyStatefulWidgetState extends State<MyStatefulWidget> {
    _MyStatefulWidgetState({required this.listeDropdown, required this.message, required this.setVal});
    List<String> listeDropdown;
    Function(String) setVal;
    String message;
    String dropdownValue = '';

    @override
    void initState() {
      super.initState();
      if(listeDropdown.isNotEmpty){
        dropdownValue = listeDropdown[0];
        setVal(dropdownValue.split('|')[0]);
      }
      else{
        dropdownValue = message;
        listeDropdown.add(dropdownValue);
      }

    }

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
            print("aaaaaaaaaaaaaaaaa");
              dropdownValue = newValue!;
              setVal(dropdownValue.split('|')[0]);
        });
      },
        items: listeDropdown
      .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
      }).toList(),
      );
    }

  }

class SetCarte{
  int idCarte;
  String set_;
  String rarete;
  double prix;

  SetCarte({required this.idCarte,required this.set_, required this.rarete, required this.prix});
}
