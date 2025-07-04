import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/pages/friendslist_page.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/services/token_service.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../constants/color_constants.dart';
import '../models/user_info.dart';
import '../pages/register_page.dart';
import '../services/user_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

Future<String?> loginAuth(String username, String password) async {
  if (username.isEmpty) {
    return 'Tên đăng nhập không được để trống';
  } else if (password.isEmpty) {
    return 'Mật khẩu không được để trống';
  }
  String endPoint = '/auth/login';
  final uri = Uri.parse(ApiConstants.getUrl(endPoint));

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Username': username, 'Password': password}),
    );
    final json = jsonDecode(response.body);

    if (json['status'] == 1) {
      final data = json['data'];
      final fullName = data['FullName'];
      final avatar = data['Avatar'];
      final token = data['token'];

      TokenService.saveToken(token, username);

      final newUserInfo = UserInfo(
        username: username,
        fullName: fullName,
        avatar: avatar,
      );
      await UserStorage.saveUserInfo(newUserInfo);

      return null;
    } else {
      return json['message'] ?? 'Đăng nhập thất bại!';
    }
  } catch (e) {
    return 'Lỗi kết nối tới máy chủ!';
  }
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorText;

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    String? error = await loginAuth(username, password);

    if (error != null) {
      setState(() {
        _errorText = error;
      });
    } else {
      setState(() {
        _errorText = null;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FriendsList()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedUsername();
  }

  void _loadSavedUsername() async {
    final savedUsername = await TokenService.getUsername();
    if (savedUsername != null && savedUsername.isNotEmpty) {
      _usernameController.text = savedUsername;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      color: ColorConstants.blackColor,
    );

    const inputDecoration = InputDecoration(border: UnderlineInputBorder());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Bkav Chat',
          style: TextStyle(
            color: ColorConstants.logoColor,
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: ColorConstants.whiteColor,
        // backgroundColor: Colors.red,
        foregroundColor: ColorConstants.blackColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              const SizedBox(height: 30),
              Text('Tài khoản', style: labelStyle),
              TextFormField(
                controller: _usernameController,
                decoration: inputDecoration,
              ),
              const SizedBox(height: 30),
              Text('Mật khẩu', style: labelStyle),
              TextFormField(
                controller: _passwordController,
                obscureText: true, //input hiển thị dưới dạng ẩn
                decoration: inputDecoration,
              ),
              const Spacer(),
              if (_errorText != null)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(),
                    child: Text(
                      _errorText!,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: ColorConstants.errorTextColor,
                      ),
                    ),
                  ),
                ),
              const Spacer(),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.buttonColor, //màu nền
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), //bo góc
                      ),
                    ),
                    child: const Text(
                      AppConstants.loginButton,
                      style: TextStyle(
                        color: ColorConstants.whiteColor,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      //TODO
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: ColorConstants.registerTextColor,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
