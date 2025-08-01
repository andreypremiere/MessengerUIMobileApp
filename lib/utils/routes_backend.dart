class RoutesBackend {
  // static const String baseURL = '127.0.0.1:8000';
  static const String baseURL = '192.168.0.102:8000';
  // static const String baseURL = '10.53.220.227:8000';
  static const String createUser =
      'http://${RoutesBackend.baseURL}/create_user';
  static const String verifyUserById =
      'http://${RoutesBackend.baseURL}/verify_user_by_id';
  static const String authenticateUserByAny =
      'http://${RoutesBackend.baseURL}/authenticate_user_by_any';
  static const String findUserByAny =
      'http://${RoutesBackend.baseURL}/find_users_by_value';
  static const String getUserChats =
      'http://${RoutesBackend.baseURL}/get_user_chats';
}
