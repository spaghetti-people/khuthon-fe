import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idController = TextEditingController();
    final pwController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: idController, decoration: const InputDecoration(labelText: 'ID')),
            TextField(controller: pwController, decoration: const InputDecoration(labelText: 'PW'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await AuthService.login(
                  idController.text.trim(),
                  pwController.text.trim(),
                );
                if (success) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인 실패')),
                  );
                }
              },

              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
