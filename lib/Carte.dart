class Carte  {

  String name;
  String imageUrl;
  
  Carte(this.name,this.imageUrl){
    // Initialization code goes here.
  }

  Carte.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imageUrl = json['imageUrl'];

  Map toJson() => {
    'name': name,
    'imageUrl': imageUrl,
  };

  String getName(){
    return name;
  }

  String getImageUrl(){
    return imageUrl;
  }
}