import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Deck.dart';
import 'package:flutter_project/deckDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MesDecks extends StatefulWidget {
  @override
  _MesDecksState createState() => _MesDecksState();
}

class _MesDecksState  extends State<MesDecks>{
  final String _title = "Mes Decks";

  //List<Deck> test = List<Deck>.generate(20, (index) => Deck("name "+ index.toString()));
  late SharedPreferences prefs;
  late List<Deck> test;
  @override
  void initState() {
    super.initState();
    _loadDeck();
  }

  //Loading counter value on start
  Future<List<Deck>> _loadDeck() async {
    prefs = await SharedPreferences.getInstance();
    String jsonListDeck = (prefs.getString("decks") ?? "");
    if (jsonListDeck == ""){
      test = <Deck>[];
      prefs.setString("decks", jsonEncode(test));
    }
    else{
      test = List<Deck>.from(jsonDecode(prefs.getString("decks").toString()).map((i) => Deck.fromJson(i)));
    }
    return test;
  }

  void saveDecks() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("decks", jsonEncode(test));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: _loadDeck(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_title),
            backgroundColor: Colors.blue,
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child:
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState((){ test.add(Deck("Nouveau deck")); });
                    saveDecks();
                    print(test.length);
                  },
                ),),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child:
                IconButton(
                  icon: const Icon(
                    Icons.exposure_neg_1,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState((){ test.removeLast(); });
                    saveDecks();
                    print(test.length);
                  },
                ),)

            ],
          ),
          body: GridView.builder(
            padding: const EdgeInsets.fromLTRB(5,16,5,16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (1 / 1)),
            itemCount: test.length,
            itemBuilder: (context,index){
              final item = test[index];

              return GridTile(
                header: Center(child: Text(item.getName()),),
                child: Center(child: GestureDetector(
                  onTap: () {}, // Image tapped
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeckDetails(deck: test[index]),
                        ),
                      );
                    }, // Image tapped
                    splashColor: Colors.white10, // Splash color over image
                    child: Ink.image(
                        fit: BoxFit.cover, // Fixes border issues
                        width: 100,
                        height: 150,
                        image: item.cartes.isEmpty ? AssetImage('assets/carteFond.png') : NetworkImage(item.getImagePremiereCarte()) as ImageProvider
                    ),
                  ),
                )),
              );
            },
          ),
        );
      }
      return CircularProgressIndicator(); // or some other widget
    },
  );
  }
}

