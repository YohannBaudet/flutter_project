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

  PreferenceUtils preferenceUtils = PreferenceUtils();

  late Future<List<Deck>> decks;

  @override
  void initState() {
    super.initState();
    decks = preferenceUtils.loadDeck();
  }

  @override
  Widget build(BuildContext context) {
    print('ok');
    return FutureBuilder(
    future: decks,
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
                    int id = preferenceUtils.getId();
                    setState((){ preferenceUtils.getDeck.add(Deck(id,"Nouveau deck")); });
                    preferenceUtils.saveDecks();
                  },
                ),),
              /*Padding(
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
                  },
                ),)*/

            ],
          ),
          body: GridView.builder(
            padding: const EdgeInsets.fromLTRB(5,16,5,16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (1 / 1.2)),
            itemCount: preferenceUtils.getDeck.length,
            itemBuilder: (context,index){
              final item = preferenceUtils.getDeck[index];

              return Card(
                elevation: 6,
                child: Container(
                  child:
                  GridTile(
                    header: SizedBox(
                      height: 50,
                      child: GridTileBar(
                          backgroundColor: Colors.blueAccent,
                          title: Text(item.getName(),
                            style: TextStyle(color: Colors.black),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        trailing: PopupMenuButton(
                          icon: const Icon(
                            Icons.edit,
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: "rename",
                                child: TextFormField(
                                  initialValue: item.name,
                                  onFieldSubmitted: (String value) async {
                                    setState((){ item.name = value; });
                                    preferenceUtils.saveDecks();
                                  },
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Retirer'),
                              )
                            ];
                          },
                          onSelected: (String value){
                            if (value == "delete"){
                              showAlertDialog(context,item);
                            }
                          },
                        ),
                      ),
                    ),
                    child: InkWell(
                        onTap: (){
                          preferenceUtils.saveDecks();
                          _navigateAndDisplaySelection(context,preferenceUtils.getDeck[index]);
                        },
                        splashColor: Colors.white10, // Splash color over image
                        child: Center(
                          child: Container(
                            child: Ink.image(
                                image: item.cartes.isEmpty ? AssetImage('assets/carteFond.png') : NetworkImage(item.getImagePremiereCarte()) as ImageProvider
                            ),
                            padding: const EdgeInsets.fromLTRB(0, 52, 0, 2),
                          ),
                        )
                      )
                  ),
                ),
              );
            },
          ),
        );
      }
      return CircularProgressIndicator(); // or some other widget
    },
  );
  }
  void _navigateAndDisplaySelection(BuildContext context,Deck deck) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeckDetails(deck: deck,)),
    );
    setState((){});
  }
  showAlertDialog(BuildContext context,Deck deck) {  // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Annuler"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Supprimer"),
      onPressed:  () {
        setState((){ preferenceUtils.getDeck.remove(deck); });
        preferenceUtils.saveDecks();
        Navigator.pop(context);
      },
    );  // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Suppression"),
      content: Text("Etes-vous sur de vouloir supprimer cet article ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );  // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}


