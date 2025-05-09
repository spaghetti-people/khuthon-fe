import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'app/home.dart';
import 'app/login.dart';
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

  @override
  void initState() {
    super.initState();
    _loadSessionStatus();
  }

  Future<void> _loadSessionStatus() async {
    final box = Hive.box('localdata');
    final session = box.get('session') as String?;
    setState(() => _hasSession = session != null && session.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasSession == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _hasSession! ? const HomeScreen() : const LoginScreen(),
      routes: routes,
      theme: ThemeData( /* ... 기존 테마 ... */ ),
    );
  }
}
