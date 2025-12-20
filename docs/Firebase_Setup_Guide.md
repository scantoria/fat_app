# Firebase Setup Guide for FAT APP

This guide walks you through configuring your "FAT APP" Firebase project for the Farm Animal Tracker application.

## Prerequisites

- Firebase project "FAT APP" already created ✓
- Firebase CLI installed (`npm install -g firebase-tools`)
- Flutter installed and configured
- Node.js installed (for Firebase CLI)

## Step 1: Firebase CLI Login

```bash
firebase login
```

This will open a browser window to authenticate with your Google account.

## Step 2: Initialize Firebase in Your Project Directory

Navigate to your Flutter project directory and run:

```bash
firebase init
```

When prompted:
- Select **Firestore**, **Storage**, and **Emulators**
- Choose "Use an existing project" and select **FAT APP**
- Accept default files for Firestore rules and indexes
- Accept default file for Storage rules
- For emulators, select: **Authentication**, **Firestore**, **Storage**

## Step 3: Deploy Security Rules

Copy the provided security rules files to your project:
- `firestore.rules` → Firestore security rules
- `storage.rules` → Storage security rules
- `firestore.indexes.json` → Database indexes for optimal queries
- `firebase.json` → Firebase configuration

Deploy the rules:

```bash
firebase deploy --only firestore:rules
firebase deploy --only storage:rules
firebase deploy --only firestore:indexes
```

## Step 4: Enable Firebase Services in Console

Go to [Firebase Console](https://console.firebase.google.com) → FAT APP project:

### 4.1 Enable Authentication
1. Click **Authentication** in left sidebar
2. Click **Get Started**
3. Enable **Email/Password** provider
4. Save

### 4.2 Create Firestore Database
1. Click **Firestore Database** in left sidebar
2. Click **Create Database**
3. Choose **Production mode** (rules already deployed)
4. Select database location (choose closest to your users)
5. Click **Enable**

### 4.3 Set Up Storage
1. Click **Storage** in left sidebar
2. Click **Get Started**
3. Use default security rules (we'll deploy custom rules next)
4. Choose storage location (same as Firestore)
5. Click **Done**

### 4.4 Enable Cloud Functions (Optional - for future features)
1. Click **Functions** in left sidebar
2. Click **Get Started**
3. Follow upgrade prompts if needed (Blaze plan required for functions)

## Step 5: Flutter Firebase Integration

### 5.1 Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 5.2 Configure Flutter App

In your Flutter project directory:

```bash
flutterfire configure --project=fat-app
```

This will:
- Create `firebase_options.dart` with your project configuration
- Set up Firebase for all platforms (Web, Android, iOS)

### 5.3 Add Firebase Dependencies to pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase Core
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  
  # Offline Support
  sqflite: ^2.3.0
  path: ^1.8.3
  path_provider: ^2.1.1
  
  # Network Detection
  connectivity_plus: ^5.0.2
  
  # State Management
  provider: ^6.1.1
  
  # Other essentials
  uuid: ^4.2.2
  intl: ^0.18.1
```

Run:
```bash
flutter pub get
```

### 5.4 Initialize Firebase in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Animal Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}
```

## Step 6: Configure Firestore Offline Persistence

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> initializeFirestore() async {
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}
```

Call this in your `main()` function after Firebase initialization.

## Step 7: Test Firebase Connection

Create a simple test to verify Firebase is working:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirebaseConnection() async {
  try {
    // Test Firestore
    final docRef = FirebaseFirestore.instance
        .collection('test')
        .doc('connection_test');
    
    await docRef.set({
      'timestamp': FieldValue.serverTimestamp(),
      'message': 'Firebase connected successfully!',
    });
    
    print('✓ Firestore connected');
    
    // Test Auth
    print('✓ Firebase Auth ready');
    
    // Clean up test
    await docRef.delete();
    
  } catch (e) {
    print('✗ Firebase connection error: $e');
  }
}
```

## Step 8: Set Up Firebase Emulators (for Development)

The emulators let you develop locally without affecting production data.

```bash
firebase emulators:start
```

Access the Emulator UI at: http://localhost:4000

To use emulators in your Flutter app during development:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> connectToEmulators() async {
  // Only use in development!
  const useEmulators = true; // Set to false for production
  
  if (useEmulators) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    
    print('✓ Connected to Firebase Emulators');
  }
}
```

## Step 9: Security Rules Overview

### Firestore Rules Summary:
- **Owners**: Full access to all their farms and animals
- **Managers**: Can manage animals and providers on assigned farms
- **Leads**: Can manage animals (CRUD + records) on assigned farms
- **Farm Hands**: Read-only access to assigned farms

### Storage Rules Summary:
- **Image uploads**: 5MB limit (avatars, incident photos)
- **Document uploads**: 10MB limit (registration papers, health records)
- **File types**: Images (all formats), PDFs, Word documents
- **Organization**: Files organized by owner → farm → animal → type

## Step 10: Create Initial Test Data (Optional)

Once everything is set up, you can create test data:

```dart
Future<void> createTestData() async {
  final firestore = FirebaseFirestore.instance;
  
  // Create test owner
  await firestore.collection('owners').doc('test_owner_id').set({
    'email': 'test@farmtracker.com',
    'displayName': 'Test Owner',
    'createdAt': FieldValue.serverTimestamp(),
  });
  
  // Create test farm
  await firestore.collection('farms').doc('test_farm_id').set({
    'ownerId': 'test_owner_id',
    'farmName': 'Test Farm',
    'address': {
      'city': 'Test City',
      'state': 'Test State',
    },
    'createdAt': FieldValue.serverTimestamp(),
  });
  
  print('✓ Test data created');
}
```

## Next Steps

After Firebase is configured:

1. **Implement Authentication** - User registration and login
2. **Build Data Models** - Dart classes for all collections
3. **Create Repository Layer** - Abstract Firebase operations
4. **Implement Offline Sync** - SQLite + Firestore sync service
5. **Build UI Components** - Dashboard, animal management, etc.

## Troubleshooting

### Issue: "Firebase project not found"
- Run `firebase projects:list` to verify project name
- Ensure you're logged in: `firebase login`

### Issue: "Permission denied" errors
- Check that security rules are deployed: `firebase deploy --only firestore:rules`
- Verify user is authenticated before accessing data

### Issue: iOS build errors
- Run `cd ios && pod install` to install Firebase iOS dependencies
- Ensure minimum iOS version is 13.0+ in `ios/Podfile`

### Issue: Android build errors
- Ensure minimum SDK version is 21+ in `android/app/build.gradle`
- Add google-services.json to `android/app/`

### Issue: Web CORS errors
- Add your domain to authorized domains in Firebase Console → Authentication → Settings

## Important Security Notes

1. **Never commit** `firebase_options.dart` with sensitive keys to public repos
2. **Always use** environment variables for API keys in production
3. **Test security rules** using Firebase Emulators before deploying
4. **Review audit logs** regularly in Firebase Console
5. **Enable App Check** (future) to prevent API abuse

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)

---

**Configuration Complete!** Your Firebase "FAT APP" project is now ready for development.
