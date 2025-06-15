You are a senior Flutter engineer and UX designer. I want to build a futuristic and interactive Flutter mobile app called **Reviseit.ai**. Its goal is to help students remember concepts using **AI-powered spaced repetition, active recall, and automatic mind maps**.

---

### 🏗️ APP REQUIREMENTS:

1. **Authentication**:
   - Use **Firebase Authentication** (Email/Password, Google sign-in).
   - Show beautiful animated login/registration UI (use futuristic glassmorphism and blur effects).

2. **Onboarding Screens**:
   - Guide user through a 3-screen walkthrough (What Reviseit does, how AI helps, how spaced repetition works).
   - Add interactive animations using **Rive** or **Lottie**.

3. **Main Functionalities**:
   - 📚 Upload concept: User can input a topic, upload resources (PDF, text, lecture links).
   - 🧠 AI creates smart notes: Use **Gemini API** to summarize, create flashcards, and generate mind maps.
   - 🗓️ Spaced Repetition Scheduler: AI generates a revision timeline (1 day, 3 days, 7 days, etc.) with recall prompts.
   - 🤖 AI Chat Assistant: Conversational chat interface (Gemini powered) for asking questions about the concept.
   - 🧩 Mind Map View: Interactive visual diagram showing concept relationships.
   - 🎯 Track Understanding: Allow users to rate their confidence after each revision round.
   - 🛠️ Integration: Export to Google Calendar, Notion (basic stubs for now).

4. **UI/UX Goals**:
   - Build a **futuristic and highly interactive UI**.
   - Use **Neumorphic / Glassmorphic** design, bright gradients, dark/light toggle, 3D transitions.
   - Use **Framer Motion-style animations**, swipe gestures, collapsible cards, and voice input.

---

### 🔧 TECHNOLOGIES TO USE:

- **Flutter + Dart**
- **Firebase Auth, Firestore, Storage**
- **Google Gemini API** (via REST or any available Dart wrapper)
- **Provider or Riverpod** for state management
- **Hive or SharedPreferences** for local user session state
- **Rive / Lottie** for animations
- **FlutterMindMapView** (or custom canvas drawing for mind map)

---

### 🧪 DEV MODE GOALS (PHASE 1):

1. Scaffold full Flutter app structure with modular clean architecture.
2. Set up Firebase for login & data storage.
3. Integrate Google Gemini API to:
   - Parse and understand uploaded text
   - Generate summaries, flashcards, mind maps in JSON
4. Show interactive mind map from API response.
5. Store user progress and show scheduled revisions.
6. Build and test AI chat experience using Gemini.
7. Include a WhatsApp-like chat UI for asking questions to Gemini agent.

---

### 📲 FUTURE INTEGRATIONS:

- Whisper/OpenAI for audio transcription
- WhatsApp Business API as an alternate front-end
- User rewards system for every revision
- Plugin SDK for browser extensions

---

### 🎯 OUTPUT:

Please generate a full Flutter app with all the folder structure, essential files, and integrations. Include:
- `pubspec.yaml` with all required dependencies
- Firebase setup files (`google-services.json`, `firebase_options.dart`)
- Sample Gemini API wrapper class
- Home screen, upload screen, chat UI, mind map widget

Use comments and best practices so other open-source contributors can easily understand and scale the app.

