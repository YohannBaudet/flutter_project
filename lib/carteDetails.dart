import 'dart:convert';
import 'package:flutter_project/services/PreferenceUtils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_project/Carte.dart';

import 'Deck.dart';

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
    print("INDICE " + carte.indice.toString());
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
      int indiceCpt = 0;
      for(Map<String, dynamic> set in listeDetails['data'][0]['card_sets']){
        print(set);
        String val = set['set_name'] + "  |  " + set['set_rarity_code'] + "  |  " + set['set_price'] + "€";
        sets.add(val);
        SetCarte setc = SetCarte(idCarte: carte.getId(), set_: set['set_name'], rarete: set['set_rarity_code'], prix: double.parse(set['set_price']),indice: indiceCpt);
        mapSet[set['set_name']] = setc;
        indiceCpt+=1;
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
            addCarte(mapDeck[mesDeckToStringId[index]],Carte(name: carte.name,img_url_small: carte.img_url_small,img_url: carte.img_url,prix: mapSet[val.substring(0,val.length-2)]?.getPrix().toString()??'0.0',id: carte.id,indice: mapSet[val.substring(0,val.length-2)]?.getIndice()));
            preferenceUtils.saveDecks();
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Carte ajoutée !')));
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
            if (carte.getIndice() != null){
              return Scaffold(
                  appBar: AppBar(
                    title: Text((snapshot.data?['data'][0]['name']).toString()),
                  ),
                  body: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: ListView(
                        children: [
                          Column(
                            children: [

                              Image(
                                height: 400,
                                image: NetworkImage(snapshot.data?['data'][0]['card_images'][0]['image_url']),
                              ),
                              Container( //apply margin and padding using Container Widget.
                                padding: EdgeInsets.symmetric(vertical :40),
                                width: 1000,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(snapshot.data?['data'][0]['desc']),
                                )
                              ),
                              Text(
                                  "Set : " + snapshot.data?['data'][0]['card_sets'][carte.indice]['set_name']
                              ),
                            ],

                          )
                        ],
                      )
                  )

              );
            }
            else{
              return Scaffold(
                  appBar: AppBar(
                    title: Text((snapshot.data?['data'][0]['name']).toString()),
                  ),
                  body: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: ListView(
                        children: [
                          Column(
                            children: [

                              Image(
                                height: 400,
                                image: NetworkImage(snapshot.data?['data'][0]['card_images'][0]['image_url']),
                              ),
                              Container( //apply margin and padding using Container Widget.
                                padding: EdgeInsets.symmetric(vertical :40),
                                width: 1000,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(snapshot.data?['data'][0]['desc']),
                                )
                              ),
                              MyStatefulWidget(listeDropdown: listeDropdown,message: "Aucun set n'existe pour cette carte",setVal: setVal,),
                              Center(
                                child: Column(
                                  children:
                                  _createChildren(),
                                ),
                              )
                            ],

                          )
                        ],
                      )
                  )

              );
            }

          }
          return Center(
            child: Container(
                child: CircularProgressIndicator()),
          );
        }
    );
  }

  void addCarte(Deck? deck,Carte carte){
    deck?.getCartes().add(carte);
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
      isExpanded: true,
      value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          underline: Container(
          height: 2,
      ),
      onChanged: (String? newValue) {
          setState(() {
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
  int indice;

  SetCarte({required this.idCarte,required this.set_, required this.rarete, required this.prix,required this.indice});

  double getPrix(){
    return prix;
  }

  String getRarete(){
    return rarete;
  }

  String getSet(){
    return set_;
  }

  int getIdCarte(){
    return idCarte;
  }

  int getIndice(){
    return indice;
  }
}
