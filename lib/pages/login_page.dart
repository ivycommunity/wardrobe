import 'package:flutter/material.dart';
import 'package:wardobe_app/services/auth_service.dart';
import 'package:wardobe_app/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final AuthService _authService = AuthService();

  void _login() async {
    User? user = await _authService.signIn(
        emailController.text, passwordController.text);

    await FirebaseAuth.instance.currentUser?.reload();

    if (user != null) {
      logger.i("Successful login for : ${user.email}");
      Fluttertoast.showToast(
        msg: "Sing In Successful for ${user.displayName}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      logger.e("Login failed");
      Fluttertoast.showToast(
        msg: "Login Failed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      body: Padding(
        padding: const EdgeInsets.all(25),
        //child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: 100),
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Continue your 3D scanning journey with precise measurements and detailed object analysis. Your saved scan and settings are ready for you.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 100),
            const Text(
              "LOG IN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            /*
            Text(
              "EMAIL",
              style: TextStyle(fontSize: 16),
            ),
            //SizedBox(height: 0.5),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "name@email.com",
                border: OutlineInputBorder(),
              ),
            ),
            */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EMAIL",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                    height: 5), // Adds spacing between Text and TextField
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "name@email.com",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            /*
            Text(
              "PASSWORD",
              style: TextStyle(fontSize: 16),
            ),
            //SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "**********",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PASSWORD",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                    height: 5), // Adds spacing between Text and TextField
                TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "**********",
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login();

                // Navigate to home screen or dashboard
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1A2B3C),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Center(
                child: Text(
                  "LOG IN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //SizedBox(height: 10),
            /*
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to Register Page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text(
                  "Don't have an account? Register",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            */

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to log in page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        //),
      ),
    );
  }
}
