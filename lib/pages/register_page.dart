import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wardobe_app/pages/email_verification.dart';
import 'package:wardobe_app/pages/login_page.dart';
import 'package:wardobe_app/utils/logger.dart';
import 'package:wardobe_app/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// RegisterPage handles user registration with email/password and Google Sign-In
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

  /// Custom widget to display password requirement status
  class PasswordRequirement extends StatelessWidget {
    final bool isMet;
    final String text;

    const PasswordRequirement({
      required this.isMet,
      required this.text,
      Key? key,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isMet ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      );
    }
  }

class _RegisterPageState extends State<RegisterPage> {
  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Focus nodes for field navigation
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  // UI state variables
  bool isPasswordVisible = false;
  bool _isLoading = false;
  
  // Password validation states
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasSpecialChar = false;

  // Services
  final AuthService _authService = AuthService();
  final _formkey = GlobalKey<FormState>();

  /// Handles the registration process
  void _register() async {
    // Validate form before proceeding
    if (!_formkey.currentState!.validate()) return;

    String enteredName = nameController.text.trim();
    String enteredEmail = emailController.text.trim();
    String enteredPassword = passwordController.text.trim();

    logger.i("""
    Name: $enteredName,
    Email: $enteredEmail,
    Password: $enteredPassword
    """);

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = await _authService.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      // Reload so that user details are usable
      await FirebaseAuth.instance.currentUser?.reload();

      // Check registration success
      if (user != null) {
        logger.i("Registration successful for ${user.email}, ${user.displayName}");

        Fluttertoast.showToast(
          msg: "Registration Successful for ${user.displayName}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Delay navigation to the email verification page
        await Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const EmailVerificationPage()),
          );
        });
      } else {
        logger.e("Registration failed for ${emailController.text}");

        Fluttertoast.showToast(
          msg: "Registration Failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      logger.e("Registration Failed:", error: e);
      Fluttertoast.showToast(
        msg: "Registration Failed: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            // Header section
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  "Get started....",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                Text(
                  "Transform your device into a powerful 3D scanner with our advanced AR technology. "
                  "Capture precise measurements and create detailed 3D models with just your smartphone.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),

            const SizedBox(height: 70),

            const Text(
              "REGISTER",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 20),

            // Name field with validation
            const Text(
              "NAME",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: nameController,
              focusNode: nameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(emailFocus);
              },
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Email field with validation
            const Text(
              "EMAIL",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            TextFormField(
              controller: emailController,
              focusNode: emailFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocus);
              },
              decoration: const InputDecoration(
                labelText: "name@email.com",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Password field with real-time validation
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PASSWORD",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    if (!_isLoading) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  // Real-time password validation
                  onChanged: (value) {
                    setState(() {
                      hasMinLength = value.length >= 8;
                      hasUppercase = value.contains(RegExp(r'[A-Z]'));
                      hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
                    });
                  },
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "**********",
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!hasMinLength || !hasUppercase || !hasSpecialChar) {
                      return 'Please meet all password requirements';
                    }
                    return null;
                  },
                ),
                // Password requirements indicators
                const SizedBox(height: 10),
                PasswordRequirement(
                  isMet: hasMinLength,
                  text: 'At least 8 characters',
                ),
                const SizedBox(height: 4),
                PasswordRequirement(
                  isMet: hasUppercase,
                  text: 'At least one capital letter',
                ),
                const SizedBox(height: 4),
                PasswordRequirement(
                  isMet: hasSpecialChar,
                  text: 'At least one special character',
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Register button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1A2B3C),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("REGISTER"),
            ),

            const SizedBox(height: 20),

            // Login link
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
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    nameFocus.dispose();
    nameController.dispose();
    emailFocus.dispose();
    emailController.dispose();
    passwordFocus.dispose();
    passwordController.dispose();
    super.dispose();
  }
}