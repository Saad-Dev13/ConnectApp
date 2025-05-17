import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "User Name";
  String about = "This is the user about section.";
  String profilePictureUrl =
      "https://via.placeholder.com/150"; // Placeholder image

  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController profilePictureController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.email!;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        // If the document exists, load the data
        setState(() {
          name = userDoc['name'] ?? "User Name";
          about = userDoc['about'] ?? "This is the user about section.";
          profilePictureUrl =
              userDoc['picture'] ?? "https://via.placeholder.com/150";
          nameController.text = name;
          aboutController.text = about;
          profilePictureController.text = profilePictureUrl;
        });
      } else {
        // If the document does not exist, initialize it with default values
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'name': "User Name",
          'about': "This is the user about section.",
          'picture': "https://via.placeholder.com/150",
        });

        setState(() {
          name = "User Name";
          about = "This is the user about section.";
          profilePictureUrl = "https://via.placeholder.com/150";
          nameController.text = name;
          aboutController.text = about;
          profilePictureController.text = profilePictureUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading profile: $e")));
    }
  }

  Future<void> _updateProfile() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.email!;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': nameController.text.trim(),
        'about': aboutController.text.trim(),
        'picture': profilePictureController.text.trim(),
      });

      setState(() {
        name = nameController.text.trim();
        about = aboutController.text.trim();
        profilePictureUrl = profilePictureController.text.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32), // Dark green
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(profilePictureUrl),
                backgroundColor: const Color(
                  0xFF81C784,
                ), // Light green background
              ),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20), // Dark green text
                ),
              ),
              const SizedBox(height: 10),
              Text(
                about,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _showEditProfileDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50), // Green button
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFFD32F2F,
                  ), // Red button for logout
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: aboutController,
                  decoration: const InputDecoration(labelText: "About"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: profilePictureController,
                  decoration: const InputDecoration(
                    labelText: "Profile Picture URL",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _updateProfile();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
