class Coffee {
  final String name;
  final String roaster;
  final String imageURL;
  final int id;

  Coffee({this.id, this.name, this.roaster, this.imageURL});

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'],
      name: json['name'],
      roaster: json['roaster'],
      imageURL: json['imageurl.String'],
    );
  }
}
