// lib/app/plant_detail.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../components/gradient_background.dart';

class PlantDetailScreen extends StatefulWidget {
  final int cropId;
  final String nickName;
  final int liveDay;
  final String cropName;
  final int isEnd;
  final double evaluationRate;
  final String evaluation;

  const PlantDetailScreen({
    super.key,
    required this.cropId,
    required this.nickName,
    required this.liveDay,
    required this.cropName,
    required this.isEnd,
    required this.evaluationRate,
    required this.evaluation,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  /* ────────── 동영상 ────────── */
  VideoPlayerController? _controller;
  bool _loadingVideo = false;

  Color _rateColor(double rate) {
    if (rate >= 80) {
      return Colors.green;
    } else if (rate >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Future<void> _initVideo() async {
    setState(() => _loadingVideo = true);

    if (_controller != null) {
      await _controller!.pause();
      await _controller!.dispose();
    }

    if (widget.isEnd == 1) {
      final box = Hive.box('localdata');
      final sess = box.get('session') as String?;
      final uri = Uri.parse('http://localhost:8000/time/${widget.cropId}');

      _controller = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: {if (sess != null) 'Authorization': sess},
      );
    } else {
      _controller = VideoPlayerController.asset('assets/images/cam.mp4');
    }

    await _controller!.initialize();
    await _controller!.setLooping(true);
    setState(() => _loadingVideo = false);
    _controller!.play();
  }

  /* ────────── 상태 아이콘 ────────── */
  Map<String, String> _box = {
    'icon': 'assets/images/temperature.png',
    'value': '23',
    'unit': '°C',
    'message': '온도가 적당해요!',
  };

  void _onIconTap(String key) {
    setState(() {
      switch (key) {
        case 'sun':
          _box = {
            'icon': 'assets/images/temperature.png',
            'value': '23',
            'unit': '°C',
            'message': '따뜻해요!',
          };
          break;
        case 'pest':
          _box = {
            'icon': 'assets/images/pest.png',
            'value': '벌레가 없어요!',
            'unit': '',
            'message': '',
          };
          break;
        case 'water':
          _box = {
            'icon': 'assets/images/water.png',
            'value': '영양이 필요해요!',
            'unit': '',
            'message': '',
          };
          break;
        case 'fertilizer':
          _box = {
            'icon': 'assets/images/fertilizer.png',
            'value': '80',
            'unit': '%',
            'message': '물이 충분해요!',
          };
          break;
        default:
          _box = {
            'icon': 'assets/images/temperature.png',
            'value': '23',
            'unit': '°C',
            'message': '온도가 적당해요!',
          };
      }
    });
  }

  /* ────────── 물주기 POST ────────── */
  Future<void> _postWater() async {
    final box = Hive.box('localdata');
    final sess = box.get('session') as String?;
    final res = await http.post(
      Uri.parse('http://localhost:8000/water'),
      headers: {
        'Content-Type': 'application/json',
        if (sess != null) 'Authorization': sess,
      },
      body: jsonEncode({'c_id': widget.cropId, 'water': 1}),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          res.statusCode == 200 || res.statusCode == 201
              ? '${widget.nickName}에게 물주기를 완료했어요!'
              : '물주기 실패: ${res.statusCode}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.nickName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            /* ───── 동영상 카드 ───── */
            AspectRatio(
              aspectRatio: 3 / 2,
              child: GestureDetector(
                onTap: () {
                  if (_controller == null ||
                      !_controller!.value.isInitialized) {
                    _initVideo();
                  } else if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_controller != null &&
                            _controller!.value.isInitialized)
                          VideoPlayer(_controller!),
                        if (_loadingVideo)
                          const CircularProgressIndicator(),
                        if (!_loadingVideo &&
                            (_controller == null ||
                                !_controller!.value.isPlaying))
                          const Icon(Icons.play_circle_fill,
                              size: 64, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            /* ───── 아이콘 네 개 ───── */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _roundIcon('assets/images/pest.png', () => _onIconTap('pest')),
                _roundIcon('assets/images/fertilizer.png',
                        () => _onIconTap('fertilizer')),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 48),
                  child: _roundIcon(
                      'assets/images/sun.png', () => _onIconTap('sun')),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 48),
                  child: _roundIcon(
                      'assets/images/water.png', () => _onIconTap('water')),
                ),
              ],
            ),

            const SizedBox(height: 32),

            /* ───── 중앙 식물 이미지 & 이름 ───── */
            Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.green.withOpacity(0.05),
                  child: Image.asset('assets/images/plant.png',
                      width: 150, height: 150),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.nickName,
                      style: const TextStyle(
                        fontFamily: 'kangwon',
                        fontSize: 24,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset('assets/images/camera.png',
                        width: 30, height: 30),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            /* ───── 상태 칩 ───── */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _StatusChip(label: '목말라요', color: Color(0xFFF5B7B1)),
                SizedBox(width: 10),
                _StatusChip(label: '배고파요', color: Color(0xFFF5B7B1)),
                SizedBox(width: 10),
                _StatusChip(label: '따뜻해요', color: Color(0xFFF9E79F)),
              ],
            ),

            const SizedBox(height: 12),

            /* ───── 값 박스 ───── */
            _valueBox(),

            const SizedBox(height: 24),

            /* ───── 평가 섹션 ───── */
            _evaluationBox(),
          ],
        ),

        /* ───── AI 대화 / 물주기 버튼 ───── */
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: {'c_id': widget.cropId},
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCBD5E1),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'AI 대화하기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _postWater,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4341A6),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '물주기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* ────────── 재사용 위젯 ────────── */
  Widget _roundIcon(String asset, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: 35,
      backgroundColor: Colors.yellow.withOpacity(0.2),
      child: Image.asset(asset),
    ),
  );

  Widget _valueBox() => Container(
    height: 185,
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.only(top: 18, left: 10, right: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F8F8),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(_box['icon']!, width: 30, height: 30),
            const SizedBox(width: 8),
            Text(
              _box['value']!,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.green,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                decoration: TextDecoration.underline,
                decorationColor: Colors.green,
              ),
            ),
            Text(
              '  ${_box['unit']}',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _box['message']!,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  Widget _evaluationBox() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x116B7280),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI 작물 평가',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF4341A6),
          ),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: widget.evaluationRate / 100,
          minHeight: 12,
          backgroundColor: Colors.grey[300],
          color: const Color(0xFF6D83F2),
          borderRadius: BorderRadius.circular(12),
        ),
        const SizedBox(height: 8),


// 위젯 안에서 실제로 사용하는 부분
  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Text(
  '${widget.evaluationRate.toStringAsFixed(1)}%',
  style: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: _rateColor(widget.evaluationRate),  // ← 여기에 동적 색 적용
  ),
  ),
  Text(
  widget.evaluation,
  style: TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 14,
  color: _rateColor(widget.evaluationRate),  // 평가 문구도 같은 색으로 맞출 수 있어요
  ),
  ),
  ],
  ),
      ],
    ),
  );
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }
}
