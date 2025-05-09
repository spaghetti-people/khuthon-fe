import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class Crop {
  final int id;
  final String name;
  Crop({required this.id, required this.name});
  factory Crop.fromJson(Map<String, dynamic> json) =>
      Crop(id: json['crop_id'], name: json['crop_name']);
}

class CropAdditionPage extends StatefulWidget {
  const CropAdditionPage({super.key});

  @override
  State<CropAdditionPage> createState() => _CropAdditionPageState();
}

class _CropAdditionPageState extends State<CropAdditionPage> {
  late Future<List<Crop>> _futureCrops;
  int? _selectedCropId;

  @override
  void initState() {
    super.initState();
    _futureCrops = _fetchCrops();
  }

  Future<List<Crop>> _fetchCrops() async {
    final uri = Uri.parse('http://localhost:8000/crop');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['corps'] as List;
      return data.map((e) => Crop.fromJson(e)).toList();
    }
    throw Exception('작물 목록을 불러오는 데 실패했습니다');
  }

  Future<void> _postUserCrop(String aliasName) async {
    final box = Hive.box('localdata');
    final session = box.get('session') as String?;
    final uri = Uri.parse('http://localhost:8000/user/crop');
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (session != null) 'Authorization': session,
      },
      body: jsonEncode({
        'c_id': _selectedCropId,
        'name': aliasName,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      print(res.body);
      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('작물이 추가되었습니다')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('추가 실패: ${res.statusCode}')),
      );
    }
  }

  void _showAliasDialog() {
    final aliasController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('나만의 이름 입력'),
        content: TextField(
          controller: aliasController,
          decoration: const InputDecoration(hintText: '예: 우리집 고구마'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('취소')),
          ElevatedButton(
            onPressed: () {
              final alias = aliasController.text.trim();
              if (alias.isNotEmpty && _selectedCropId != null) {
                _postUserCrop(alias);
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작물 선택'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Crop>>(
        future: _futureCrops,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('오류: ${snap.error}'));
          }
          final crops = snap.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: crops.length,
            itemBuilder: (ctx, idx) {
              final crop = crops[idx];
              final selected = crop.id == _selectedCropId;
              return GestureDetector(
                onTap: () => setState(() => _selectedCropId = crop.id),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: selected ? Colors.purple : Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/plant.png', height: 48),
                      const SizedBox(height: 8),
                      Text(crop.name,
                          style: TextStyle(color: selected ? Colors.purple : Colors.black)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedCropId == null ? null : _showAliasDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4341A6),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('추가하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
