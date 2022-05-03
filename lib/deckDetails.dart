import 'package:flutter/material.dart';
import 'package:flutter_project/Deck.dart';
import 'package:flutter_project/carteDetails.dart';

class DeckDetails extends StatelessWidget {
  DeckDetails({Key? key, required this.deck}) : super(key: key);
  final Deck deck;

  String _title = "";

  @override
  Widget build(BuildContext context) {
    _title = deck.getName();
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Text("testst"),
          Expanded(child: GridView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.fromLTRB(2,16,2,16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: (1 / 1.5)),
            itemCount: deck.getCartes().length,
            itemBuilder: (context,index){
              final item = deck.getCartes()[index];

              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => CarteDetails(carte: item),
                  ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  margin: const EdgeInsets.all(3),
                  color: Colors.white54,
                  child:
                    GridTile(
                      header: Center(child: Text(item.getName()), ),
                      child: Center(child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Image.network(item.getImageUrl(), height: 150,),
                      )),
                    ),
                ),
              );


            },)

          ),
        ]
      )

    );
  }

}


