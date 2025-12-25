# Travel & Tourism App - Riverpod & Feature-Based Architecture Migration Guide

## 📋 Overview

This guide outlines the complete migration from Provider to Riverpod with a feature-based folder structure.

## 🎯 Goals

1. **Better State Management**: Migrate from Provider to Riverpod
2. **Scalable Architecture**: Implement feature-based folder structure
3. **Clean Code**: Separate concerns (data, domain, presentation)
4. **Testability**: Make code easier to unit test
5. **Type Safety**: Leverage Riverpod's compile-time safety

## 📁 New Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_provider.dart (Riverpod)
│   ├── utils/
│   │   ├── extensions.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── loading_widget.dart
│       └── error_widget.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── datasources/
│   │   │       └── auth_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_interface.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── auth_provider.dart
│   │       │   └── auth_state_provider.dart
│   │       ├── screens/
│   │       │   └── login_screen.dart
│   │       └── widgets/
│   │           ├── google_sign_in_button.dart
│   │           └── guest_login_button.dart
│   │
│   ├── destinations/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── destination_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── destination_repository.dart
│   │   │   └── datasources/
│   │   │       └── destination_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── destination_entity.dart
│   │   │   └── repositories/
│   │   │       └── destination_repository_interface.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── destinations_provider.dart
│   │       │   └── destination_detail_provider.dart
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   ├── explore_screen.dart
│   │       │   └── detail_screen.dart
│   │       └── widgets/
│   │           └── destination_card.dart
│   │
│   ├── hotels/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── bookings/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

## 🔄 Migration Steps

### Step 1: Update Dependencies ✅ DONE

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.13
  riverpod_generator: ^2.6.2
  freezed: ^2.5.7
  json_serializable: ^6.8.0
```

### Step 2: Update main.dart

**Before (Provider):**
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TravelApp(),
    ),
  );
}
```

**After (Riverpod):**
```dart
void main() {
  runApp(
    const ProviderScope(
      child: TravelApp(),
    ),
  );
}
```

### Step 3: Migrate Theme Provider

**Before:**
```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
```

**After:**
```dart
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  bool build() => false;
  
  void toggleTheme() {
    state = !state;
  }
}

// Usage in widgets
final isDarkMode = ref.watch(themeNotifierProvider);
```

### Step 4: Create Repository Pattern

**Example: Auth Repository**
```dart
// Interface
abstract class IAuthRepository {
  Future<User?> signInWithGoogle();
  Future<User?> signInAnonymously();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}

// Implementation
class AuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  
  AuthRepository(this._auth, this._googleSignIn);
  
  @override
  Future<User?> signInWithGoogle() async {
    // Implementation
  }
  
  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

// Provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    GoogleSignIn(),
  );
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}
```

### Step 5: Create State Notifiers

**Example: Destinations State**
```dart
@freezed
class DestinationsState with _$DestinationsState {
  const factory DestinationsState.initial() = _Initial;
  const factory DestinationsState.loading() = _Loading;
  const factory DestinationsState.loaded(List<Destination> destinations) = _Loaded;
  const factory DestinationsState.error(String message) = _Error;
}

@riverpod
class DestinationsNotifier extends _$DestinationsNotifier {
  @override
  DestinationsState build() {
    _loadDestinations();
    return const DestinationsState.initial();
  }
  
  Future<void> _loadDestinations() async {
    state = const DestinationsState.loading();
    try {
      final destinations = await ref.read(destinationRepositoryProvider).getAll();
      state = DestinationsState.loaded(destinations);
    } catch (e) {
      state = DestinationsState.error(e.toString());
    }
  }
}
```

### Step 6: Update Widgets

**Before:**
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      // ...
    );
  }
}
```

**After:**
```dart
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider);
    final destinationsState = ref.watch(destinationsNotifierProvider);
    
    return destinationsState.when(
      initial: () => const SizedBox(),
      loading: () => const LoadingWidget(),
      loaded: (destinations) => _buildContent(destinations),
      error: (message) => ErrorWidget(message: message),
    );
  }
}
```

## 🎨 Key Riverpod Concepts

### 1. Provider Types

- **`Provider`**: For read-only values
- **`StateProvider`**: For simple state (like a counter)
- **`StateNotifierProvider`**: For complex state with logic
- **`FutureProvider`**: For async operations (one-time)
- **`StreamProvider`**: For streams (real-time data)
- **`@riverpod`**: Code generation annotation

### 2. Reading Providers

```dart
// Watch (rebuilds on change)
final value = ref.watch(myProvider);

// Read (one-time read, no rebuild)
final value = ref.read(myProvider);

// Listen (for side effects)
ref.listen(myProvider, (previous, next) {
  // Handle change
});
```

### 3. Provider Modifiers

```dart
// Auto-dispose when not used
@riverpod
class MyNotifier extends _$MyNotifier {
  // ...
}

// Family (parameterized providers)
@riverpod
Future<Destination> destination(DestinationRef ref, String id) async {
  return ref.read(destinationRepositoryProvider).getById(id);
}

// Usage
final dest = ref.watch(destinationProvider('123'));
```

## 🧪 Testing Benefits

```dart
test('auth state changes', () {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(MockAuthRepository()),
    ],
  );
  
  expect(
    container.read(authStateChangesProvider),
    emits(isA<User>()),
  );
});
```

## 📝 Code Generation Commands

```bash
# Generate code once
flutter pub run build_runner build

# Watch for changes and regenerate
flutter pub run build_runner watch

# Delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs
```

## ✅ Migration Checklist

- [x] Update pubspec.yaml with Riverpod dependencies
- [x] Create core folder structure
- [x] Create app constants
- [ ] Migrate main.dart to ProviderScope
- [ ] Migrate ThemeProvider to Riverpod
- [ ] Create auth feature structure
- [ ] Migrate AuthService to repository pattern
- [ ] Create auth providers
- [ ] Update login screen
- [ ] Create destinations feature structure
- [ ] Migrate destination models
- [ ] Create destination providers
- [ ] Update home/explore screens
- [ ] Create hotels feature structure
- [ ] Create bookings feature structure
- [ ] Create profile feature structure
- [ ] Remove old Provider code
- [ ] Add unit tests
- [ ] Update documentation

## 🚀 Next Steps

1. **Review this guide** and ask any questions
2. **Approve the migration** plan
3. **Start with Phase 1**: Core setup and auth migration
4. **Test incrementally** after each phase
5. **Deploy** when all features are migrated

## 📚 Resources

- [Riverpod Documentation](https://riverpod.dev/)
- [Riverpod Code Generation](https://riverpod.dev/docs/concepts/about_code_generation)
- [Feature-Based Architecture](https://codewithandrea.com/articles/flutter-project-structure/)
- [Clean Architecture in Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

---

**Note**: This is a major refactoring. We'll implement it incrementally to avoid breaking the app. Each phase will be tested before moving to the next.
