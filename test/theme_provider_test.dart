import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reshelf_app_cs310/providers/theme_provider.dart';

void main() {
  group('ThemeProvider Unit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initial theme should be light mode (isDarkMode = false)', () async {
      // Arrange & Act
      final themeProvider = ThemeProvider();
      
      // Wait for async initialization to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      expect(themeProvider.isDarkMode, false);
    });

    test('toggleTheme should switch from light to dark mode', () async {
      // Arrange
      final themeProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Act
      await themeProvider.toggleTheme();
      
      // Assert
      expect(themeProvider.isDarkMode, true);
    });
  });
}
