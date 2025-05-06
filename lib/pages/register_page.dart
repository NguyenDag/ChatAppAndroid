import 'package:flutter/material.dart';
import 'package:myapp/constants/app_constants.dart';
import 'package:myapp/constants/color_constants.dart';
import 'package:myapp/pages/login_page.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return StateWidget();
  }
}

class StateWidget extends State<RegisterPage>{
  //giả sử tài khoản này tồn tại
  String usernameDB = 'user1';

  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorText;

  void Register(){
    setState(() {
      if(_usernameController.text == usernameDB){
        _errorText = 'Tài khoản đã tồn tại!';
      }else if(_passwordController.text  != _confirmPasswordController.text){
        _errorText = 'Mật khẩu không khớp!';
      }else{
        _errorText = null;
        //Xử lý đăng ký ở đây
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false
            );
          },
        ),
        centerTitle: true,
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
              const SizedBox(height: 26,),
              const Center(
                child: Text(AppConstants.registerTitle,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              Text(
                'Tên hiển thị',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: ColorConstants.blackColor
                ),
              ),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25,),
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
                ),
              ),
              const SizedBox(height: 25,),
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
              const SizedBox(height: 25,),
              Text(
                'Nhập lại mật khẩu',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: ColorConstants.blackColor
                ),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true, //input hiển thị dưới dạng ẩn
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              const Spacer(),
              if(_errorText !=null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(),
                    child: Text(
                      _errorText!,
                      style: TextStyle(
                        color: ColorConstants.errorTextColor,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Spacer(),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: Register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.buttonColor,//màu nền
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),//bo góc
                      )
                    ),
                    child: const Text(
                    AppConstants.registerTitle,
                    style: TextStyle(
                      color: ColorConstants.whiteColor,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),),
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