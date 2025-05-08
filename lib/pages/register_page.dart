import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:myapp/constants/app_constants.dart';
import 'package:myapp/constants/color_constants.dart';
import 'package:myapp/models/user_info.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/services/user_storage.dart';
// import 'package:path_provider/path_provider.dart'; //liên quan xử lý file

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

//confirm username input is exits or not
bool isFormatUsername(String username) => username.trim().contains(' ');

//confirm pass is true or not
bool isPasswordMismatch(String password, String confirmPassword) {
  return password != confirmPassword;
}

Future<String> registerUser(
  String fullName,
  String username,
  String password,
  String confirmPassword,
) async {
  if (fullName.trim().isEmpty ||
      username.trim().isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty) {
    return 'Vui lòng điền đầy đủ thông tin!';
  } else if (isFormatUsername(username)) {
    return 'Tài khoản không được chứa dấu cách!';
  } else if (isPasswordMismatch(password, confirmPassword)) {
    return 'Mật khẩu không khớp!';
  }
  final uri = Uri.parse('http://30.30.30.87:8888/api/auth/register');

  try {
    print('⏳ Gửi request đăng ký...');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'FullName': fullName,
        'UserName': username,
        'Password': password,
      }),
    );
    print('📥 Server trả về: ${response.statusCode} - ${response.body}');

    // if (response.statusCode != 200) {
    //   return 'Lỗi kết nối tới máy chủ (${response.statusCode})!';
    // }
    final json = jsonDecode(response.body);
    // if (json['id'] == 102) {
    if(response.statusCode == 200){
      final newUserInfo = UserInfo(username: username, fullName: fullName, avatar: null);
      await UserStorage.saveUserInfo(newUserInfo);
      UserStorage.printAllUsers();
      return 'Đăng ký thành công!';
    } else {
      return json['message'] ?? 'Đăng ký thất bại!';
    }
  } catch (e) {
    print('❌ Lỗi ngoại lệ: $e');
    return 'Lỗi kết nối tới máy chủ!';
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _errorText;
  bool _isLoading = false;

  void Register() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true; // Bắt đầu loading
    });

    final fullName = _displayNameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text.trim();

    final result = await registerUser(
      fullName,
      username,
      password,
      confirmPassword,
    );
    setState(() {
      _isLoading = false; // Kết thúc loading
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
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              Text('Tên hiển thị', style: labelStyle),
              TextFormField(
                controller: _displayNameController,
                decoration: inputDecoration,
              ),

              const SizedBox(height: 25),
              Text('Tài khoản', style: labelStyle),
              TextFormField(
                controller: _usernameController,
                decoration: inputDecoration,
              ),

              const SizedBox(height: 25),
              Text('Mật khẩu', style: labelStyle),
              TextFormField(
                controller: _passwordController,
                obscureText: true, //input hiển thị dưới dạng ẩn
                decoration: inputDecoration,
              ),

              const SizedBox(height: 25),
              Text('Nhập lại mật khẩu', style: labelStyle),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: inputDecoration,
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
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                            onPressed: _isLoading ? null : Register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
