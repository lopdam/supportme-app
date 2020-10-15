class CityModel {
  final int id;
  final String name;

  CityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
  @override
  String toString() {
    return name;
  }
}
