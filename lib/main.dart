import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/logger.dart';

void checkUser() {
  logger.d("Logger inititialization");
  FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser != null) {
    logger.d("User is logged in ${auth.currentUser!.email}");
  } else {
    logger.d("No user logged in");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    Fluttertoast.showToast(
      msg: "Firebase Connected Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    logger.d("Firebase Connected Successfully");
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Firebase Connection Failed: $e",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    logger.d("Firebase Connection Failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}