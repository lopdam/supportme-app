class CommentModel {
  final int id;
  final String content;
  final String created_on;
  final String updated_on;
  final int hueca;
  final int user;

  // "id": 1,
  // "content": "Me agrada que existan productos deliciosos.",
  // "created_on": "2020-09-14T15:44:59.108779-05:00",
  // "updated_on": "2020-09-14T15:44:59.108779-05:00",
  // "hueca": 2,
  // "user": 4

  CommentModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        created_on = json['created_on'],
        updated_on = json['updated_on'],
        hueca = json['hueca'],
        user = json['user'];

  String commentDate() {
    List<String> listDate = created_on.split("T");

    List<String> listHours = listDate[1].split(".")[0].split(":");
    return listHours[0] + ":" + listHours[1] + "  " + listDate[0];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'created_on': created_on,
        'updated_on': updated_on,
        'hueca': hueca,
        'user': user
      };
}
