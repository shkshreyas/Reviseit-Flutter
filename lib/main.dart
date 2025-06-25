import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reviseitai/core/theme/app_theme.dart';
import 'package:reviseitai/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:reviseitai/features/home/presentation/screens/home_screen.dart';
import 'package:reviseitai/core/firebase/firebase_init.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (optional)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Could not load .env file: $e');
  }

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await FirebaseInit.initialize();

  runApp(
    const ProviderScope(
      child: ReviseItApp(),
    ),
  );
}

class ReviseItApp extends StatelessWidget {
  const ReviseItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReviseIt.AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _startPeriodicAuthCheck();
  }

  void _startPeriodicAuthCheck() {
    // Check auth state every 2 seconds for debugging
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final currentUser = FirebaseAuth.instance.currentUser;
        debugPrint('Periodic auth check - Current user: ${currentUser?.email ?? 'null'}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking authentication...'),
                ],
              ),
            ),
          );
        }
        
        // Handle errors
        if (snapshot.hasError) {
          debugPrint('Auth state error: ${snapshot.error}');
          // On error, show onboarding screen
          return const OnboardingScreen();
        }
        
        // Check if user is signed in
        if (snapshot.hasData && snapshot.data != null) {
          debugPrint('User is signed in: ${snapshot.data!.email}');
          // User is signed in, go to home screen
          return HomeScreen();
        } else {
          debugPrint('User is not signed in');
          // User is not signed in, go to onboarding
          return const OnboardingScreen();
        }
      },
    );
  }
}
