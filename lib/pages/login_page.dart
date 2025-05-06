import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/pages/friendslist_page.dart';

import '../constants/app_constants.dart';
import '../constants/color_constants.dart';
import '../pages/register_page.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return StateWidget();
  }

}

class StateWidget extends State<LoginPage>{
  String usernameDB = 'user1';
  String passwordDB = '123';

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorText;

  void Login(){
    setState(() {

      if(_usernameController.text.trim().isEmpty){
        _errorText ='Tên đăng nhập không được để trống';
      }else if(_passwordController.text.isEmpty){
        _errorText = 'Mật khẩu không được để trống';
      }else if(_usernameController.text != usernameDB || _passwordController.text != passwordDB) {
        _errorText = 'Bạn nhập sai tên tài khoản hoặc mật khẩu!';
      }else{
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FriendsList())
        );
        _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  color: ColorConstants.blackColor
                ),
              ),
              TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  )
                ),
              const SizedBox(height: 30,),
              Text(
                'Mật khẩu',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: ColorConstants.blackColor
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true, //input hiển thị dưới dạng ẩn
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
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
                    onPressed: Login,
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