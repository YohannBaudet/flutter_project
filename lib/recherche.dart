import 'package:flutter/material.dart';
import 'package:flutter_project/Carte.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_project/api/carte_api.dart';

import 'api/carte_api.dart';
import 'carteDetails.dart';
import 'deckDetails.dart';

class Recherche extends StatelessWidget {

  final String _title = "Recherche";

  const Recherche({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: TypeAheadField<Carte?>(

          hideSuggestionsOnKeyboardHide: false,
          debounceDuration: const Duration(milliseconds: 500),
          textFieldConfiguration: const TextFieldConfiguration(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              hintText: "chercher une carte",
            )
          ),
          suggestionsCallback: CarteApi.getCarteSuggestions,
          itemBuilder: (context,Carte? suggestion){
            final carte = suggestion!;

            return ListTile(
              leading: Image.network(
                carte.img_url,
                fit: BoxFit.cover,
              ),
              title: Text(carte.name),
            );
          },
          noItemsFoundBuilder: (context)=>Container(
            height: 100,
            child:const Center(
              child: Text(
                "Pas de carte trouver",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),

          onSuggestionSelected: (Carte? suggestion){
            final carte = suggestion!;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarteDetails(carte: carte)
            ),
            );



        },
        )
        ,
      ),
    ),
  );
}