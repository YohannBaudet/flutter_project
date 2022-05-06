import 'package:flutter_project/Carte.dart';

class Deck {
  String name;
  int prix = 0;
  List<Carte> cartes = <Carte>[];

  Deck(this.name) {
    // Initialization code goes here.
    /*cartes.add(Carte(name: "first", img_url_small: "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg", img_url: "img_url", id: 1));
    cartes.add(Carte(name: "2dn", img_url_small: "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg", img_url: "img_url", id: 1));
    cartes.add(Carte(name: "thirst", img_url_small: "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg", img_url: "img_url", id: 1));
    cartes.add(Carte(name: "quatre", img_url_small: "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg", img_url: "img_url", id: 1));
    cartes.add(Carte(name: "cinq", img_url_small: "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg", img_url: "img_url", id: 1));
    cartes.add(Carte(name: "sixxxxxxxxxxxxxxxxx", img_url_small: "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg", img_url: "img_url", id: 1));
    cartes.add(Carte(name: "sevennnnnnnnnn vennnnsss", img_url_small: "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg", img_url: "img_url", id: 1));*/
    prix = 7;
  }
  Deck.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        prix = json['prix'],
        cartes = List<Carte>.from(json['cartes'].map((i) => Carte.fromJson2(i)));

  Map toJson() => {
    'name': name,
    'prix': prix,
    'cartes': cartes
  };


  String getName(){
    return name;
  }

  int getPrix(){
    return prix;
  }

  String getImagePremiereCarte(){
    return cartes[0].getImageUrl_small();
  }

  List<Carte> getCartes(){
    return cartes;
  }

  double getPrixDeck(){
    double res = 0;
    for (Carte c in cartes){
      res+=double.parse(c.prix);
    }
    return res;
  }
}