import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_project/api/carte_api.dart';

class Recherche extends StatelessWidget {

  final String _title = "Recherche";

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        child: TypeAheadField<Carte?>(

          hideSuggestionsOnKeyboardHide: false,
          debounceDuration: Duration(milliseconds: 500),
          textFieldConfiguration: TextFieldConfiguration(
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
              title: Text(carte.name),
            );
          },
          noItemsFoundBuilder: (context)=>Container(
            height: 100,
            child:Center(
              child: Text(
                "Pas de carte trouver",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),

          onSuggestionSelected: (Carte? suggestion){
            final carte = suggestion!;

            ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content:Text('Selected carte: ${carte.name}'),
        ));
        },
        )
        ,
      ),
    ),
  );
}