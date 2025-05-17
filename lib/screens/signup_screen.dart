import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  SignupScreen({super.key});

  Future<void> _showMessageDialog(
    BuildContext context,
    String title,
    String message, {
    bool redirectToLogin = false,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (redirectToLogin) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: const Color(0xFF2E7D32), // Dark green
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Create an Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20), // Dark green text
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Create user in Firebase Authentication
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                  // Save user data in Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(
                        usernameController.text.trim(),
                      ) // Use username as primary key
                      .set({
                        'email': emailController.text.trim(),
                        'username': usernameController.text.trim(),
                        'name': '',
                        'picture': '',
                        'about': '',
                      });

                  // Show success message with redirection to login
                  await _showMessageDialog(
                    context,
                    "Signup Successful",
                    "Your account has been created successfully!",
                    redirectToLogin: true,
                  );
                } on FirebaseAuthException catch (e) {
                  String errorMessage;
                  if (e.code == 'email-already-in-use') {
                    errorMessage =
                        "This email is already in use. Please try another.";
                  } else if (e.code == 'weak-password') {
                    errorMessage =
                        "The password is too weak. Please choose a stronger password.";
                  } else {
                    errorMessage = "An error occurred. Please try again.";
                  }

                  // Show custom error message
                  await _showMessageDialog(
                    context,
                    "Signup Failed",
                    errorMessage,
                  );
                } catch (e) {
                  // Show generic error message
                  await _showMessageDialog(
                    context,
                    "Signup Failed",
                    "An unexpected error occurred. Please try again.",
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Green button
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate back to Login Screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(color: Color(0xFF1B5E20)), // Dark green text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
