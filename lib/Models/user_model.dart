class User {
  String _username;
  String _email;
  String _last_name;
  String _first_name;

  User({String username, String first_name, String last_name, String email}){
    _username=username;
    _email=email;
    _last_name=last_name;
    _first_name=first_name;
  }

  String get first_name => _first_name;
  String get last_name => _last_name;
  String get email => _email;
  String get username => _username;
}
