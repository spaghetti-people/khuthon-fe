import 'package:flutter/material.dart';
import 'package:khuthon2025/app/collection.dart';
import 'dashboard.dart';
import 'my.dart';
// import 'collection_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _pages = const [
    DashboardPage(),
    CollectionPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/wordtype_logo.png', height: 28),
        actions: [
          IconButton(
            icon: const Icon(Icons.apps_rounded),
            onPressed: () => Navigator.pushNamed(context, '/menu'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0f6B7280),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // 홈
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                        color: _currentIndex == 0 ? Color(0xFF4341A6) : Colors
                            .grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '홈',
                        style: TextStyle(
                          color: _currentIndex == 0 ? Color(0xFF4341A6) : Colors
                              .grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 컬렉션
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _currentIndex == 1 ? Icons.collections : Icons
                            .collections_outlined,
                        color: _currentIndex == 1 ? Color(0xFF4341A6) : Colors
                            .grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '컬렉션',
                        style: TextStyle(
                          color: _currentIndex == 1 ? Color(0xFF4341A6) : Colors
                              .grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 설정
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _currentIndex = 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _currentIndex == 2 ? Icons.settings : Icons
                            .settings_outlined,
                        color: _currentIndex == 2 ? Color(0xFF4341A6) : Colors
                            .grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '설정',
                        style: TextStyle(
                          color: _currentIndex == 2 ? Color(0xFF4341A6) : Colors
                              .grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}