import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              // Image Positioned at the Top Center
              /*
              Positioned(
                top: 100, // Adjust this value for vertical position
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              */
              const SizedBox(
                height: 50,
              ),
              // Welcome Text
              const Positioned(
                top: 250, // Adjust this value for vertical position
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A2B3C),
                    ),
                  ),
                ),
              ),

              // Description Text
              const Positioned(
                top: 350, // Adjust this value for vertical position
                left: 24,
                right: 24,
                child: Text(
                  "Transform your device into a powerful 3D scanner with our adavnced AR technology. Capture precise mearsurements and create detailed 3D models with just your smartphone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A2B3C),
                  ),
                ),
              ),

              // image
              Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.checkroom,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              /*
              Positioned(
                top: 450, // Adjust this value for vertical position
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              */

              // Log In Button
              Positioned(
                top: 600, // Adjust this value for vertical position
                left: 24,
                right: 24,
                child: ElevatedButton(
                  onPressed: () {
                    // Log In functionality
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF1A2B3C),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('LOG IN'),
                ),
              ),

              // OR Text
              const Positioned(
                top: 650, // Adjust this value for vertical position
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8892A0),
                    ),
                  ),
                ),
              ),

              // Register Button
              Positioned(
                top: 680, // Adjust this value for vertical position
                left: 24,
                right: 24,
                child: ElevatedButton(
                  onPressed: () {
                    // Register functionality
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF1A2B3C),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('REGISTER'),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
