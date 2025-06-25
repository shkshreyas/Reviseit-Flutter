class AppConstants {
  // Load from .env file in production
  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', 
      defaultValue: 'AIzaSyDLhgDvA7MkNsNYk7P4_NCgmtVPoxnY1eQ');
  static const String geminiApiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  
  // App constants
  static const String appName = 'ReviseIt.AI';
  static const String appTagline = 'AI-powered learning revolution';
  
  // Spaced repetition intervals (in days)
  static const List<int> spacedRepetitionIntervals = [1, 3, 7, 14, 30];
}
