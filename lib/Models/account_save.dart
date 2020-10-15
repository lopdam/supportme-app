class AccountSave {
  static int _id;
  static String _token;

  AccountSave({int id, String token}) {
    _id = id;
    _token = token;
  }

  static bool isLogin() {
    return _id != null || _token != null;
  }

  static set token(String value) {
    _token = value;
  }

  static set id(int value) {
    _id = value;
  }

  static String get token => _token;

  static int get id => _id;
}
