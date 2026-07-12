import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_entry.dart';

class RecipeEntryRepository extends ChangeNotifier {
  static const String _storageKey = 'recipe_entries';
  List<RecipeEntry> recipeEntries = [];

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
}
