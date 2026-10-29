class Globals {
  Globals._();

  static final Globals _instance = Globals._();

  factory Globals() => _instance;

  int _userId = 0;
  String _username = '';
  String _token = '';
  String _email = '';

  int get userId => _userId;
  String get username => _username;
  String get token => _token;
  String get email => _email;

  void setUserId(int id) {
    _userId = id;
  }

  void setUsername(String name) {
    _username = name;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setToken(String token) {
    _token = token;
  }

  void clearUsername() {
    _userId = 0;
    _username = '';
    _token = '';
    _email = '';
  }
}
