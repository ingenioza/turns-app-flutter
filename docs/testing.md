# Testing Strategy

## Testing Philosophy

We follow a comprehensive testing strategy that ensures 95%+ code coverage and maintains high code quality through automated testing at multiple levels.

## Testing Pyramid

```
    ┌─────────────┐
    │ Integration │ ← End-to-end user flows
    │    Tests    │
    ├─────────────┤
    │   Widget    │ ← UI component testing
    │    Tests    │  
    ├─────────────┤
    │    Unit     │ ← Business logic testing
    │    Tests    │   (Largest layer)
    └─────────────┘
```

## Test Structure

```
test/
├── unit/                             # Unit tests (70% of tests)
│   ├── domain/                       # Use cases and entities
│   ├── data/                         # Repositories and data sources
│   ├── core/                         # Utilities and helpers
│   └── features/                     # Feature-specific logic
├── widget/                           # Widget tests (20% of tests)
│   ├── pages/                        # Full page widgets
│   ├── components/                   # Reusable components
│   └── common/                       # Shared widgets
├── integration/                      # Integration tests (10% of tests)
│   ├── flows/                        # Complete user flows
│   └── api/                          # API integration tests
├── helpers/                          # Test utilities
│   ├── mocks/                        # Mock objects
│   ├── fixtures/                     # Test data
│   └── pump_app.dart                 # Test app wrapper
└── golden/                           # Golden image tests
    ├── update_goldens.dart           # Golden test updater
    └── failures/                     # Failed golden comparisons
```

## Unit Testing

### Repository Testing

```dart
group('GroupRepository', () {
  late GroupRepositoryImpl repository;
  late MockGroupRemoteDataSource mockRemoteDataSource;
  late MockGroupLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockGroupRemoteDataSource();
    mockLocalDataSource = MockGroupLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = GroupRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getGroups', () {
    test('should return groups from remote when device is online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getGroups())
          .thenAnswer((_) async => tGroupModelList);
      when(() => mockLocalDataSource.cacheGroups(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getGroups();

      // Assert
      verify(() => mockRemoteDataSource.getGroups());
      verify(() => mockLocalDataSource.cacheGroups(tGroupModelList));
      expect(result, equals(Right(tGroupList)));
    });

    test('should return cached groups when device is offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getLastGroups())
          .thenAnswer((_) async => tGroupModelList);

      // Act
      final result = await repository.getGroups();

      // Assert
      verifyNever(() => mockRemoteDataSource.getGroups());
      verify(() => mockLocalDataSource.getLastGroups());
      expect(result, equals(Right(tGroupList)));
    });
  });
});
```

### BLoC Testing

```dart
group('TurnBloc', () {
  late TurnBloc turnBloc;
  late MockExecuteTurnUseCase mockExecuteTurn;
  late MockGetTurnHistoryUseCase mockGetTurnHistory;

  setUp(() {
    mockExecuteTurn = MockExecuteTurnUseCase();
    mockGetTurnHistory = MockGetTurnHistoryUseCase();
    turnBloc = TurnBloc(
      executeTurn: mockExecuteTurn,
      getTurnHistory: mockGetTurnHistory,
    );
  });

  test('initial state should be TurnInitial', () {
    expect(turnBloc.state, equals(TurnInitial()));
  });

  blocTest<TurnBloc, TurnState>(
    'emits [TurnLoading, TurnSuccess] when ExecuteTurnEvent is added and succeeds',
    build: () {
      when(() => mockExecuteTurn(any()))
          .thenAnswer((_) async => Right(tTurn));
      return turnBloc;
    },
    act: (bloc) => bloc.add(ExecuteTurnEvent(
      groupId: tGroupId,
      algorithm: TurnAlgorithmType.random,
    )),
    expect: () => [
      TurnLoading(),
      TurnSuccess(turn: tTurn),
    ],
  );

  blocTest<TurnBloc, TurnState>(
    'emits [TurnLoading, TurnFailure] when ExecuteTurnEvent is added and fails',
    build: () {
      when(() => mockExecuteTurn(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      return turnBloc;
    },
    act: (bloc) => bloc.add(ExecuteTurnEvent(
      groupId: tGroupId,
      algorithm: TurnAlgorithmType.random,
    )),
    expect: () => [
      TurnLoading(),
      TurnFailure(message: 'Server error occurred'),
    ],
  );
});
```

### Use Case Testing

```dart
group('ExecuteTurnUseCase', () {
  late ExecuteTurnUseCase useCase;
  late MockTurnRepository mockRepository;

  setUp(() {
    mockRepository = MockTurnRepository();
    useCase = ExecuteTurnUseCase(mockRepository);
  });

  test('should execute turn and return selected participant', () async {
    // Arrange
    when(() => mockRepository.executeTurn(
      groupId: any(named: 'groupId'),
      algorithm: any(named: 'algorithm'),
    )).thenAnswer((_) async => Right(tTurn));

    // Act
    final result = await useCase(Params(
      groupId: tGroupId,
      algorithm: TurnAlgorithmType.random,
    ));

    // Assert
    expect(result, Right(tTurn));
    verify(() => mockRepository.executeTurn(
      groupId: tGroupId,
      algorithm: TurnAlgorithmType.random,
    ));
    verifyNoMoreInteractions(mockRepository);
  });
});
```

## Widget Testing

### Page Testing

```dart
group('GroupDetailsPage', () {
  late MockGroupBloc mockGroupBloc;

  setUp(() {
    mockGroupBloc = MockGroupBloc();
  });

  testWidgets('should display group details when loaded', (tester) async {
    // Arrange
    const groupState = GroupLoaded(group: tGroup);
    when(() => mockGroupBloc.state).thenReturn(groupState);

    // Act
    await tester.pumpApp(
      BlocProvider<GroupBloc>.value(
        value: mockGroupBloc,
        child: const GroupDetailsPage(groupId: tGroupId),
      ),
    );

    // Assert
    expect(find.text(tGroup.name), findsOneWidget);
    expect(find.text('${tGroup.participants.length} participants'), findsOneWidget);
    expect(find.byType(ParticipantList), findsOneWidget);
  });

  testWidgets('should display loading indicator when loading', (tester) async {
    // Arrange
    when(() => mockGroupBloc.state).thenReturn(GroupLoading());

    // Act
    await tester.pumpApp(
      BlocProvider<GroupBloc>.value(
        value: mockGroupBloc,
        child: const GroupDetailsPage(groupId: tGroupId),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
});
```

### Component Testing

```dart
group('TurnWheelWidget', () {
  testWidgets('should display all participants', (tester) async {
    // Arrange
    final participants = [
      Participant(id: '1', name: 'Alice'),
      Participant(id: '2', name: 'Bob'),
      Participant(id: '3', name: 'Charlie'),
    ];

    // Act
    await tester.pumpApp(
      TurnWheelWidget(participants: participants),
    );

    // Assert
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    expect(find.text('Charlie'), findsOneWidget);
  });

  testWidgets('should trigger spin animation on tap', (tester) async {
    // Arrange
    bool spinCalled = false;
    final participants = [Participant(id: '1', name: 'Alice')];

    // Act
    await tester.pumpApp(
      TurnWheelWidget(
        participants: participants,
        onSpin: () => spinCalled = true,
      ),
    );
    
    await tester.tap(find.byType(TurnWheelWidget));
    await tester.pump();

    // Assert
    expect(spinCalled, isTrue);
  });
});
```

## Integration Testing

### User Flow Testing

```dart
group('Turn execution flow', () {
  testWidgets('complete turn execution journey', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to create group
    await tester.tap(find.text('Create Group'));
    await tester.pumpAndSettle();

    // Fill group details
    await tester.enterText(find.byKey(Key('group_name_field')), 'Test Group');
    await tester.tap(find.text('Add Participant'));
    await tester.enterText(find.byKey(Key('participant_name_field')), 'Alice');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Add second participant
    await tester.tap(find.text('Add Participant'));
    await tester.enterText(find.byKey(Key('participant_name_field')), 'Bob');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Create group
    await tester.tap(find.text('Create Group'));
    await tester.pumpAndSettle();

    // Execute turn
    await tester.tap(find.text('Execute Turn'));
    await tester.pumpAndSettle();

    // Verify result
    expect(find.text('Selected:'), findsOneWidget);
    expect(find.textContaining(RegExp(r'Alice|Bob')), findsOneWidget);
  });
});
```

## Golden Testing

### Visual Regression Testing

```dart
group('Golden tests', () {
  testWidgets('GroupCard golden test', (tester) async {
    await tester.pumpApp(
      GroupCard(group: tGroup),
    );

    await expectLater(
      find.byType(GroupCard),
      matchesGoldenFile('group_card.png'),
    );
  });

  testWidgets('TurnWheelWidget golden test', (tester) async {
    await tester.pumpApp(
      TurnWheelWidget(participants: tParticipants),
    );

    await expectLater(
      find.byType(TurnWheelWidget),
      matchesGoldenFile('turn_wheel.png'),
    );
  });
});
```

## Test Utilities

### Mock Setup

```dart
// test/helpers/mocks.dart
@GenerateMocks([
  GroupRepository,
  TurnRepository,
  ParticipantRepository,
  GroupRemoteDataSource,
  GroupLocalDataSource,
  NetworkInfo,
  ExecuteTurnUseCase,
  GetGroupsUseCase,
])
void main() {}
```

### Test App Wrapper

```dart
// test/helpers/pump_app.dart
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        home: widget,
        theme: AppTheme.lightTheme,
      ),
    );
  }

  Future<void> pumpAppWithRouter(Widget widget) {
    return pumpWidget(
      MaterialApp.router(
        routerConfig: testRouter,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
```

### Test Fixtures

```dart
// test/helpers/fixtures.dart
const tGroupId = 'test-group-id';
const tParticipantId = 'test-participant-id';

final tGroup = Group(
  id: tGroupId,
  name: 'Test Group',
  participants: [
    Participant(id: tParticipantId, name: 'Alice'),
    Participant(id: '2', name: 'Bob'),
  ],
  createdAt: DateTime.parse('2025-01-01'),
);

final tTurn = Turn(
  id: 'test-turn-id',
  groupId: tGroupId,
  selectedParticipant: tGroup.participants.first,
  algorithm: TurnAlgorithmType.random,
  executedAt: DateTime.now(),
);
```

## Coverage Requirements

### Coverage Goals
- **Overall**: 95% line coverage
- **Unit Tests**: 98% coverage for business logic
- **Widget Tests**: 90% coverage for UI components
- **Integration Tests**: Critical user flows covered

### Coverage Commands

```bash
# Generate coverage report
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html
```

## Continuous Integration

### GitHub Actions Test Workflow

```yaml
name: Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

## Performance Testing

### Widget Performance Tests

```dart
testWidgets('TurnWheelWidget performance test', (tester) async {
  final stopwatch = Stopwatch()..start();
  
  await tester.pumpApp(
    TurnWheelWidget(participants: largeparticipantList),
  );
  
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
});
```

This comprehensive testing strategy ensures high code quality, reliability, and maintainability of the Flutter application.
