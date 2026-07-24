import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_entry.dart';

class RecipeEntryRepository extends ChangeNotifier {
  static const String _storageKey = 'recipe_entries';
  List<RecipeEntry> recipeEntries = [];

  RecipeEntryRepository() {
    loadRecipeEntries();
  }

  Future<void> saveRecipeEntries(List<RecipeEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final recipeEntryListJson = jsonEncode(
      entries.map((entry) => entry.toMap()).toList(),
    );
    await prefs.setString(_storageKey, recipeEntryListJson);
  }

  Future<void> loadRecipeEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final recipeEntryListJson = prefs.getString(_storageKey);

    if (recipeEntryListJson == null) {
      recipeEntries = [];
      notifyListeners();
    } else {
      final List<dynamic> recipeEntryListMap = jsonDecode(recipeEntryListJson);
      recipeEntries = recipeEntryListMap
          .map((entryMap) => RecipeEntry.fromMap(entryMap))
          .toList();

      notifyListeners();
    }
  }

  Future<RecipeEntry> addRecipeEntry(
    String name,
    String description,
    String instructions,
    String mealType,
    String cuisineType,
    List<String> ingredients,
    String imagePath,
  ) async {
    final nextId = recipeEntries.length + 1;
    final newEntry = RecipeEntry(
      nextId,
      name,
      description,
      instructions,
      mealType,
      cuisineType,
      ingredients,
      imagePath,
    );

    recipeEntries.add(newEntry);
    await saveRecipeEntries(recipeEntries);
    notifyListeners();
    return newEntry;
  }

  Future<void> updateRecipeEntry(
    int id,
    String name,
    String description,
    String instructions,
    String mealType,
    String cuisineType,
    String imagePath,
    List<String> ingredients,
  ) async {
    final index = recipeEntries.indexWhere((recipe) => recipe.id == id);
    if (index == -1) {
      return;
    }

    final updatedEntry = RecipeEntry(
      id,
      name,
      description,
      instructions,
      mealType,
      cuisineType,
      ingredients,
      imagePath,
    );

    recipeEntries[index] = updatedEntry;
    await saveRecipeEntries(recipeEntries);
    notifyListeners();
  }

  Future<void> deleteRecipeEntry(int id) async {
    recipeEntries.removeWhere((recipe) => recipe.id == id);
    await saveRecipeEntries(recipeEntries);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await loadRecipeEntries();
  }
}
