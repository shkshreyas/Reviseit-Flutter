import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:reviseitai/firebase_options.dart';

class FirebaseInit {
  static Future<void> initialize() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint('Firebase initialized successfully');
      } else {
        debugPrint('Firebase already initialized');
      }
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      // Don't rethrow the error, just log it
      // This allows the app to continue even if Firebase fails
    }
  }
}
