# 🔗 Connect | Social + Professional Flutter App

**Connect** is a modern Flutter application combining social networking and professional collaboration. Users can post updates, share projects, join video conferences, and manage personal profiles — all built on Firebase with a responsive and intuitive UI.

---

## 🌟 Features

### 🔐 Authentication
- User sign-up with **unique username**
- Firebase Authentication + Firestore user records
- Profile creation and editing (name, picture, about)
- Secure login (Firebase connected)

### 📝 Home Feed
- Upload **text/image posts**
- Posts are visible to all users in a real-time feed
- Post displays user info: name and profile image

### 💼 Projects Section
- Post a project with title, description, and price
- View projects with poster info and timestamp
- (Planned) ML-based price prediction integration

### 🎥 Video Conferencing
- Join/create rooms using **Jitsi Meet SDK**
- Functionality like Google Meet
- Join via room ID, video/audio toggle available

### 👤 Profile Management
- Upload profile picture
- Edit full name and about section
- Username & user ID fixed for backend integrity

---

## 🧱 Project Structure

```
/lib
 ├─ main.dart
 └─ screens/
     ├─ login_screen.dart
     ├─ signup_screen.dart
     ├─ home_screen.dart
     ├─ projects_screen.dart
     ├─ video_conference_screen.dart
     └─ profile_screen.dart
```

---

## 🛠️ Tech Stack

- **Flutter** (Latest Stable)
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
- **Jitsi Meet SDK**
- **Material Design**
- **UUID**, **Image Picker**, etc.

---

## ⚙️ Setup Instructions

### 🔧 Prerequisites
- Flutter installed
- Firebase project created
- Android Studio / VSCode / emulator or real device

### 🔌 Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new Firebase project
3. Register Android app and download `google-services.json`
4. Place `google-services.json` inside `android/app/`
5. Enable:
   - **Email/Password** Auth
   - **Cloud Firestore**
   - **Firebase Storage**

### 📜 Firestore Rules Example:

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid != null;
    }
    match /posts/{postId} {
      allow read, write: if request.auth.uid != null;
    }
    match /projects/{projectId} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```

### 📦 Install Dependencies

```bash
flutter pub get
```

Dependencies include:
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
- `flutter_jitsi_meet`
- `image_picker`
- `uuid`

### ▶️ Run the App

```bash
flutter run
```

---

## 🔮 Future Plans

- 🔍 Project search/filter functionality
- 🤖 ML model for price prediction
- 📩 Real-time messaging or project chat
- 📢 Push notifications
- 🌐 Language/localization support

---

## 🤝 Contribution

This is an open learning project. Contributions and suggestions are welcome via PRs or issues. Feel free to fork and enhance it.


---

## 🙋‍♂️ Author

**Mohammad Saad Iqbal** & **Huzaifa Abid**
[LinkedIn](https://www.linkedin.com/in/mohammad-saad-iqbal-/) • [GitHub](https://github.com/Saad-Dev13/)
