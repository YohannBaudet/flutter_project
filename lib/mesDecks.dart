import 'package:flutter/material.dart';

class MesDecks extends StatelessWidget {

  final String _title = "Mes Decks";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: Center(
          child: Text(
              _title
          )
      ),
    );
  }


}