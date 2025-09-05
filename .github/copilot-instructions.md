# GitHub Copilot Instructions - Flutter Project

You are an expert Flutter/Dart developer working on the "Turns" app - a group turn-taking and decision-making application. This is a standalone Flutter project that will be deployed as mobile (iOS/Android) and web applications.

## Project Context

**Organization**: inGenIO (ingenioza)  
**Repository**: https://github.com/ingenioza/turns-app-flutter  
**Project Type**: Cross-platform Flutter application (Mobile + Web)

This Flutter app provides:
- **Anonymous Quick Sessions**: One-time use for fast decisions (like Spin the Wheel)
- **Persistent Groups**: Saved participants and history for ongoing use (like Kid Turns)
- **Multiple Turn Algorithms**: Random, round-robin, weighted, custom rules
- **Modern UI/UX**: Minimal, intuitive interface better than competitors
- **Cross-platform**: Native mobile apps and progressive web app

## Technology Stack & Architecture

### Core Technologies
- **Framework**: Flutter 3.24+ (latest stable)
- **Language**: Dart 3.5+
- **State Management**: BLoC (flutter_bloc) with Cubit for simple state
- **Dependency Injection**: GetIt with Injectable
- **Routing**: GoRouter for declarative navigation
- **Local Storage**: Hive for offline-first architecture
- **Network**: Dio for HTTP client with retry and caching

### Firebase Integration
- **Authentication**: Firebase Auth (Google, Apple, Email/Password)
- **Cloud Messaging**: Push notifications
- **Crashlytics**: Error reporting and analytics
- **Remote Config**: Feature flags and A/B testing
- **Analytics**: User behavior tracking

### UI/UX Technologies
- **Animations**: Flutter built-in animations + Rive for complex animations
- **Responsive Design**: flutter_screenutil for adaptive layouts
- **Icons**: Cupertino and Material icons
- **Themes**: Material 3 design system with custom theming

## Architecture Patterns

### Clean Architecture Structure
```
lib/
├── main.dart                          # App entry point
├── app/                              # App-level configuration
│   ├── app.dart                      # Main app widget
│   ├── router/                       # GoRouter configuration
│   └── theme/                        # App theming
├── core/                             # Shared utilities
│   ├── constants/                    # App constants
│   ├── error/                        # Error handling
│   ├── network/                      # API client setup
│   ├── storage/                      # Local storage
│   └── utils/                        # Helper functions
├── features/                         # Feature-based modules
│   ├── authentication/               # User auth feature
│   │   ├── data/                     # Data sources, repositories
│   │   ├── domain/                   # Entities, use cases
│   │   └── presentation/             # UI, BLoCs, pages
│   ├── groups/                       # Group management
│   ├── turns/                        # Turn algorithms and execution
│   ├── participants/                 # Participant management
│   └── history/                      # Turn history and analytics
└── shared/                           # Shared widgets and components
    ├── widgets/                      # Reusable UI components
    ├── extensions/                   # Dart extensions
    └── constants/                    # Shared constants
```

### Feature Module Structure
```
feature_name/
├── data/
│   ├── datasources/                  # Local/remote data sources
│   ├── models/                       # Data models with JSON serialization
│   └── repositories/                 # Repository implementations
├── domain/
│   ├── entities/                     # Business entities
│   ├── repositories/                 # Repository interfaces
│   └── usecases/                     # Business logic use cases
└── presentation/
    ├── bloc/                         # BLoC state management
    ├── pages/                        # Full-screen pages
    ├── widgets/                      # Feature-specific widgets
    └── utils/                        # Presentation utilities
```

## Coding Standards & Best Practices

### Dart Code Standards
- Follow **official Dart style guide**
- Use **meaningful descriptive names** (no abbreviations)
- Implement **null safety** throughout the codebase
- Use **const constructors** wherever possible
- Prefer **final** over **var** for immutable variables
- Use **late** keyword appropriately for lazy initialization

### Flutter Specific Patterns
```dart
// Widget structure
class TurnWheelWidget extends StatelessWidget {
  const TurnWheelWidget({
    super.key,
    required this.participants,
    this.onParticipantSelected,
  });

  final List<Participant> participants;
  final void Function(Participant)? onParticipantSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TurnBloc, TurnState>(
      builder: (context, state) {
        // Widget implementation
      },
    );
  }
}

// BLoC implementation
class TurnBloc extends Bloc<TurnEvent, TurnState> {
  TurnBloc({
    required this.turnRepository,
    required this.participantRepository,
  }) : super(const TurnInitial()) {
    on<ExecuteTurnEvent>(_onExecuteTurn);
    on<ResetTurnEvent>(_onResetTurn);
  }

  final TurnRepository turnRepository;
  final ParticipantRepository participantRepository;

  Future<void> _onExecuteTurn(
    ExecuteTurnEvent event,
    Emitter<TurnState> emit,
  ) async {
    emit(const TurnLoading());
    try {
      final result = await turnRepository.executeTurn(
        algorithm: event.algorithm,
        participants: event.participants,
      );
      emit(TurnSuccess(selectedParticipant: result));
    } catch (error) {
      emit(TurnFailure(message: error.toString()));
    }
  }
}
```

### State Management Patterns
- Use **BLoC** for complex state management
- Use **Cubit** for simple state changes
- Implement **proper error handling** in all BLoCs
- Use **sealed classes** for events and states
- Follow **single responsibility principle** for BLoCs

## Project-Specific Requirements

### Turn Algorithms Implementation
```dart
abstract class TurnAlgorithm {
  Participant selectNext(List<Participant> participants, TurnHistory? history);
}

class RandomTurnAlgorithm implements TurnAlgorithm {
  @override
  Participant selectNext(List<Participant> participants, TurnHistory? history) {
    // Implementation with proper randomization
  }
}

class RoundRobinTurnAlgorithm implements TurnAlgorithm {
  @override
  Participant selectNext(List<Participant> participants, TurnHistory? history) {
    // Implementation ensuring fair rotation
  }
}

class WeightedTurnAlgorithm implements TurnAlgorithm {
  @override
  Participant selectNext(List<Participant> participants, TurnHistory? history) {
    // Implementation considering participant weights
  }
}
```

### Group Management Features
- **Anonymous Groups**: Temporary groups for quick decisions
- **Persistent Groups**: Saved groups with participant history
- **Group Sharing**: Share groups via codes or links
- **Participant Management**: Add, remove, modify participants
- **Group Settings**: Customize turn algorithms and rules

### Authentication & User Management
- **Anonymous Usage**: Allow app usage without sign-in
- **Firebase Auth**: Google, Apple, email/password authentication
- **User Preferences**: Save settings and group preferences
- **Cross-device Sync**: Sync groups across user devices

## UI/UX Requirements

### Design System
- **Material 3**: Follow Material Design 3 guidelines
- **Custom Theme**: Implement inGenIO brand colors and typography
- **Dark Mode**: Full dark mode support
- **Accessibility**: WCAG compliance with semantic widgets

### Animation Requirements
```dart
// Smooth turn wheel animation
AnimationController? _wheelController;

void _spinWheel() {
  _wheelController?.forward().then((_) {
    // Handle spin completion
    _showSelectedParticipant();
  });
}

// Page transitions
GoRouter.of(context).pushNamed(
  '/group-details',
  extra: group,
  // Use slide transitions for consistency
);
```

### Responsive Design
- **Mobile First**: Optimize for mobile devices
- **Tablet Support**: Adaptive layouts for tablets
- **Web Responsive**: Progressive web app with desktop layouts
- **Safe Areas**: Handle notches and system UI properly

## Performance Requirements

### Optimization Strategies
- **Lazy Loading**: Load groups and history on demand
- **Image Optimization**: Compress and cache participant avatars
- **List Performance**: Use ListView.builder for large lists
- **Memory Management**: Proper disposal of controllers and streams

### Offline Capabilities
```dart
// Offline-first architecture with Hive
@HiveType(typeId: 0)
class Group extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String name;
  
  @HiveField(2)
  late List<Participant> participants;
  
  @HiveField(3)
  late DateTime lastUsed;
}

// Sync with backend when online
class GroupSyncService {
  Future<void> syncGroups() async {
    if (await ConnectivityService.isOnline()) {
      // Sync local changes with backend
    }
  }
}
```

## Testing Requirements

### Test Coverage Goals
- **Unit Tests**: 90%+ coverage for business logic
- **Widget Tests**: All custom widgets and pages
- **Integration Tests**: Critical user flows
- **Golden Tests**: Visual regression testing

### Testing Patterns
```dart
// BLoC testing
group('TurnBloc', () {
  late TurnBloc turnBloc;
  late MockTurnRepository mockTurnRepository;

  setUp(() {
    mockTurnRepository = MockTurnRepository();
    turnBloc = TurnBloc(turnRepository: mockTurnRepository);
  });

  blocTest<TurnBloc, TurnState>(
    'emits [TurnLoading, TurnSuccess] when ExecuteTurnEvent is added',
    build: () => turnBloc,
    act: (bloc) => bloc.add(ExecuteTurnEvent(
      algorithm: RandomTurnAlgorithm(),
      participants: mockParticipants,
    )),
    expect: () => [
      const TurnLoading(),
      isA<TurnSuccess>(),
    ],
  );
});

// Widget testing
testWidgets('TurnWheelWidget displays participants correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TurnWheelWidget(participants: mockParticipants),
    ),
  );

  expect(find.text('John'), findsOneWidget);
  expect(find.text('Jane'), findsOneWidget);
});
```

## Security & Privacy

### Data Protection
- **Local Encryption**: Encrypt sensitive data in Hive storage
- **API Security**: Implement proper authentication headers
- **Privacy First**: Minimal data collection, user consent
- **GDPR Compliance**: Data deletion and export capabilities

### Authentication Security
```dart
// Secure token storage
class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

## Development Workflow

### Git Flow
- **Feature Branches**: `feature/feature-name`
- **Bug Fixes**: `bugfix/issue-description`
- **Releases**: `release/version-number`
- **Hotfixes**: `hotfix/critical-fix`

### Code Quality Checks
- **Static Analysis**: dart analyze with custom rules
- **Code Formatting**: dart format with 80-character line limit
- **Import Sorting**: Organize imports consistently
- **Dependency Updates**: Regular dependency updates with testing

## Platform-Specific Considerations

### iOS Specific
- **App Store Guidelines**: Follow iOS design principles
- **Push Notifications**: Proper iOS notification setup
- **Privacy Manifest**: Declare data usage in privacy manifest

### Android Specific
- **Material You**: Support Android 12+ theming
- **Background Tasks**: Proper background processing
- **Permissions**: Minimal permission requests

### Web Specific
- **PWA Features**: Service worker, offline capabilities
- **SEO Optimization**: Meta tags and structured data
- **Performance**: Code splitting and lazy loading

## Code Generation Guidelines

When generating code, always:
1. **Follow Clean Architecture** with proper layer separation
2. **Implement proper error handling** with custom exceptions
3. **Add comprehensive documentation** with DartDoc comments
4. **Include null safety** and const constructors
5. **Write corresponding tests** for all business logic
6. **Use dependency injection** with GetIt
7. **Implement proper logging** for debugging
8. **Follow Material Design** guidelines for UI
9. **Consider offline functionality** in all features
10. **Optimize for performance** and memory usage

## Quality Checklist

Before suggesting code, ensure:
- [ ] Follows Clean Architecture principles
- [ ] Uses BLoC for state management
- [ ] Implements proper error handling
- [ ] Includes null safety and const constructors
- [ ] Has corresponding unit/widget tests
- [ ] Follows Dart style guidelines
- [ ] Uses dependency injection
- [ ] Implements offline-first approach
- [ ] Follows Material Design principles
- [ ] Optimizes for performance
- [ ] Includes proper documentation
- [ ] Handles edge cases appropriately

## Constraints & Limitations

- **Minimum SDK**: Flutter 3.24+, Dart 3.5+
- **Target Platforms**: iOS 12+, Android API 21+, Web (modern browsers)
- **Bundle Size**: Keep APK under 50MB, web bundle under 5MB
- **Performance**: App startup under 3 seconds, smooth 60fps animations
- **Offline Support**: Core functionality must work offline
- **Accessibility**: WCAG 2.1 AA compliance required

---

**Organization**: inGenIO - Building innovative productivity tools

## Architecture Requirements

### Follow Clean Architecture
- **Domain Layer**: Pure business logic, entities, use cases
- **Data Layer**: Repositories, data sources, models
- **Presentation Layer**: UI, state management, widgets
- **Core Layer**: Utilities, constants, theme, error handling

### Project Structure
```
lib/
├── core/           # Core utilities, constants, themes
├── data/           # Data layer (repositories, data sources)
├── domain/         # Business logic (entities, use cases)
├── presentation/   # UI layer (pages, widgets, state management)
└── main.dart       # Application entry point
```

## State Management
- Use **BLoC pattern** (flutter_bloc package)
- Use **Cubits** for simple state management
- Use **Blocs** for complex state with events
- Implement proper state management for offline/online modes

## Dependencies & Packages
Always use these approved packages:
- **State Management**: flutter_bloc, equatable
- **Dependency Injection**: get_it, injectable
- **Navigation**: go_router
- **HTTP**: dio, retrofit
- **Local Storage**: hive, shared_preferences
- **Authentication**: firebase_auth, google_sign_in
- **Notifications**: firebase_messaging
- **UI Enhancements**: flutter_animate, lottie
- **Utilities**: uuid, intl

## Coding Standards

### Dart Style
- Follow official Dart style guide
- Use meaningful, descriptive names
- Prefer composition over inheritance
- Use const constructors where possible
- Implement proper null safety

### Testing Requirements
- Write unit tests for all business logic
- Write widget tests for UI components
- Write integration tests for user flows
- Aim for 90%+ test coverage
- Use mockito for mocking dependencies

### Error Handling
- Always implement proper error handling
- Use custom exceptions for domain errors
- Handle network connectivity issues
- Provide meaningful error messages to users
- Log errors appropriately

## UI/UX Guidelines

### Design Principles
- Follow Material Design 3 guidelines
- Implement responsive design for mobile and web
- Use consistent spacing and typography
- Implement dark/light theme support
- Add smooth animations and transitions

### Accessibility
- Add semantic labels for screen readers
- Ensure sufficient color contrast
- Support large text sizes
- Implement keyboard navigation for web

### Performance
- Optimize widget rebuilds
- Use const widgets where possible
- Implement lazy loading for large lists
- Optimize images and assets
- Use proper disposal of resources

## Feature-Specific Requirements

### Participant Management
- Validate participant names (non-empty, unique)
- Support adding/removing participants
- Handle edge cases (no participants, single participant)

### Turn Algorithms
- Implement as strategy pattern
- Support: Random, Round-robin, Weighted, Custom rules
- Allow algorithm configuration
- Handle fairness tracking

### Storage & Sync
- Local storage for quick sessions
- Cloud sync for authenticated users
- Offline-first approach
- Conflict resolution for sync

### Authentication
- Support anonymous users with device ID
- OAuth integration (Google, Apple)
- Email/password authentication
- Secure token management

## Code Generation
When generating code:

1. **Always include proper imports**
2. **Add comprehensive documentation**
3. **Include error handling**
4. **Write corresponding tests**
5. **Follow the established patterns**
6. **Use dependency injection**
7. **Implement proper state management**

## Example Pattern for New Features

```dart
// 1. Domain Entity
class Participant extends Equatable {
  const Participant({required this.id, required this.name});
  // Implementation with proper validation
}

// 2. Use Case
class AddParticipant {
  const AddParticipant(this._repository);
  // Implementation with error handling
}

// 3. Repository Interface
abstract class ParticipantRepository {
  // Define contract
}

// 4. BLoC/Cubit
class ParticipantCubit extends Cubit<ParticipantState> {
  // State management implementation
}

// 5. UI Widget
class ParticipantWidget extends StatelessWidget {
  // UI implementation with proper state handling
}

// 6. Tests
class ParticipantTest {
  // Comprehensive test coverage
}
```

## Quality Checklist
Before suggesting code, ensure:
- [ ] Follows clean architecture
- [ ] Includes proper error handling
- [ ] Has corresponding tests
- [ ] Uses approved dependencies
- [ ] Follows Dart style guide
- [ ] Implements proper state management
- [ ] Includes documentation
- [ ] Handles edge cases
- [ ] Is performant and accessible

## Constraints
- Never use deprecated Flutter APIs
- Always handle null safety properly
- Don't use external packages not in the approved list
- Maintain consistency with existing code patterns
- Prioritize testability and maintainability
