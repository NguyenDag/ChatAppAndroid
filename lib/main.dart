import 'package:flutter/material.dart';
import 'package:myapp/pages/friendslist_page.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:myapp/pages/online_chat.dart';
import 'package:myapp/pages/register_page.dart';

void main() {
  runApp(const
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnlineChat(name: 'Evelyn Dang', avatarUrl: 'https://firebasestorage.googleapis.com/v0/b/nguyen-dang.appspot.com/o/em.jpg?alt=media&token=218bdcd8-e29b-46d8-a516-4cc4ad8c1776',),
    );
  }
}
