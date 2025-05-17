import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAEjz7b_xHbQYam6x-SQmI8olP2143lHxE",
      authDomain: "connect-8d4be.firebaseapp.com",
      projectId: "connect-8d4be",
      storageBucket: "connect-8d4be.firebasestorage.app",
      messagingSenderId: "1095152723912",
      appId: "1:1095152723912:web:0f0db7e91afed7ad51c2fd",
      measurementId: "G-31NJHFP408",
    ),
  );
  runApp(const ConnectApp());
}

class ConnectApp extends StatelessWidget {
  const ConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removed the debug badge
      title: 'Connect Application',
      theme: ThemeData(
        primarySwatch: Colors.green, // Professional green theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(
          0xFFE8F5E9,
        ), // Light green background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32), // Dark green for app bar
          elevation: 4.0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1B5E20)), // Dark green text
          bodyMedium: TextStyle(color: Color(0xFF1B5E20)),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF4CAF50), // Green buttons
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CAF50), // Green buttons
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
