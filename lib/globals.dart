class Globals {
  Globals._();

  static final Globals _instance = Globals._();

  factory Globals() => _instance;

  int _userId = 0;
  String _username = '';
  String _token = '';

  int get userId => _userId;
  String get username => _username;
  String get token => _token;

  void setUserId(int id) {
    _userId = id;
  }

  void setUsername(String name) {
    _username = name;
  }

  void setToken(String token) {
    _token = token;
  }

  void clearUsername() {
    _userId = 0;
    _username = '';
    _token = '';
  }
}
