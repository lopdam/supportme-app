class HuecaModel {
  final int id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String created_on;
  final String updated_on;
  final int city;
  final int category;
  final int user;

  // "id": 1,
  // "name": "Ceviches Mileniun",
  // "description": "",
  // "address": "",
  // "phone": "",
  // "latitude": -2.20584,
  // "longitude": -79.90795,
  // "created_on": "2020-09-04T17:26:09.761314-05:00",
  // "updated_on": "2020-09-04T17:26:09.761363-05:00",
  // "city": 3,
  // "category": 1,
  // "user": 2

  HuecaModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        address = json['address'],
        phone = json['phone'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        created_on = json['created_on'],
        updated_on = json['updated_on'],
        city = json['city'],
        category = json['category'],
        user = json['user'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'address': address,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude,
        'created_on': created_on,
        'updated_on': updated_on,
        'city': city,
        'category': category,
        'user': user
      };
}
