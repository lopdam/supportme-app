class MenuModel {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;
  final int hueca;

  MenuModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        description = json['description'],
        image = json['image'],
        hueca = json['hueca'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'description': description,
        'image': image,
        'hueca': hueca
      };
}
