import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Deck.dart';
import 'package:flutter_project/deckDetails.dart';
import 'package:flutter_project/services/PreferenceUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MesDecks extends StatefulWidget {
  @override
  _MesDecksState createState() => _MesDecksState();
}

class _MesDecksState  extends State<MesDecks>{
  final String _title = "Mes Decks";

  late SharedPreferences prefs;

  PreferenceUtils preferenceUtils = PreferenceUtils();

  @override
  void initState() {
    super.initState();
    preferenceUtils.loadDeck();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: preferenceUtils.loadDeck(),
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
                    setState((){ preferenceUtils.getDeck.add(Deck("Nouveau deck")); });
                    preferenceUtils.saveDecks();
                    print(preferenceUtils.getDeck.length);
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
                    setState((){ preferenceUtils.getDeck.removeLast(); });
                    preferenceUtils.saveDecks();
                    print(preferenceUtils.getDeck.length);
                  },
                ),)

            ],
          ),
          body: GridView.builder(
            padding: const EdgeInsets.fromLTRB(5,16,5,16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (1 / 1)),
            itemCount: preferenceUtils.getDeck.length,
            itemBuilder: (context,index){
              final item = preferenceUtils.getDeck[index];

              return GridTile(
                header: Center(child: Text(item.getName()),),
                child: Center(child: GestureDetector(
                  onTap: () {
                    preferenceUtils.saveDecks();
                  }, // Image tapped
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeckDetails(deck: preferenceUtils.getDeck[index]),
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

