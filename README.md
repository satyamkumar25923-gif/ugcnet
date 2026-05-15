# NET Prep Master - UGC NET Preparation App

A modern, clean, and accessible Flutter application designed for UGC NET aspirants.

## Features
- **Mock Test Simulation**: Real exam (CBT) interface with a 3-hour timer.
- **Question Palette**: Quick navigation and tracking of answered/unanswered questions.
- **Result Analysis**: Detailed score breakdown with performance charts.
- **Wrong Answer Review**: In-depth explanations for every question.
- **Subject Selection**: Paper 1 and Paper 2 (Education) support.
- **Minimal Modern UI**: Designed for easy readability and middle-aged users.

## Tech Stack
- **Flutter**: Frontend framework.
- **Provider**: State management.
- **Firebase**: Backend for questions and authentication (Setup required).
- **FL Chart**: For performance analytics.

## Getting Started

### 1. Prerequisites
- Flutter SDK (>= 3.0.0)
- Android Studio / VS Code

### 2. Setup
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Connect your Firebase project:
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Enable Authentication (Email/Password).
   - Set up Firestore and upload questions using the schema in `assets/data/dummy_questions.json`.

### 3. Running the App
```bash
flutter run
```

## Directory Structure
- `lib/core`: Themes and constants.
- `lib/data`: Models and local/remote data sources.
- `lib/providers`: State management logic.
- `lib/presentation`: UI screens and custom widgets.
- `assets/data`: Local JSON fallback for offline practice.

## License
MIT
