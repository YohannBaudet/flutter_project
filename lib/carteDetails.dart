import 'package:flutter/material.dart';
import 'package:flutter_project/Carte.dart';

class CarteDetails extends StatefulWidget {
  CarteDetails({Key? key, required this.carte}) : super(key: key);
  final Carte carte;


  @override
  _CarteDetailsState createState() => _CarteDetailsState(carte: carte);

}

class _CarteDetailsState extends State<CarteDetails>{
  _CarteDetailsState({required this.carte});
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