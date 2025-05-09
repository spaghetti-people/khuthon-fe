import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/plant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var mybox = Hive.box('localdata');
  List<Map<String, dynamic>> mydata = [];

  var myText = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      mydata = [
        {'key': 0, 'title': '쫑쫑이'},
        {'key': 1, 'title': '찹찹이'},
        {'key': 2, 'title': '쫄쫄이'},
      ];
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getItem();
  }

  void addItem(Map<String, dynamic> data) async {
    await mybox.add(data);
    print(mybox.values);
    getItem();
  }

  void deleteItem(int index) {
    mybox.delete(mydata[index]['key']);
    getItem();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('삭제되었습니다'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void getItem() {
    setState(() {
      mydata = mybox.keys.map((e) {
        var res = mybox.get(e);
        return {'key': e, 'title': res['title']};
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.apps_rounded),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          SizedBox(width: 10),
        ],
        title: Text(
          ' Plantify',
          style: TextStyle(
              fontSize: 18, fontFamily: 'kangwon', fontWeight: FontWeight.w900),
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        // Scrollable하게 만들기
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // 대표 식물 카드
            if (mydata.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/plant.png', height: 100),
                    // 대표 이미지
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(mydata.first['title'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('163일 째',
                            style: TextStyle(color: Colors.grey[600])),
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
// 하단 썸네일 리스트
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
      ),
    );
  }
}
