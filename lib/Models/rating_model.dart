class RatingModel {
  final int id;
  final int score;
  final int hueca;
  final int user;

  // "id": 3,
  // "score": 5,
  // "hueca": 4,
  // "user": 4

  RatingModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        score = json['score'],
        hueca = json['hueca'],
        user = json['user'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'score': score, 'hueca': hueca, 'user': user};
}
