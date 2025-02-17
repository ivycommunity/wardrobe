// Required imports for Firebase Authentication, Flutter widgets, and async operations
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wardobe_app/pages/login_page.dart';

/// EmailVerificationPage handles the email verification process for newly registered users
/// Displays verification status and allows users to request verification emails
class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  // Track loading state for UI updates
  bool _isLoading = false;
  // Track if verification email has been sent
  bool _emailSent = false;
  // Get reference to current Firebase user
  final user = FirebaseAuth.instance.currentUser;

  /// Sends verification email to the current user's email address
  /// Shows success/error messages via SnackBar
  Future<void> _sendVerificationEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Attempt to send verification email
      await user?.sendEmailVerification();
      setState(() {
        _emailSent = true;
      });

      // Show success message if widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Please check your inbox.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      // Show error message if sending fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending email: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Periodically checks if the user's email has been verified
  /// Redirects to login page once verification is complete
  void _startEmailVerificationCheck() {
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Reload user data to get latest verification status
      await FirebaseAuth.instance.currentUser?.reload();
      User? updatedUser = FirebaseAuth.instance.currentUser;

      // Check if email is verified
      if (updatedUser?.emailVerified ?? false) {
        timer.cancel(); // Stop checking once verified

        // Navigate to login page if widget is still mounted
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false, // Clear navigation stack
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck(); // Begin verification check when page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4E1), // Light pink background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2B3C), // Dark blue app bar
        title: const Text(
          'Email Verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email icon
              const Icon(
                Icons.email_outlined,
                size: 80,
                color: Color(0xFF1A2B3C),
              ),
              const SizedBox(height: 20),
              // Page title
              Text(
                'Verify your email',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),
              // Email instructions
              Text(
                'Send verification email to:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 5),
              // Display user's email
              Text(
                user?.email ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2B3C),
                ),
              ),
              const SizedBox(height: 30),
              // Conditional UI based on whether email has been sent
              if (!_emailSent)
                // Initial send email button with loading state
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF1A2B3C),
                    minimumSize: const Size(200, 50),
                  ),
                  onPressed: _isLoading ? null : _sendVerificationEmail,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Send Verification Email'),
                )
              else
                // Post-email-sent UI with verification options
                Column(
                  children: [
                    const Text(
                      'Email sent! Check your inbox and click the verification link.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Manual verification check button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1A2B3C),
                        minimumSize: const Size(200, 50),
                      ),
                      onPressed: _startEmailVerificationCheck,
                      child: const Text('I\'ve Verified My Email'),
                    ),
                    const SizedBox(height: 10),
                    // Resend email option
                    TextButton(
                      onPressed: _isLoading ? null : _sendVerificationEmail,
                      child: const Text('Resend Email'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}