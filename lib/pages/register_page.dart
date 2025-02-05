import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wardobe_app/pages/login_page.dart';
import 'package:wardobe_app/utils/logger.dart';
import 'package:wardobe_app/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final AuthService _authService = AuthService();

  void _register() async{
    User? user = await _authService.register(
      emailController.text,
      passwordController.text,
      );
    
    if (user != null) {
      logger.i("Registration successful for ${user.email}");
    }
    else {
      logger.e("Registration failed");
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
            //SizedBox(height: 50),

            // Welcome Text

            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Get started....",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Transform your device into a powerful 3D scanner with our advanced AR technology. Capture precise measurements and create detailed 3D models with just your smartphone.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            //SizedBox(height: 90),

            const Text(
              "REGISTER",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            // Name Input
            //SizedBox(height: 90),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "NAME",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                    height: 5), // Adds spacing between Text and TextField
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),

            /*
            Text(
              "NAME",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            */

            // Email Input
            //SizedBox(height: 20),
            /*
            Text(
              "EMAIL",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "name@email.com",
                prefixIcon: Icon(Icons.email),
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

            // Password Input
            //SizedBox(height: 20),
            /*
            Text(
              "PASSWORD",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "**********",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
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

            //SizedBox(height: 30),

            // Register Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1A2B3C),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                logger.d("""
                  Name: ${nameController.text}
                  Email: ${emailController.text}
                  Password: ${passwordController.text}
                """);
              },
              child: const Text("REGISTER"),
            ),
            //SizedBox(height: 20),

            // Login Link
            /*
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                      color: Colors.blue,),
                ),
              ),
            ),
            */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
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
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Login",
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
