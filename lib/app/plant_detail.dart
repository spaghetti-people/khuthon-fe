import 'package:flutter/material.dart';

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final title = args['title'];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/plant.png', height: 150),
            const SizedBox(height: 20),
            Text('식물 이름: $title', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('이곳에 더 많은 정보를 표시할 수 있습니다.'),
          ],
        ),
      ),
    );
  }
}
