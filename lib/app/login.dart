import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/gradient_background.dart';
import '../services/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idController = TextEditingController();
    final pwController = TextEditingController();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                Image.asset(
                  'assets/images/wordtype_logo.png',
                  width: 150,
                ),
                const SizedBox(height: 12),
                const Text(
                  '플랜티파이 계정으로 로그인하세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const Spacer(flex: 1),

                _buildInputField(
                  controller: idController,
                  hint: '아이디',
                  obscure: false,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: pwController,
                  hint: '비밀번호',
                  obscure: true,
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,  // 높이 고정
                  child: ElevatedButton(
                    onPressed: () { /* ... */ },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCBD5E1),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('회원가입', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,  // 높이 고정
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await AuthService.login(
                        idController.text.trim(),
                        pwController.text.trim(),
                      );
                      if (success) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('로그인에 실패했습니다')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4341A6),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('로그인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
