import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Background color
      body: Stack(
        children: [
          // Logo
          // Image Positioned at the Top Center
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

          // Welcome Text
          Positioned(
            top: 250, // Adjust this value for vertical position
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
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
          Positioned(
            top: 350, // Adjust this value for vertical position
            left: 24,
            right: 24,
            child: const Text(
              "Transform your device into a powerful 3D scanner with our adavnced AR technology. Capture precise mearsurements and create detailed 3D models with just your smartphone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1A2B3C),
              ),
            ),
          ),

          // image
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

          // Log In Button
          Positioned(
            top: 600, // Adjust this value for vertical position
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                // Log In functionality
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
          Positioned(
            top: 650, // Adjust this value for vertical position
            left: 0,
            right: 0,
            child: Center(
              child: const Text(
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
        ],
      ),
    );
  }
}
