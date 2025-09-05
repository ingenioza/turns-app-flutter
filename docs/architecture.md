# Architecture Documentation

## Overview

The Turns Flutter app follows Clean Architecture principles with a layered approach that promotes separation of concerns, testability, and maintainability.

## Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)
- **Pages**: Full-screen widgets representing app screens
- **Widgets**: Reusable UI components
- **State Management**: BLoC pattern for state management
- **Themes**: UI theming and styling

### 2. Domain Layer (`lib/domain/`)
- **Entities**: Core business objects
- **Use Cases**: Business logic operations
- **Repositories**: Abstract interfaces for data access

### 3. Data Layer (`lib/data/`)
- **Repositories**: Concrete implementations of domain repositories
- **Data Sources**: Remote API and local storage interfaces
- **Models**: Data transfer objects and serialization

### 4. Core Layer (`lib/core/`)
- **Constants**: App-wide constants
- **Errors**: Custom exceptions and error handling
- **Utils**: Utility functions and helpers
- **Network**: HTTP client configuration

## State Management

We use the **BLoC** (Business Logic Component) pattern for state management:

- **Cubits**: For simple state management
- **Blocs**: For complex state management with events
- **Repository Pattern**: For data access abstraction

## Dependency Injection

Using **GetIt** as a service locator for dependency injection:

```dart
// Core dependencies
GetIt.instance.registerLazySingleton<HttpClient>(() => HttpClient());

// Repositories
GetIt.instance.registerLazySingleton<ParticipantRepository>(
  () => ParticipantRepositoryImpl(GetIt.instance()),
);

// Use cases
GetIt.instance.registerLazySingleton<AddParticipant>(
  () => AddParticipant(GetIt.instance()),
);
```

## Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── api_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── http_client.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   └── utils/
│       └── validators.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── participant_local_datasource.dart
│   │   └── remote/
│   │       └── participant_remote_datasource.dart
│   ├── models/
│   │   ├── participant_model.dart
│   │   └── turn_model.dart
│   └── repositories/
│       └── participant_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── participant.dart
│   │   └── turn.dart
│   ├── repositories/
│   │   └── participant_repository.dart
│   └── usecases/
│       ├── add_participant.dart
│       ├── remove_participant.dart
│       └── get_next_turn.dart
├── presentation/
│   ├── bloc/
│   │   ├── participant/
│   │   │   ├── participant_bloc.dart
│   │   │   ├── participant_event.dart
│   │   │   └── participant_state.dart
│   │   └── turn/
│   │       ├── turn_cubit.dart
│   │       └── turn_state.dart
│   ├── pages/
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   ├── session/
│   │   │   ├── quick_session_page.dart
│   │   │   └── persistent_session_page.dart
│   │   └── results/
│   │       └── turn_result_page.dart
│   └── widgets/
│       ├── common/
│       │   ├── app_button.dart
│       │   └── app_text_field.dart
│       └── participant/
│           └── participant_list_item.dart
└── main.dart
```

## Key Design Patterns

1. **Repository Pattern**: Abstract data access
2. **Use Case Pattern**: Encapsulate business logic
3. **BLoC Pattern**: Predictable state management
4. **Dependency Injection**: Loose coupling between layers

## Testing Strategy

- **Unit Tests**: Test business logic (use cases, repositories)
- **Widget Tests**: Test UI components in isolation
- **Integration Tests**: Test complete user flows
- **Golden Tests**: Visual regression testing

## Dependencies

### Core Dependencies
- `flutter_bloc`: State management
- `get_it`: Dependency injection
- `dio`: HTTP client
- `hive`: Local storage
- `go_router`: Navigation

### Development Dependencies
- `flutter_test`: Testing framework
- `mockito`: Mocking for tests
- `build_runner`: Code generation
- `flutter_launcher_icons`: App icons
- `flutter_native_splash`: Splash screen

## Coding Standards

1. Follow Dart/Flutter naming conventions
2. Use meaningful variable and function names
3. Write documentation for public APIs
4. Implement proper error handling
5. Write tests for all business logic
6. Use linting rules consistently
