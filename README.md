# flutter_chat

A realtime one-to-one chat app using Flutter, Firebase, Riverpod

## Getting Started

Fetch all dependencies

```bash
flutter pub get
```

Configure Firebase project on Firebase web platform

1. Authentication
  - Enable `Email/Password` and `Google` Sign-in methods
  - For `Google` Sign-in, add SHA-1 fingerprint

Note: How to get Android finterprint
- For macOS uses the following command

```bash
keytool -list -v -alias androiddebugkey -keystore  ~/.android/debug.keystore
```

- For Windows uses

```bash
keytool -list -v -alias androiddebugkey -keystore $env:USERPROFILE\.android\debug.keystore
Enter keystore password: (android)
```

2. Firestore Database
  - Create database in `test mode`
  
3. Storage (optional)
  - This feature requires your firebase project upgraded to paid plan. 

Run the following command to allow your project to access Firebase

```bash
firebase login
```

Create Firebase configuration

```bash
flutterfire configure
```