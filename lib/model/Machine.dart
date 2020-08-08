class Machine {
  final String manufacturer;
  final String model;
  final int id;

  Machine({this.id, this.manufacturer, this.model});

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      manufacturer: json['manufacturer'],
      model: json['model'],
    );
  }
}
