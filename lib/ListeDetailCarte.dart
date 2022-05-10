class ListeDetailCarte  {

  final List listeDetail;

  const ListeDetailCarte({
    required this.listeDetail,
  });
  Map toJson() => {
    'listeDetail':listeDetail,

  };

  List getListeDetail(){
    return listeDetail;
  }

  ListeDetailCarte.fromJson(Map<String, dynamic> json)
      : listeDetail = json["data"];
}