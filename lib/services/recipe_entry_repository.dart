import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_entry.dart';
import 'mock_recipes.dart';

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
      final List<dynamic> recipeEntryListMap = jsonDecode(mockRecipeEntriesJson);
      recipeEntries = recipeEntryListMap
          .map((entryMap) => RecipeEntry.fromMap(entryMap))
          .toList();
      notifyListeners();
    } else {
      final List<dynamic> recipeEntryListMap = jsonDecode(recipeEntryListJson);
      recipeEntries = recipeEntryListMap
          .map((entryMap) => RecipeEntry.fromMap(entryMap))
          .toList();

      notifyListeners();
    }
  }
}
