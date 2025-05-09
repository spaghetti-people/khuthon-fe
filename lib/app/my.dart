import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../components/plant_card.dart';
import '../services/auth_service.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleLogout(BuildContext context) async {
    final success = await AuthService.logout();
    if (success) {
      // 로그아웃 성공하면 로그인 화면으로 이동
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // 실패 시 스낵바
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃에 실패했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 로그아웃 버튼
          ElevatedButton(
            onPressed: () => _handleLogout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4341A6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              '로그아웃',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // 기존 MyPage 내용이 들어갈 자리
          // 예시로 PlantCard 리스트 같은 걸 추가할 수 있습니다.
          // PlantCard(title: '예시', onTap: () {}),
        ],
      ),
    );
  }
}
