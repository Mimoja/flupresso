class Machine {
  final String vendor;
  final String name;
  final String imageURL;

  final int id;

  Machine({this.id, this.vendor, this.name, this.imageURL});

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      vendor: json['vendor'],
      name: json['name'],
      imageURL: json['imageurl.String'],
    );
  }
}
