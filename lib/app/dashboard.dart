// lib/pages/dashboard_page.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../components/plant_card.dart';

class UserCrop {
  final int cropId;
  final String nickName;
  final int liveDay;
  final String cropName;
  final int isEnd;
  final double evaluationRate;
  final String evaluation;

  UserCrop(
      {required this.cropId,
      required this.nickName,
      required this.liveDay,
      required this.cropName,
      required this.isEnd,
      required this.evaluationRate,
      required this.evaluation});

  factory UserCrop.fromJson(Map<String, dynamic> json) => UserCrop(
      cropId: json['crop_id'],
      nickName: json['nick_name'],
      liveDay: json['live_day'],
      cropName: json['crop_name'],
      isEnd: json['is_end'],
      evaluationRate: json['evaluation_rate'],
      evaluation: json['evaluation']);
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<UserCrop>> _futureCrops;

  @override
  void initState() {
    super.initState();
    _futureCrops = _fetchUserCrops();
  }

  Future<List<UserCrop>> _fetchUserCrops() async {
    // Hive에서 세션 꺼내기
    final box = Hive.box('localdata');
    final session = box.get('session') as String?;

    final uri = Uri.parse('http://localhost:8000/user/crop?mode=0');
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (session != null) 'Authorization': session,
    });

    if (res.statusCode == 200) {
      print(res.body);
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final raw = body['res'];
      final list = raw is List ? raw : <dynamic>[];
      return list.map((e) => UserCrop.fromJson(e)).toList();
    } else {
      return <UserCrop>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserCrop>>(
      future: _futureCrops,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('오류: ${snap.error}'));
        }
        final crops = snap.data!;
        final itemCount = crops.length + 1;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: itemCount,
          itemBuilder: (ctx, idx) {
            if (idx == crops.length) {
              // 마지막: 작물 추가하기 타일
              return GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, '/crop_add');
                  setState(() {
                    _futureCrops = _fetchUserCrops();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0x126B7280),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color(0xff6B7280)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 36, color: Color(0xff6B7280)),
                      SizedBox(height: 20),
                      Text(
                        '추가하기',
                        style: TextStyle(color: Color(0xff6B7280)),
                      ),
                    ],
                  ),
                ),
              );
            }

            final crop = crops[idx];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/plant',
                  arguments: {
                    'cropId': crop.cropId,
                    'nickName': crop.nickName,
                    'liveDay': crop.liveDay,
                    'cropName': crop.cropName,
                    'isEnd': crop.isEnd,
                    'evaluationRate': crop.evaluationRate,
                    'evaluation': crop.evaluation
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0f6B7280), blurRadius: 6)
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/plant.png', height: 60),
                    const SizedBox(height: 20),
                    Text(
                      crop.nickName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      crop.cropName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
