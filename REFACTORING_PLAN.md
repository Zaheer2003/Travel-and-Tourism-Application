# Travel & Tourism App - Architecture Refactoring Plan

## Current Architecture Issues
- Provider-based state management (simple but limited)
- Flat folder structure (models, screens, services, widgets)
- Tightly coupled components
- Difficult to scale and test

## Target Architecture

### 1. Feature-Based Folder Structure
```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── destinations/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── hotels/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── bookings/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

### 2. State Management Migration (Provider → Riverpod)

**Benefits of Riverpod:**
- Compile-time safety
- Better testability
- No BuildContext dependency
- Improved performance
- Family and autoDispose modifiers

**Key Changes:**
- Replace `ChangeNotifierProvider` with Riverpod providers
- Use `StateNotifier` for complex state
- Implement `FutureProvider` and `StreamProvider` for async data
- Add `ref.watch()` and `ref.read()` instead of `Provider.of()`

### 3. Implementation Steps

#### Phase 1: Setup & Core (Priority: High)
1. Add Riverpod dependencies
2. Create core folder structure
3. Move theme to core
4. Create base providers

#### Phase 2: Auth Feature (Priority: High)
1. Create auth feature structure
2. Migrate AuthService to repository pattern
3. Create auth providers
4. Update login screen

#### Phase 3: Destinations Feature (Priority: High)
1. Create destinations feature structure
2. Migrate destination models and services
3. Create destination providers
4. Update home and explore screens

#### Phase 4: Hotels Feature (Priority: Medium)
1. Create hotels feature structure
2. Migrate hotel models and services
3. Create hotel providers
4. Update hotel screens

#### Phase 5: Bookings Feature (Priority: Medium)
1. Create bookings feature structure
2. Migrate booking models and services
3. Create booking providers
4. Update bookings screen

#### Phase 6: Profile Feature (Priority: Low)
1. Create profile feature structure
2. Migrate profile-related code
3. Create profile providers
4. Update profile and settings screens

#### Phase 7: Testing & Cleanup (Priority: Low)
1. Remove old provider code
2. Clean up unused files
3. Add unit tests
4. Update documentation

## Estimated Timeline
- Phase 1-2: 2-3 hours
- Phase 3-4: 3-4 hours
- Phase 5-6: 2-3 hours
- Phase 7: 1-2 hours
**Total: 8-12 hours**

## Breaking Changes
- All `Provider.of<T>(context)` → `ref.watch(providerName)`
- `ChangeNotifierProvider` → `StateNotifierProvider`
- Import paths will change significantly
- Main.dart will need ProviderScope wrapper

## Next Steps
1. Get user approval for refactoring
2. Create backup branch
3. Start with Phase 1
4. Implement incrementally to avoid breaking the app
