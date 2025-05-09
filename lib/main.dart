import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'app/home.dart';
import 'app/login.dart';
import 'app/onboarding.dart';
import 'data/init.dart';
import 'data/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();  // Hive.init, box 열기
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool? _hasSession;
  bool? _seenOnboarding;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final box = Hive.box('localdata');

    final session = box.get('session') as String?;
    final hasSession = session != null && session.isNotEmpty;

    final seen = box.get('seenOnboarding') as bool? ?? false;

    setState(() {
      _hasSession = hasSession;
      _seenOnboarding = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1) 아직 로딩 중
    if (_hasSession == null || _seenOnboarding == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // 2) 온보딩을 안 봤으면 -> OnboardingScreen
    if (_seenOnboarding == false) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        theme: _buildTheme(),
        home: OnboardingScreen(
          onFinish: () async {
            final box = Hive.box('localdata');
            await box.put('seenOnboarding', true);
            // 온보딩 본 상태로 바꿔서 rebuild 유도
            setState(() => _seenOnboarding = true);
            // 그리고 로그인 페이지로 이동
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      );
    }

    // 3) 온보딩 본 뒤에는 기존 세션 체크
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      theme: _buildTheme(),
      home: _hasSession! ? const HomeScreen() : const LoginScreen(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: false,
      canvasColor: const Color(0xFFF3F4F6),
      primaryColor: const Color(0xFF16a34a),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Color(0xFF60646C)),
        headlineMedium: TextStyle(color: Color(0xFF60646C)),
        headlineSmall: TextStyle(color: Color(0xFF60646C)),
        bodyMedium: TextStyle(color: Color(0xFF2C2C2C)),
      ),
      fontFamily: 'Pretendard',
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder()
      }),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xFF2C2C2C),
        actionsIconTheme: IconThemeData(color: Color(0xFF2C2C2C)),
        iconTheme: IconThemeData(color: Color(0xFF2C2C2C)),
        titleTextStyle: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Color(0xFF2C2C2C),
        textColor: Color(0xFF2C2C2C),
      ),
    );
  }
}
