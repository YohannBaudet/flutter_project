import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_project/Carte.dart';
import 'package:flutter_project/Deck.dart';
import 'package:flutter_project/carteDetails.dart';
import 'package:flutter_project/recherche.dart';
import 'package:flutter_project/services/PreferenceUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeckDetails extends StatefulWidget{
  DeckDetails({Key? key, required this.deck}) : super(key: key);
  final Deck deck;

  @override
  _DeckDetailsState createState() => _DeckDetailsState(deck: deck);
}


class _DeckDetailsState extends State<DeckDetails> {
  _DeckDetailsState({required this.deck});
  final Deck deck;

  PreferenceUtils preferenceUtils = PreferenceUtils();

  String _title = "";

  @override
  Widget build(BuildContext context) {
    _title = deck.getName();
    return Scaffold(
      appBar: AppBar(
        /*actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child:

            ),
        ],*/
        title: Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0,6,0,5),
            child: Text("Prix du deck : "+deck.getPrixDeck().toStringAsFixed(2)),
          ),
          Expanded(child: GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: (1 / 1.7)),
            itemCount: deck.getCartes().length,
            itemBuilder: (context,index){
              final item = deck.getCartes()[index];

              return Card(
                elevation: 6,
                child: Container(
                    color: Colors.white54,
                    child:
                    GridTile(
                      header: SizedBox(
                        height: 50,
                        child: GridTileBar(
                            backgroundColor: Colors.blueAccent,
                            title: Text(item.getName(),
                              style: TextStyle(fontSize: 10,color: Colors.black),
                              softWrap: true,
                              overflow: TextOverflow.clip,
                            ),
                            trailing: Container(
                              width: 20,
                              child: PopupMenuButton(
                                iconSize: 10,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Retirer'),
                                    )
                                  ];
                                },
                                onSelected: (String value){
                                  if (value == "delete"){
                                    deleteCarte(item);
                                    preferenceUtils.saveDecks();
                                  }
                                },
                              ),
                            )
                        ),
                      ),
                      child: InkWell(
                        child: Center(child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 52, 0, 2),
                          child: Image.network(item.getImageUrl_small()),
                        )),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CarteDetails(carte: item),
                            ),
                          );
                        },
                      )
                    ),
                  ),

              );


            },)

          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: () {
                  _navigateAndDisplaySelection(context);
                },
                icon: Icon( // <-- Icon
                  Icons.add,
                  size: 24.0,
                ),
                label: Text('Ajouter Carte'), // <-- Text
              ),
          ),
        ]
      )

    );
  }

  void deleteCarte(Carte carte){
    setState((){ deck.getCartes().remove(carte);});
  }
  void addCarte(Carte carte){
    setState((){ deck.getCartes().add(carte);});
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop.
  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Recherche(precedent: "mesDecks",)),
    );
    if(result!=null){
      addCarte(result);
      preferenceUtils.saveDecks();
    }
    setState((){});
  }
}


