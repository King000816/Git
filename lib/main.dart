import 'package:flutter/material.dart';
import 'map.dart'; // MapScreen을 import합니다.
import 'plgeon_user_details.dart'; // PlgeonUserDetails 클래스를 import합니다.

class MainPage extends StatefulWidget {
  final PlgeonUserDetails userDetails;

  const MainPage({Key? key, required this.userDetails}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학부모 페이지'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 캘린더 제거 후 다른 내용 추가
              const Text(
                '여기에서 아이의 위치를 확인할 수 있습니다.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // 아이 위치 버튼 추가
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapScreen(), // 아이 위치 찾기 화면으로 이동
                    ),
                  );
                },
                child: const Text('아이 위치 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
