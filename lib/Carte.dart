class Carte  {

  final String name;
  final String img_url_small;
  final String img_url;
  final int id;
  final String prix;

  const Carte({
    required this.name,
    required this.img_url_small,
    required this.img_url,
    required this.id,
    required this.prix,
  });
  Map toJson() => {
    'id':id,
    'name': name,
    'image_url_small': img_url_small,
    'image_url':img_url,
    'prix': prix,
  };

  String getName(){
    return name;
  }

  String getImageUrl(){
    return img_url;
  }
  String getImageUrl_small(){
    return img_url_small;
  }

  int getId(){
    return id;
  }

  String getPrix(){
    return prix;
  }

  static Carte fromJson(Map<String, dynamic> json) => Carte(
    id:json['id'],
    name : json['name'],
    img_url_small: json['card_images'][0]['image_url_small'],
    img_url:json['card_images'][0]['image_url'],
    prix:json['card_prices'][0]['cardmarket_price'],
  );

  static Carte fromJson2(Map<String, dynamic> json) => Carte(
    id:json['id'],
    name : json['name'],
    img_url_small: json['image_url_small'],
    img_url:json['image_url'],
    prix:json['prix'],
  );
}