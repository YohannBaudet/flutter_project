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
                  },
                ),)

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
                                value: 'delete',
                                child: TextFormField(
                                  initialValue: item.name,
                                  onFieldSubmitted: (String value) async {
                                    setState((){ item.name = value; });
                                    preferenceUtils.saveDecks();
                                  },
                                ),
                              )
                            ];
                          },
                        ),
                      ),
                    ),
                    child: InkWell(
                        onTap: (){
                          preferenceUtils.saveDecks();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeckDetails(deck: preferenceUtils.getDeck[index]),
                            ),
                          );
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

