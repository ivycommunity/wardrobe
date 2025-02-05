import 'package:flutter/material.dart';
import 'welcome_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              const SizedBox(height: 200),
              // Coat hanger icon
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
              //SizedBox(height: 20),
              // Shop now button
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Login Page
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const WelcomePage()));
                },
                style: ElevatedButton.styleFrom(
                  //backgroundColor: Colors.black87,
                  backgroundColor: const Color(0XFF1A2B3C),
                  //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "SHOP NOW",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                  const SizedBox(width: 5),
                  CircleAvatar(radius: 4, backgroundColor: Colors.grey[300]),
                  const SizedBox(width: 5),
                  CircleAvatar(radius: 4, backgroundColor: Colors.grey[300]),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
