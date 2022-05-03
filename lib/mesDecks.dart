import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Deck.dart';
import 'package:flutter_project/deckDetails.dart';

class MesDecks extends StatelessWidget {

  final String _title = "Mes Decks";

  final List<Deck> test = List<Deck>.generate(20, (index) => Deck("name "+ index.toString()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.blue,
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
                  image: Image.network(item.getImagePremiereCarte(),    height: 120,).image
                ),
              ),
            )),
          );
        },
      ),
    );
  }

}