import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 추가
import 'main.dart';
import 'signup.dart'; // 회원가입 페이지를 import합니다.
import 'main_page.dart'; // MainPage를 import합니다.
import 'password_reset.dart'; // 비밀번호 찾기 페이지를 import합니다.
import 'plgeon_user_details.dart'; // PlgeonUserDetails 클래스를 import합니다.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form 상태를 관리할 키
  bool _autoLogin = false; // 자동 로그인 체크 상태

  @override
  void initState() {
    super.initState();
    _checkAutoLogin(); // 자동 로그인 확인
  }

  Future<void> _checkAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      await _loginWithCred(email, password);
    }
  }

  Future<void> _loginWithCred(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일 인증이 필요합니다. 인증 메일을 확인하세요.')),
        );
        return;
      }

      String userName = "사용자 이름"; // 실제 사용자 이름으로 변경
      String childName = "아이 이름"; // 실제 아이 이름으로 변경

      PlgeonUserDetails userDetails = PlgeonUserDetails(
        name: userName,
        email: userCredential.user?.email ?? "",
        childName: childName,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(userDetails: userDetails)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 또는 비밀번호가 틀렸습니다. 다시 확인해 주세요.')),
      );
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!userCredential.user!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이메일 인증이 필요합니다. 인증 메일을 확인하세요.')),
        );
        return;
      }

      // 로그인 성공 시 이메일과 비밀번호 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_autoLogin) {
        await prefs.setString('email', _emailController.text);
        await prefs.setString('password', _passwordController.text);
      } else {
        await prefs.remove('email');
        await prefs.remove('password');
      }

      String userName = "사용자 이름"; // 실제 사용자 이름으로 변경
      String childName = "아이 이름"; // 실제 아이 이름으로 변경

      PlgeonUserDetails userDetails = PlgeonUserDetails(
        name: userName,
        email: userCredential.user?.email ?? "",
        childName: childName,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(userDetails: userDetails)),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 또는 비밀번호가 틀렸습니다. 다시 확인해 주세요.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: ${e.toString()}')),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void _navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordReset()),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해 주세요.';
    }
    final RegExp emailRegex = RegExp(
      r'^[^@]+@[^@]+\.(com|net|co\.kr)$',
    );
    if (!emailRegex.hasMatch(value)) {
      return '잘못된 이메일 형식입니다. (예: ID@konyang.ac.kr)';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해 주세요.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('어린이집 어플'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: _emailValidator,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                obscureText: true,
                validator: _passwordValidator,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _autoLogin,
                    onChanged: (bool? value) {
                      setState(() {
                        _autoLogin = value ?? false; // 체크박스 상태 업데이트
                      });
                    },
                  ),
                  const Text('자동 로그인'),
                ],
              ),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('로그인'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('회원가입'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _navigateToResetPassword,
                child: Text(
                  '비밀번호를 잊으셨나요?',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
