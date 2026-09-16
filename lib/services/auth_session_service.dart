class AuthSessionService {
  static int? _userId;
  static String? _name;
  static String? _email;

  static int? get userId => _userId;

  static String? get name => _name;

  static String? get email => _email;

  static bool get isLoggedIn => _userId != null;

  static void setUser({
    required int userId,
    required String name,
    required String email,
  }) {
    _userId = userId;
    _name = name;
    _email = email;
  }

  static void clear() {
    _userId = null;
    _name = null;
    _email = null;
  }
}