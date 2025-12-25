import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Theme mode notifier for managing dark/light mode
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  bool build() {
    // Default to light mode
    return false;
  }

  /// Toggle between dark and light mode
  void toggleTheme() {
    state = !state;
  }

  /// Set theme mode explicitly
  void setDarkMode(bool isDark) {
    state = isDark;
  }
}







