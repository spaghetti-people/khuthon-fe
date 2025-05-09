// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000';

  /// 로그인 (기존 코드)
  static Future<bool> login(String id, String pw) async {
    final uri = Uri.parse('$baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'pw': pw}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final session = data['session'] as String?;
      if (session != null && session.isNotEmpty) {
        final box = Hive.box('localdata');
        await box.put('session', session);
        return true;
      }
    }
    return false;
  }

  /// 프로필 조회 (기존 코드)
  static Future<http.Response> getProfile() async {
    final box = Hive.box('localdata');
    final session = box.get('session') as String?;
    return http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        if (session != null) 'Cookie': session,
      },
    );
  }


  static Future<bool> logout() async {
    final box = Hive.box('localdata');
    final session = box.get('session') as String?;
    if (session == null || session.isEmpty) {
      return false;
    }

    final uri = Uri.parse('$baseUrl/logout');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': session,
      },
    );

    if (response.statusCode == 200) {
      await box.delete('session');
      return true;
    }
    return false;
  }
}
