class ImageModel {
  final int id;
  final String image;
  final int hueca;

  // "id": 1,
  // "image": "/images/huecas/1/hueca1.jpg",
  // "hueca": 1

  ImageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        hueca = json['hueca'];

  Map<String, dynamic> toJson() => {'id': id, 'image': image, 'hueca': hueca};
}
