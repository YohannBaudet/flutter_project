import 'dart:async' show Future;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Deck.dart';

class PreferenceUtils {

  static PreferenceUtils? _instance;
  late SharedPreferences prefs;
  late List<Deck> test;
  List<Deck> get getDeck {
    return test;
  }

  PreferenceUtils._() {
    // initialization and stuff
    init();
  }

  void init() async{
    prefs = await SharedPreferences.getInstance();
  }

  factory PreferenceUtils() {
    _instance ??= new PreferenceUtils._();
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }

  void setString(String key,String value){
    prefs.setString(key, value);
  }

  String getString(String key){
    return prefs.getString("decks") ?? "";
  }

  Future<List<Deck>> loadDeck() async {
    String jsonListDeck = (prefs.getString("decks") ?? "");
    if (jsonListDeck == ""){
      test = <Deck>[];
      prefs.setString("decks", jsonEncode(test));
    }
    else{
      test = List<Deck>.from(jsonDecode(prefs.getString("decks").toString()).map((i) => Deck.fromJson(i)));
    }
    return test;
  }

  void saveDecks(){
    prefs.setString("decks", jsonEncode(test));
  }

}
