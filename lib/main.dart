import 'package:flutter/material.dart';
import 'package:wardobe_app/pages/login_page.dart';
import 'package:wardobe_app/pages/register_page.dart';
import 'package:wardobe_app/pages/welcome_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
      //home: RegisterPage(),
    );
  }
}
