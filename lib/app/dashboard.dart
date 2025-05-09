import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../components/plant_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _box = Hive.box('localdata');
  List<Map<String, dynamic>> mydata = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final dataList = <Map<String, dynamic>>[];

    for (var key in _box.keys) {
      final value = _box.get(key);
      // value가 Map 이면서 'title' 키를 가지고 있을 때만 처리
      if (value is Map && value.containsKey('title')) {
        dataList.add({
          'key': key,
          'title': value['title'].toString(),
        });
      }
    }

    setState(() {
      mydata = dataList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (mydata.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/plant.png', height: 100),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mydata.first['title'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '163일 째',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.7,
                    color: Colors.green,
                    backgroundColor: Colors.green.shade100,
                    minHeight: 6,
                  ),
                ],
              ),
            ),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: mydata.map((item) {
                return PlantCard(
                  title: item['title'],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/plant',
                      arguments: {'title': item['title']},
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
