import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/init.dart';
import 'data/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeRoute,
      routes: routes,
      theme: ThemeData(
          useMaterial3: false,
          canvasColor: Color(0xFFF3F4F6),
          primaryColor: Color(0xFF16a34a),
          textTheme: TextTheme(
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
          appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
              foregroundColor: Color(0xFF2C2C2C),
              actionsIconTheme: IconThemeData(color: Color(0xFF2C2C2C)),
              iconTheme: IconThemeData(color: Color(0xFF2C2C2C)),
              titleTextStyle: TextStyle(color: Color(0xFF2C2C2C), fontSize: 16, fontWeight: FontWeight.w700)
          ),
          listTileTheme: ListTileThemeData(iconColor: Color(0xFF2C2C2C), textColor: Color(0xFF2C2C2C))
      ),
    );
  }
}