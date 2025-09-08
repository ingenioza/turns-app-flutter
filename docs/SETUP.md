# Turns Flutter App - Setup Guide

## 🚀 Quick Start

The Turns Flutter application is built with Clean Architecture, BLoC pattern, and modern Flutter best practices.

## ✅ Prerequisites

- Flutter 3.24+ 
- Dart 3.6+
- Firebase project configured
- Android Studio / VS Code

## 🔧 Development Setup

### 1. Install Dependencies
```bash
cd turns-flutter
flutter pub get
```

### 2. Generate Code
```bash
dart run build_runner build
```

### 3. Firebase Configuration ✅ COMPLETED
Firebase has been successfully configured with:
- **Google Sign-In**: Enabled
- **Email/Password Authentication**: Enabled  
- **Anonymous Authentication**: Enabled
- **Project Files**: GoogleService-Info.plist (iOS) and google-services.json (Android) imported

The app includes graceful Firebase initialization that handles missing configuration files in development environments.

### 4. Run the Application
```bash
# Development
flutter run

# Debug on specific device
flutter run -d chrome  # Web
flutter run -d ios     # iOS Simulator
flutter run -d android # Android Emulator
```

## 🏗️ Architecture Overview

### Clean Architecture Structure
```
lib/
├── core/               # Core utilities, constants, DI
│   ├── constants/      # App constants and configuration
│   ├── error/          # Error handling and failure types
│   ├── injection/      # Dependency injection setup
│   ├── network/        # HTTP client and API services
│   ├── storage/        # Local storage services
│   ├── theme/          # App theming and colors
│   └── usecases/       # Base use case patterns
├── data/               # Data layer (repositories, models)
├── domain/             # Domain layer (entities, use cases)
│   └── entities/       # Core business entities
└── presentation/       # UI layer (pages, widgets, BLoC)
    ├── app/           # App configuration
    ├── pages/         # Application screens
    └── routes/        # Navigation configuration
```

### Key Features Implemented
- ✅ **Material 3 Theming**: Light/dark mode support
- ✅ **Navigation**: GoRouter for declarative routing
- ✅ **State Management**: BLoC pattern ready
- ✅ **Dependency Injection**: GetIt + Injectable
- ✅ **Network Layer**: Dio with error handling
- ✅ **Local Storage**: SharedPreferences wrapper
- ✅ **Firebase Integration**: Auth, messaging ready
- ✅ **Testing**: Widget and unit test framework

## 🧪 Testing

### Run Tests
```bash
# All tests
flutter test

# Coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Test Structure
- **Widget Tests**: UI component testing
- **Unit Tests**: Business logic testing
- **Integration Tests**: End-to-end testing

## 📦 Key Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `go_router`: Navigation
- `get_it` + `injectable`: Dependency injection
- `dio`: HTTP client
- `dartz`: Functional programming

### Firebase
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `firebase_messaging`: Push notifications

### Development
- `build_runner`: Code generation
- `mockito`: Testing mocks
- `very_good_analysis`: Linting rules

## 🔄 Development Workflow

### 1. Code Generation
When adding new injectable services or data models:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Adding New Features
1. Create domain entities in `domain/entities/`
2. Define use cases in `domain/usecases/`
3. Implement repositories in `data/repositories/`
4. Build UI in `presentation/pages/`
5. Add tests for all layers

### 3. State Management
Use BLoC pattern for complex state:
```dart
// Create BLoC
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  // Implementation
}

// Provide BLoC
BlocProvider(
  create: (_) => getIt<FeatureBloc>(),
  child: FeaturePage(),
)

// Use BLoC
BlocBuilder<FeatureBloc, FeatureState>(
  builder: (context, state) {
    // Build UI based on state
  },
)
```

## 🚨 Troubleshooting

### Common Issues

**Firebase initialization fails:**
- Ensure GoogleService-Info.plist (iOS) and google-services.json (Android) are properly added
- The app gracefully handles missing Firebase config in development

**Build runner fails:**
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**Dependency injection errors:**
- Check `@injectable` annotations
- Verify modules are properly configured
- Run code generation after changes

## 📱 Platform Support

- ✅ **iOS**: iPhone and iPad
- ✅ **Android**: API level 21+
- ✅ **Web**: Modern browsers
- 🚧 **Desktop**: Planned (Windows, macOS, Linux)

## 🔗 Related Documentation

- [Architecture Guide](./architecture.md)
- [Libraries Documentation](./libraries.md)
- [Testing Guide](./testing.md)

## 📊 Current Status

✅ **Foundation Complete**: Clean Architecture, DI, theming
✅ **Firebase Setup**: Authentication methods configured
✅ **Navigation**: GoRouter with splash and home pages
✅ **Testing**: Basic test framework in place
🔄 **Next**: Backend API integration and authentication flow
