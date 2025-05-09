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

  UserCrop({
    required this.cropId,
    required this.nickName,
    required this.liveDay,
    required this.cropName,
    required this.isEnd,
  });

  factory UserCrop.fromJson(Map<String, dynamic> json) => UserCrop(
    cropId: json['crop_id'],
    nickName: json['nick_name'],
    liveDay: json['live_day'],
    cropName: json['crop_name'],
    isEnd: json['is_end'],
  );
}

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
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

    final uri = Uri.parse('http://localhost:8000/user/crop?mode=1');
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

        if (crops.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/sad_face.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  '아직 수확을 완료한 작물이 없어요.',
                  style: TextStyle(fontSize: 20, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          );
        }


        // ② 데이터가 있으면 기존 GridView
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: crops.length,
          itemBuilder: (ctx, idx) {
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
                    'isEnd': crop.isEnd
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
                    Image.asset('assets/images/plant.png', height: 48),
                    const SizedBox(height: 8),
                    Text(
                      crop.nickName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
