class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  static const String baseUrl = 'http://10.0.2.2:5050';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // AUTH
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static String authById(String id) => '/api/auth/$id';
}