import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<bool> login(String id, String pw) async {
    final uri = Uri.parse('$baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'pw': pw}),
    );

    print('[LOGIN DEBUG]');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

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

  static Future<http.Response> getProfile() async {
    final box = Hive.box('localdata');
    final session = box.get('session') as String?;
    return await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        if (session != null) 'Cookie': session,
      },
    );
  }
}
