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

  const PlantDetailScreen({
    super.key,
    required this.cropId,
    required this.nickName,
    required this.liveDay,
    required this.cropName,
    required this.isEnd,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  VideoPlayerController? _videoController;
  bool _loadingVideo = false;

  Future<void> _initVideo() async {
    setState(() => _loadingVideo = true);

    // 이전 컨트롤러가 있으면 해제
    if (_videoController != null) {
      await _videoController!.pause();
      _videoController!.dispose();
    }

    if (widget.isEnd == 1) {
      // 서버에서 MP4 스트림 가져오기
      final box = Hive.box('localdata');
      final sess = box.get('session') as String?;
      _videoController = VideoPlayerController.asset('assets/images/cam1.mp4');
      // final uri = Uri.parse('http://localhost:8000/time/${widget.cropId}');
      // _videoController = VideoPlayerController.networkUrl(
      //   uri,
      //   httpHeaders: {
      //     if (sess != null) 'Authorization': sess,
      //   },
      // );

    } else {
      // 로컬 asset 재생
      _videoController = VideoPlayerController.asset('assets/images/cam.mp4');
    }

    await _videoController!.initialize();
    await _videoController!.setLooping(true);
    setState(() => _loadingVideo = false);
    _videoController!.play();
  }

  @override
  void dispose() {
    _videoController?.dispose();
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
            widget.cropName,
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
            // 작물 별명 및 상태 표시
            Text(
              widget.nickName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.liveDay}일째 재배 중',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // ▶ 3:2 비디오 카드
            AspectRatio(
              aspectRatio: 3 / 2,
              child: GestureDetector(
                onTap: _initVideo,
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
                        // 동영상 재생 중이면 비디오 화면
                        if (_videoController != null && _videoController!.value.isInitialized)
                          VideoPlayer(_videoController!),

                        // 로딩 중 로딩 인디케이터
                        if (_loadingVideo) const Center(child: CircularProgressIndicator()),

                        // 재생 전/일시정지 시 플레이 아이콘
                        if (!_loadingVideo &&
                            (_videoController == null || !_videoController!.value.isPlaying))
                          const Icon(Icons.play_circle_fill,
                              size: 64, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            // TODO: 그 외 상세 정보…
          ],
        ),

        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // AI 대화 페이지 이동
                      Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: {'c_id': widget.cropId},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCBD5E1),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text(
                      'AI 대화하기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final box = Hive.box('localdata');
                      final sess = box.get('session') as String?;

                      final uri = Uri.parse('http://localhost:8000/water');
                      final res = await http.post(
                        uri,
                        headers: {
                          'Content-Type': 'application/json',
                          if (sess != null) 'Authorization': sess,
                        },
                        body: jsonEncode({
                          'c_id': widget.cropId,
                          'water': 1,
                        }),
                      );

                      if (res.statusCode == 200 || res.statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.nickName}에게 물주기를 완료했어요!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('물주기 실패: ${res.statusCode}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4341A6),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text(
                      '물주기',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
}
