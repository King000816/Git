import 'package:flutter/material.dart';
import 'main_P.dart'; // ParentMainPage를 포함한 파일

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '어린이집 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigateToTeacherMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TeacherLoginPage()),
    );
  }

  void _navigateToParentMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParentLoginPage()),
    );
  }

  void _navigateToMainP(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParentMainPage()), // main_P.dart의 ParentMainPage로 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('어린이집 앱'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            const Text(
              '사용자 모드 선택',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToTeacherMode(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: Colors.blue, // 버튼 색상
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('선생님 모드'),
                ),
                const SizedBox(width: 20), // 버튼 간격
                ElevatedButton(
                  onPressed: () => _navigateToParentMode(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: Colors.green, // 버튼 색상
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('학부모 모드'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _navigateToMainP(context), // 추가된 버튼의 클릭 이벤트
              child: const Text('메인 페이지'), // 버튼 이름
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherLoginPage extends StatelessWidget {
  const TeacherLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('선생님 로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            TextField(
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 로그인 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('선생님 로그인 시도')),
                );
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}

class ParentLoginPage extends StatelessWidget {
  const ParentLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학부모 로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
          children: [
            TextField(
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 로그인 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('학부모 로그인 시도')),
                );
              },
              child: const Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
