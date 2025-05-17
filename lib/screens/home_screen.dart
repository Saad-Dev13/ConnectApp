import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'projects_screen.dart';
import 'video_conference_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _createPost() async {
    TextEditingController postController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a Post'),
          content: TextField(
            controller: postController,
            decoration: const InputDecoration(hintText: 'What’s on your mind?'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (postController.text.isNotEmpty) {
                  try {
                    // Add post to Firestore
                    await FirebaseFirestore.instance.collection('posts').add({
                      'text': postController.text.trim(),
                      'timestamp': FieldValue.serverTimestamp(),
                      'username':
                          FirebaseAuth
                              .instance
                              .currentUser!
                              .email, // Replace with username if stored
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Post created successfully!"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Post cannot be empty!")),
                  );
                }
              },
              child: const Text('Post'),
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
        title: const Text(
          "Connect App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false, // Hide the back button
        backgroundColor: const Color(0xFF2E7D32), // Dark green
      ),
      body:
          _selectedIndex == 0
              ? _buildHomeFeed()
              : _selectedIndex == 1
              ? const ProjectsScreen()
              : _selectedIndex == 2
              ? const VideoConferenceScreen()
              : const ProfileScreen(),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2E7D32), // Dark green
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.white : Colors.white70,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                Icons.business,
                color: _selectedIndex == 1 ? Colors.white : Colors.white70,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: Icon(
                Icons.video_call,
                color: _selectedIndex == 2 ? Colors.white : Colors.white70,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 3 ? Colors.white : Colors.white70,
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed: _createPost,
                backgroundColor: const Color(0xFF4CAF50), // Green button
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildHomeFeed() {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('posts')
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error loading posts. Please try again later.',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1B5E20), // Dark green text
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No posts yet. Be the first to post something!',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF1B5E20), // Dark green text
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var post = snapshot.data!.docs[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  post['text'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20), // Dark green text
                  ),
                ),
                subtitle: Text(
                  'Posted by ${post['username']}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
