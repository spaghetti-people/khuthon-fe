import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/auth_service.dart';  // 로그아웃 처리용

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  Future<void> _handleLogout(BuildContext context) async {
    // 1) 서버 로그아웃 (실패해도 무시)
    await AuthService.logout();
    // 2) 로그인 화면으로 복귀, 이전 스택 전부 제거
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _clearLocalData(BuildContext context) async {
    // 1) Hive 박스 초기화
    final box = Hive.box('localdata');
    await box.clear();
    // 2) 로그인 화면으로 복귀, 이전 스택 전부 제거
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('메뉴'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () => _handleLogout(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('로컬 데이터 삭제'),
            onTap: () => _clearLocalData(context),
          ),
        ],
      ),
    );
  }
}