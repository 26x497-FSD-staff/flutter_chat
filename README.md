# flutter_chat

A realtime one-to-one chat app using Flutter, Firebase, Riverpod

## Getting Started

Fetch all dependencies

```bash
flutter pub get
```

Configure Firebase project on Firebase platform

1. Authentication
  - Enable `Email/Password` and `Google` Sign-in methods
2. Firestore Database
3. Storage (optional)

Run the following command to allow your project to access Firebase

```bash
firebase login
```

Create Firebase configuration

```bash
flutterfire configure
```