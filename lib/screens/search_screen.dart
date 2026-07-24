import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe_entry.dart';
import '../services/cuisine_type_repository.dart';
import '../services/recipe_entry_repository.dart';
import '../widgets/recipe_entry_card.dart';

enum _SearchField { name, mealType, cuisineType, ingredient }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  _SearchField _field = _SearchField.name;
  late final TextEditingController _queryController;
  String? _mealType;
  String? _cuisineType;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
    _queryController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _onFieldChanged(_SearchField field) {
    setState(() {
      _field = field;
      _queryController.clear();
      _mealType = null;
      _cuisineType = null;
    });
  }

  List<RecipeEntry> _filter(List<RecipeEntry> recipes) {
    switch (_field) {
      case _SearchField.name:
        final query = _queryController.text.trim().toLowerCase();
        if (query.isEmpty) return recipes;
        return recipes
            .where((recipe) => recipe.name.toLowerCase().contains(query))
            .toList();
      case _SearchField.ingredient:
        final query = _queryController.text.trim().toLowerCase();
        if (query.isEmpty) return recipes;
        return recipes
            .where(
              (recipe) => recipe.ingredients.any(
                (ingredient) => ingredient.toLowerCase().contains(query),
              ),
            )
            .toList();
      case _SearchField.mealType:
        if (_mealType == null) return recipes;
        return recipes.where((recipe) => recipe.mealType == _mealType).toList();
      case _SearchField.cuisineType:
        if (_cuisineType == null) return recipes;
        return recipes
            .where((recipe) => recipe.cuisineType == _cuisineType)
            .toList();
    }
  }

  Widget _buildQueryInput() {
    switch (_field) {
      case _SearchField.name:
        return TextField(
          controller: _queryController,
          decoration: const InputDecoration(
            labelText: 'Search by name',
            prefixIcon: Icon(Icons.search),
          ),
        );
      case _SearchField.ingredient:
        return TextField(
          controller: _queryController,
          decoration: const InputDecoration(
            labelText: 'Search by ingredient',
            prefixIcon: Icon(Icons.search),
          ),
        );
      case _SearchField.mealType:
        return DropdownMenu<String?>(
          initialSelection: _mealType,
          expandedInsets: EdgeInsets.zero,
          selectOnly: true,
          label: const Text('Meal Type'),
          dropdownMenuEntries: [
            const DropdownMenuEntry(value: null, label: 'All'),
            ...RecipeEntry.mealTypeOptions.map(
              (type) => DropdownMenuEntry(value: type, label: type),
            ),
          ],
          onSelected: (value) => setState(() => _mealType = value),
        );
      case _SearchField.cuisineType:
        return Consumer<CuisineTypeRepository>(
          builder: (context, cuisineRepo, child) {
            final sortedCuisineTypes = [...cuisineRepo.cuisineTypes]
              ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
            return DropdownMenu<String?>(
              initialSelection: _cuisineType,
              expandedInsets: EdgeInsets.zero,
              selectOnly: true,
              label: const Text('Cuisine Type'),
              dropdownMenuEntries: [
                const DropdownMenuEntry(value: null, label: 'All'),
                ...sortedCuisineTypes.map(
                  (c) => DropdownMenuEntry(value: c, label: c),
                ),
              ],
              onSelected: (value) => setState(() => _cuisineType = value),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Recipes')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<_SearchField>(
                segments: const [
                  ButtonSegment(value: _SearchField.name, label: Text('Name')),
                  ButtonSegment(
                    value: _SearchField.mealType,
                    label: Text('Meal'),
                  ),
                  ButtonSegment(
                    value: _SearchField.cuisineType,
                    label: Text('Cuisine'),
                  ),
                  ButtonSegment(
                    value: _SearchField.ingredient,
                    label: Text('Ingredient'),
                  ),
                ],
                selected: {_field},
                onSelectionChanged: (selection) =>
                    _onFieldChanged(selection.first),
              ),
              const SizedBox(height: 12),
              _buildQueryInput(),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<RecipeEntryRepository>(
                  builder: (context, recipeRepo, child) {
                    if (recipeRepo.recipeEntries.isEmpty) {
                      return const Center(child: Text('No recipes yet'));
                    }
                    final results = _filter(recipeRepo.recipeEntries);
                    if (results.isEmpty) {
                      return const Center(child: Text('No recipes found'));
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                          ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return RecipeEntryCard(recipeEntry: results[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
