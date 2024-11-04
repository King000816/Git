import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'plgeon_user_details.dart'; // PlgeonUserDetails 클래스를 import합니다.
import 'login.dart'; // 로그인 화면을 포함한 main.dart를 import합니다.

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 인스턴스 생성
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form 상태를 관리할 키
  final TextEditingController _nameController = TextEditingController(); // 이름 입력 컨트롤러
  final TextEditingController _childNameController = TextEditingController(); // 아이 이름 입력 컨트롤러
  final TextEditingController _emailController = TextEditingController(); // 이메일 입력 컨트롤러
  final TextEditingController _passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러
  final TextEditingController _confirmPasswordController = TextEditingController(); // 비밀번호 확인 입력 컨트롤러

  String? _errorMessage; // 에러 메시지 저장

  Future<void> _signUp() async {
    // 입력 유효성 검사를 통과하면 회원가입 진행
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase를 통해 사용자 생성
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        var db = FirebaseFirestore.instance; // Firestore 인스턴스 생성

        // 사용자 정보를 Firestore에 저장
        final user = <String, String>{
          "name": _nameController.text,
          "email": _emailController.text, // 이메일 저장
        };

        // 이메일 인증 메일 전송
        await userCredential.user!.sendEmailVerification();

        // Firestore에 사용자 정보 저장
        await db
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(user)
            .onError((e, _) => print("Error writing document: $e"));

        // 회원 가입 성공 시 로그인 화면으로 이동
        _showSuccessDialog(userCredential.user?.email ?? "");
      } catch (e) {
        setState(() {
          _errorMessage = e.toString(); // 에러 메시지 설정
        });
      }
    }
  }

  void _showSuccessDialog(String email) {
    // 회원가입 성공 다이얼로그 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원가입 성공'),
          content: const Text('회원가입이 성공하였습니다. 로그인 화면으로 이동합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // login.dart로 이동
                  ),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원 가입'),
        leading: IconButton(
          icon: Image.asset('assets/img/back.png'), // 이미지 버튼
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
                keyboardType: TextInputType.text, // 텍스트 입력으로 설정
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이름을 입력해 주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _childNameController,
                decoration: const InputDecoration(labelText: '아이 이름'),
                keyboardType: TextInputType.text, // 텍스트 입력으로 설정
                validator: (value) {
                  if (value!.isEmpty) {
                    return '아이 이름을 입력해 주세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '이메일을 입력해 주세요.'; // 유효성 검사 실패 시 메시지
                  }
                  return null; // 유효한 경우 null 반환
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '비밀번호를 입력해 주세요.'; // 유효성 검사 실패 시 메시지
                  } else if (value.length < 6) {
                    return '비밀번호는 최소 6자리 이상이어야 합니다.'; // 비밀번호 길이 검사 실패 시 메시지
                  }
                  return null; // 유효한 경우 null 반환
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '비밀번호 확인을 입력해 주세요.'; // 유효성 검사 실패 시 메시지
                  } else if (value != _passwordController.text) {
                    return '비밀번호가 일치하지 않습니다.'; // 비밀번호 불일치 시 메시지
                  }
                  return null; // 유효한 경우 null 반환
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp, // 회원가입 버튼 클릭 시 _signUp 호출
                child: const Text('회원 가입'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red), // 에러 메시지 표시
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
