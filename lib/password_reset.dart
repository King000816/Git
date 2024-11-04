import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    String email = _emailController.text;

    // 이메일 유효성 검사
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일을 입력해 주세요.')),
      );
      return;
    }

    final RegExp emailRegex = RegExp(
      r'^[^@]+@[^@]+\.(com|net|co\.kr)$',
    );

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('잘못된 이메일 형식입니다. (예: ID@konyang.ac.kr)')),
      );
      return; // 잘못된 이메일 형식일 경우 함수 종료
    }

    try {
      // 사용자가 등록되어 있는지 확인
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('잘못된 이메일입니다. 가입한 적이 없는 이메일입니다.')),
        );
        return; // 가입하지 않은 이메일일 경우 함수 종료
      }

      // 비밀번호 재설정 이메일 발송
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호 재설정 이메일이 발송되었습니다.')),
      );
      Navigator.pop(context); // 이메일 전송 후 이전 화면으로 돌아가기
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
        leading: IconButton(
          icon: Image.asset('assets/img/back.png'), // 이미지 버튼
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('비밀번호 재설정 이메일 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
