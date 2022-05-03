import 'package:flutter_project/Carte.dart';

class Deck {
  String name;
  int prix = 0;
  List<Carte> cartes = <Carte>[];

  Deck(this.name) {
    // Initialization code goes here.
    cartes.add(Carte("first", "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg"));
    cartes.add(Carte("deux", "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg"));
    cartes.add(Carte("trois", "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg"));
    cartes.add(Carte("quatre", "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg"));
    cartes.add(Carte("cinq", "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg"));
    cartes.add(Carte("six", "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg"));
    cartes.add(Carte("sept", "https://storage.googleapis.com/ygoprodeck.com/pics_small/37478723.jpg"));
    prix = 7;
  }

  String getName(){
    return name;
  }

  int getPrix(){
    return prix;
  }

  String getImagePremiereCarte(){
    return cartes[0].getImageUrl();
  }
}