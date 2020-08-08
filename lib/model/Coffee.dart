class Coffee {
  final String name;
  final String roaster;
  final int id;

  Coffee({this.id, this.name, this.roaster});

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'],
      name: json['name'],
      roaster: json['roaster'],
    );
  }
}
