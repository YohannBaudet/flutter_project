import 'package:flutter/material.dart';

class Recherche extends StatelessWidget {

  final String _title = "Recherche";

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