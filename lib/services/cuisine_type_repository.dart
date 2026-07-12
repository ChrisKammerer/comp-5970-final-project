import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuisineTypeRepository extends ChangeNotifier {
  static const String _storageKey = 'cuisine_types';
  List<String> cuisineTypes = [];

  static const List<String> _defaultCuisineTypes = [
    'Italian',
    'Chinese',
    'Mexican',
    'Indian',
    'French',
    'Japanese',
    'Mediterranean',
    'Thai',
    'Spanish',
    'American',
  ];

  Future<void> saveCuisineTypes(List<String> cuisineTypes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, cuisineTypes);
  }

  Future<void> loadCuisineTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final cuisineTypesList = prefs.getStringList(_storageKey);

    if (cuisineTypesList == null || cuisineTypesList.isEmpty) {
      cuisineTypes = _defaultCuisineTypes;
    } else {
      cuisineTypes = cuisineTypesList;
    }
    
    notifyListeners();
  }
}
