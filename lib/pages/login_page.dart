import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/pages/friendslist_page.dart';

import '../constants/app_constants.dart';
import '../constants/color_constants.dart';
import '../models/user_info.dart';
import '../pages/register_page.dart';
import '../services/user_storage.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState ();
  }
}

Future<String?> loginAuth(String username, String password) async {
  const usernameDB = 'user1';
  const passwordDB = '123';

  if (username.isEmpty) {
    return 'Tên đăng nhập không được để trống';
  } else if (password.isEmpty) {
    return 'Mật khẩu không được để trống';
  } else if (username != usernameDB || password != passwordDB) {
    return 'Bạn nhập sai tên tài khoản hoặc mật khẩu!';
  }

  return null;
}
class _LoginPageState extends State<LoginPage>{
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

    const inputDecoration = InputDecoration(
      border: UnderlineInputBorder(),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        foregroundColor:  ColorConstants.blackColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              const SizedBox(height: 30,),
              Text(
                'Tài khoản',
                style: labelStyle
              ),
              TextFormField(
                  controller: _usernameController,
                  decoration: inputDecoration
                ),
              const SizedBox(height: 30,),
              Text(
                'Mật khẩu',
                style: labelStyle,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true, //input hiển thị dưới dạng ẩn
                decoration: inputDecoration
              ),
              const Spacer(),
              if(_errorText != null)
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
                        backgroundColor: ColorConstants.buttonColor,//màu nền
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),//bo góc
                        )
                    ),
                    child: const Text(
                      AppConstants.loginButton,
                      style: TextStyle(
                        color: ColorConstants.whiteColor,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),),
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
                          MaterialPageRoute(
                              builder: (context) => RegisterPage())
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
              SizedBox(height: 24,)
            ],
          ),
        ),
      ),
    );
  }
}