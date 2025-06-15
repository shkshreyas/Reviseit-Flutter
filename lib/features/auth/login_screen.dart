import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reviseitai/core/theme/app_theme.dart';
import 'package:reviseitai/widgets/common/glassmorphic_container.dart';
import 'package:reviseitai/widgets/common/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // TODO: Implement Firebase authentication
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
      // Navigate to home screen
    });
  }

  void _signInWithGoogle() {
    // TODO: Implement Google Sign-In
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.colorScheme.background, theme.colorScheme.surface],
          ),
        ),
        child: Stack(
          children: [
            // Background patterns
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -50,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.secondary.withOpacity(0.15),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Logo and title
                    Center(
                      child: Image.asset(
                        'assets/icon.png',
                        width: 80,
                        height: 80,
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),

                    const SizedBox(height: 24),

                    Text(
                          'Reviseit.ai',
                          style: theme.textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 8),

                    Text(
                      'AI-powered learning, reimagined',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 600.ms, delay: 400.ms),

                    const SizedBox(height: 60),

                    // Login form
                    GlassmorphicContainer(
                      borderRadius: 24,
                      blur: 10,
                      border: 1.5,
                      opacity: 0.1,
                      gradientColors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      child: Container(
                        width: size.width - 48,
                        height: 360,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: theme.textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 24),

                            // Email field
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.7),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                labelStyle: TextStyle(
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.7),
                                ),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 8),

                            // Forgot password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Login button
                            _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : GradientButton(
                                    text: 'Login',
                                    onPressed: _login,
                                  ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Or continue with
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.2,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or continue with',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onBackground.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Google sign in button
                    Center(
                      child: TextButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: Image.asset(
                          'assets/google_logo.png',
                          width: 24,
                          height: 24,
                        ),
                        label: Text(
                          'Sign in with Google',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onBackground.withOpacity(
                              0.7,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to sign up screen
                          },
                          child: Text(
                            'Sign Up',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
