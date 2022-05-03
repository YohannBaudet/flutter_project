import 'package:flutter/material.dart';
import 'package:flutter_project/Carte.dart';

class CarteDetails extends StatelessWidget {
  CarteDetails({Key? key, required this.carte}) : super(key: key);
  final Carte carte;

  String _title = "";

  @override
  Widget build(BuildContext context) {
    _title = carte.getName();
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.blue,
      ),
      body: Image.network(carte.getImageUrl())
    );
  }
}