import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cuisine_type_repository.dart';
import 'recipe_entry_repository.dart';

class SettingsService extends ChangeNotifier {
  bool isDarkMode = false;
  static const String _darkModeKey = 'dark_mode';

  SettingsService() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode);
  }

  Future<void> toggleDarkMode() async {
    isDarkMode = !isDarkMode;
    await saveSettings();
    notifyListeners();
  }

  Future<void> resetAppData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Reset cuisine types to default
    final cuisineTypeRepository = CuisineTypeRepository();
    await cuisineTypeRepository.loadCuisineTypes();

    // Reset recipe entries to empty
    final recipeEntryRepository = RecipeEntryRepository();
    await recipeEntryRepository.loadRecipeEntries();

    notifyListeners();
  }
}