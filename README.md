# Turns Flutter App

> **Organization**: inGenIO  
> **Repository**: https://github.com/ingenioza/turns  
> **Project**: Flutter mobile/web application for group turn-taking  

A Flutter application for group turn-taking and decision making, owned and maintained by **inGenIO**.

## ✅ Current Status

**Foundation Complete!** 🎉
- ✅ Clean Architecture implementation
- ✅ Firebase authentication configured (Google, Email/Password, Anonymous)
- ✅ Material 3 theming with light/dark mode
- ✅ Navigation and routing setup
- ✅ Dependency injection ready
- ✅ Network and storage services
- ✅ Testing framework configured

## Features

- **Quick Sessions**: Anonymous, one-time use for fast decisions
- **Persistent Groups**: Save participants and history for ongoing use
- **Multiple Algorithms**: Random, round-robin, weighted, and custom rules
- **Cross-platform**: Mobile (iOS/Android) and Web support
- **Modern UI**: Clean, intuitive interface with animations
- **Firebase Auth**: Google Sign-In, Email/Password, Anonymous login

## Getting Started

### Prerequisites

- Flutter 3.24+
- Dart 3.6+
- Firebase project configured
- Android Studio / Xcode for mobile development
- VS Code with Flutter extension (recommended)

### Quick Setup

1. Clone the repository:
```bash
git clone https://github.com/ingenioza/turns.git
cd turns/turns-flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code:
```bash
dart run build_runner build
```

4. Run the app:
```bash
# For development
flutter run

# For web
flutter run -d chrome

# For specific device
flutter devices
flutter run -d <device_id>
```

### Firebase Setup ✅ COMPLETED
Firebase authentication is configured with:
- Google Sign-In enabled
- Email/Password authentication enabled
- Anonymous authentication enabled
- All required configuration files imported

### Building

```bash
# Android APK
flutter build apk

# iOS (requires macOS and Xcode)
flutter build ios

# Web
flutter build web
```

## Project Structure

```
lib/
├── core/           # Core utilities, constants, themes
├── data/           # Data layer (repositories, data sources)
├── domain/         # Business logic (entities, use cases)
├── presentation/   # UI layer (pages, widgets, state management)
└── main.dart       # Application entry point

test/               # Unit and widget tests
integration_test/   # Integration tests
docs/              # Project documentation
```

## Architecture

This project follows Clean Architecture principles with a feature-first folder structure. See [Architecture Documentation](docs/architecture.md) for detailed information.

## Development Guidelines

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful commit messages following [Conventional Commits](https://www.conventionalcommits.org/)
- Write tests for all business logic and UI components
- Update documentation when adding new features

## Testing

```bash
# Run unit and widget tests
flutter test

# Run integration tests
flutter test integration_test/

# Test coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Contributing

1. Create a feature branch from `develop`
2. Make your changes
3. Add tests for new functionality
4. Ensure all tests pass
5. Create a pull request to `develop`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🏢 Organization

**inGenIO** - Building innovative productivity and collaboration tools

- **Organization**: [inGenIO GitHub](https://github.com/ingenioza)
- **Main Repository**: [turns](https://github.com/ingenioza/turns)
- **Laravel Backend**: [turns-laravel](https://github.com/ingenioza/turns-laravel)
- **Project Documentation**: See main repository for complete project overview
