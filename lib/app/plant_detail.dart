import 'package:flutter/material.dart';

class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({super.key});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  String _statusMessage = '온도가 적당해요';
  Map<String, String> _boxContent = {
    'icon': '/images/temperature.png',
    'value': '23',
    'unit': '°C',
    'message': '온도가 적당해요!',
  };

  void _onIconTap(String type) {
    setState(() {
      switch (type) {
        case 'sun':
          _statusMessage = '온도가 적당해요!';
          _boxContent = {
            'icon': '/images/temperature.png',
            'value': '23',
            'unit': '°C',
            'message': '따뜻해요!',
          };
          break;
        case 'pest':
          _statusMessage = '벌레가 없어요!';
          _boxContent = {
            'icon': '/images/pest.png',
            'value': '벌레가 없어요!',
            'unit': '',
            'message': '',
          };
          break;
        case 'water':
          _statusMessage = '물이 충분해요!';
          _boxContent = {
            'icon': '/images/water.png',
            'value': '영양이 필요해요!',
            'unit': '',
            'message': '',
          };
          break;
        case 'fertilizer':
          _statusMessage = '비료가 필요해요!';
          _boxContent = {
            'icon': '/images/fertilizer.png',
            'value': '80',
            'unit': '%',
            'message': '물이 충분해요!',
          };
          break;
        default:
          _statusMessage = '온도가 적당해요';
          _boxContent = {
            'icon': '/images/temperature.png',
            'value': '23',
            'unit': '°C',
            'message': '온도가 적당해요!',
          };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '돌아가기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _onIconTap('pest'),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.yellow.withOpacity(0.2),
                  child: Image.asset('/images/pest.png'),
                ),
              ),
              GestureDetector(
                onTap: () => _onIconTap('fertilizer'),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.yellow.withOpacity(0.2),
                  child: Image.asset('/images/fertilizer.png'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: GestureDetector(
                  onTap: () => _onIconTap('sun'),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.yellow.withOpacity(0.2),
                    child: Image.asset('/images/sun.png'),
                  ),
                ),
              ),
              const Text(""),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: GestureDetector(
                  onTap: () => _onIconTap('water'),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.yellow.withOpacity(0.2),
                    child: Image.asset('/images/water.png'),
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: Container()),
          const Spacer(),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.green.withOpacity(0.05),
                  child: Image.asset(
                    '/images/plant.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '쫑쫑이',
                      style: TextStyle(
                        fontFamily: 'kangwon',
                        fontSize: 24,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset('/images/camera.png', width: 30, height: 30),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
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
          const SizedBox(height: 10),
          Container(
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
                    Image.asset(_boxContent['icon']!, width: 30, height: 30),
                    const SizedBox(width: 8),
                    Text(
                      _boxContent['value']!,
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
                      '  ${_boxContent['unit']}',
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
                  _boxContent['message']!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.water_drop, size: 32),
                label: const Text(
                  '물주기',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB3E0FF),
                  foregroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 2,
                  shadowColor: Colors.blue[100],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
    );
  }
}