import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/constants/app_constants.dart';
import 'package:myapp/constants/color_constants.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:path_provider/path_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateWidget();
  }
}

//khoi tao file
Future<File> getUserFile() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/register.txt');
  print('File path: ${dir.path}/register.txt');
  if (!(await file.exists())) {
    await file.create();
  }
  return file;
}

//confirm username input is exits or not
Future<bool> isUsernameTaken(String username) async {
  final file = await getUserFile();
  final contents = await file.readAsLines();

  for (var line in contents) {
    final parts = line.split(',');
    if (parts.length >= 2 && parts[1] == username) {
      return true;
    }
  }
  return false;
}

//confirm pass is true or not
Future<bool> isConfirmPassword(String password, String confirmPassword) async => password != confirmPassword;

Future<String> registerUser(String fullName, String username, String password,
    String confirmPassword) async{
  if(await isUsernameTaken(username)){
    return 'Tài khoản đã tồn tại!';
  } else if(await isConfirmPassword(password, confirmPassword)){
    return 'Mật khẩu không khớp!';
  }
  final file = await getUserFile();
  final newUserLine = "${fullName},${username},${password}\n";
  await file.writeAsString(newUserLine, mode: FileMode.append);

  return 'Đăng ký thành công!';
}

class StateWidget extends State<RegisterPage> {
  //giả sử tài khoản này tồn tại
  String usernameDB = 'user1';

  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorText;

  void Register() async{
    final fullName = _displayNameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text.trim();

    final result = await registerUser(fullName, username, password, confirmPassword);
    setState(() {
      if (result == 'Đăng ký thành công!') {
        _errorText = null;
        // Bạn có thể chuyển trang hoặc hiện thông báo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Có lỗi, hiển thị thông báo lỗi
        _errorText = result;
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
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        centerTitle: true,
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
              const SizedBox(height: 26),
              const Center(
                child: Text(
                  AppConstants.registerTitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Tên hiển thị',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  color: ColorConstants.blackColor,
                ),
              ),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Tài khoản',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  color: ColorConstants.blackColor,
                ),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 25),
              Text(
                'Mật khẩu',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  color: ColorConstants.blackColor,
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true, //input hiển thị dưới dạng ẩn
                decoration: InputDecoration(border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 25),
              Text(
                'Nhập lại mật khẩu',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  color: ColorConstants.blackColor,
                ),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true, //input hiển thị dưới dạng ẩn
                decoration: InputDecoration(border: UnderlineInputBorder()),
              ),
              const Spacer(),
              if (_errorText != null)
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
                      backgroundColor: ColorConstants.buttonColor, //màu nền
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), //bo góc
                      ),
                    ),
                    child: const Text(
                      AppConstants.registerTitle,
                      style: TextStyle(
                        color: ColorConstants.whiteColor,
                        fontFamily: 'Roboto',
                        fontSize: 16,
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
