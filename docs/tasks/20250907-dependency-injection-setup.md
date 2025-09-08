# Task: Complete Dependency Injection Setup

**Date**: 2025-09-07  
**Branch**: `feature/dependency-injection-setup`  
**Epic**: Core MVP Infrastructure  

## Scope
Complete the dependency injection setup to make the app fully functional and runnable.

## Acceptance Criteria
- [x] Repository module created with proper @injectable annotations
- [ ] Use cases properly registered in DI container
- [ ] BLoCs registered and accessible via GetIt
- [ ] App wrapper provides BLoCs to widget tree
- [ ] Code generation runs successfully
- [ ] App starts without DI errors
- [ ] Turn wheel functionality works end-to-end

## Touchpoints
- `lib/core/injection/` - DI configuration
- `lib/presentation/app/app.dart` - BLoC providers
- `lib/main.dart` - DI initialization
- `pubspec.yaml` - build_runner dependencies

## Tests Required
- [ ] Unit tests for repositories and use cases
- [ ] Widget tests for HomePage with mocked BLoCs
- [ ] Integration test for complete turn flow

## Implementation Plan
1. Add @injectable annotations to use cases
2. Run build_runner to generate DI code
3. Update app.dart to provide BLoCs
4. Test app startup and basic functionality
5. Fix any DI-related issues
6. Validate complete turn execution flow
