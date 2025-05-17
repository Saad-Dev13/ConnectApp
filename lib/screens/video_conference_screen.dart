import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class VideoConferenceScreen extends StatefulWidget {
  const VideoConferenceScreen({super.key});

  @override
  _VideoConferenceScreenState createState() => _VideoConferenceScreenState();
}

class _VideoConferenceScreenState extends State<VideoConferenceScreen> {
  final TextEditingController roomController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  void _joinMeeting() async {
    if (roomController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room ID and Name are required!")),
      );
      return;
    }

    try {
      var options =
          JitsiMeetingOptions(room: roomController.text.trim())
            ..userDisplayName = nameController.text.trim()
            ..audioMuted = false
            ..videoMuted = false;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Conference",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32), // Dark green
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Join or Create a Video Conference',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20), // Dark green text
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: roomController,
              decoration: InputDecoration(
                labelText: 'Room ID',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _joinMeeting,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Green button
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Join Meeting',
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
    );
  }
}
