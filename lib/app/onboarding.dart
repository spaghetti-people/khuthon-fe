import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class OnboardingScreen extends StatelessWidget {
  // ① 콜백 프로퍼티 추가
  final VoidCallback onFinish;

  // ② 생성자에 required로 받기
  const OnboardingScreen({
    super.key,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Plantify',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'kangwon',
                fontWeight: FontWeight.w900,
                color: Colors.black, // 필요에 따라 변경
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF077EFF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Plus',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // 이미지
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/onboarding_girl.png', // 이미지 파일 넣으신 경로에 맞게 수정하세요
                    height: 300,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 제목
              const Text(
                '손 안에서 키우는 나만의 채소',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // 설명
              const Text(
                '당신의 꾸준함이 자라는 시간,\n플랜티파이에서 채소를 키워보세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF60646C),
                ),
              ),

              const SizedBox(height: 32),

              // 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final box = Hive.box('localdata');
                    await box.put('isFirst', false);                // 온보딩 본 상태 저장
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B3BDD),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '플랜티파이 시작하기',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),


              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
