import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:aa/map.dart'; // 올바른 경로로 수정

class ParentMainPage extends StatefulWidget {
  const ParentMainPage({Key? key}) : super(key: key);

  @override
  _ParentMainPageState createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> {
  DateTime _currentDate = DateTime.now();

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
              // 한글 캘린더 추가
              SizedBox(
                height: 400,
                child: CalendarCarousel(
                  onDayPressed: (DateTime date, List<dynamic> events) {
                    setState(() {
                      _currentDate = date;
                    });
                  },
                  thisMonthDayBorderColor: Colors.grey,
                  daysHaveCircularBorder: true,
                  locale: 'ko',
                  selectedDateTime: _currentDate,
                ),
              ),
              const SizedBox(height: 20),
              // 아이 위치 버튼 추가
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(), // map.dart의 MapScreen으로 이동
                    ),
                  );
                },
                child: const Text('아이 위치 보기'),
              ),
              const SizedBox(height: 20),
              // 기능 버튼들
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 일정 관리 페이지로 이동
                    },
                    child: const Text('일정 관리'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 커뮤니케이션 페이지로 이동
                    },
                    child: const Text('커뮤니케이션'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 아이 정보 페이지로 이동
                    },
                    child: const Text('아이 정보'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 안전 알림 페이지로 이동
                    },
                    child: const Text('안전 알림'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
