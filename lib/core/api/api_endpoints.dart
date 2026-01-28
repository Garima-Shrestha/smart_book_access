import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Configuration
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.1';
  static const int _port = 5050;

  // Base URLs
  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';
  static String get baseUrl => '$serverUrl';
  static String get mediaServerUrl => serverUrl;

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
}