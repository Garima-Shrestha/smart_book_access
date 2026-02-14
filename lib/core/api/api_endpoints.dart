import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Configuration
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.0.103';
  static const int _backendPort = 5050;
  static const int _webPort = 3000;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_backendPort';
  static String get baseUrl => '$serverUrl';
  static String get mediaServerUrl => serverUrl;
  static String get webBaseUrl => 'http://$_ipAddress:$_webPort';

  // // Base URL
  // // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  // static const String baseUrl = 'http://10.0.2.2:5050';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // AUTH
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static String authById(String id) => '/api/auth/$id';

  // Update Profile
  static const String updateProfile = '/api/auth/update-profile';
  static const String changePassword = '/api/auth/change-password';

  // Forgot Password and Reset Password
  static const String forgotPassword = '/api/auth/request-password-reset';
  static String resetPassword(String token) => '/api/auth/reset-password/$token';

  // Category
  static const String getAllCategories = '/api/categories/';
  static String getCategoryById(String id) => '/api/categories/$id';

  // Book
  static const String getAllBooks = '/api/books';
  static String getBookById(String id) => '/api/books/$id';
}