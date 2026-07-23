import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/recipe_entry.dart';
import '../../services/recipe_entry_repository.dart';
import 'edit_recipe_entry_screen.dart';

class RecipeEntryDetailScreen extends StatelessWidget {
  final RecipeEntry recipeEntry;
  const RecipeEntryDetailScreen({super.key, required this.recipeEntry});

  Future<void> _confirmDelete(
    BuildContext context,
    RecipeEntryRepository recipeRepo,
    RecipeEntry currentEntry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text(
          'Are you sure you want to delete "${currentEntry.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await recipeRepo.deleteRecipeEntry(currentEntry.id);

    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeEntryRepository>(
      builder: (context, recipeRepo, child) {
        final currentEntry = recipeRepo.recipeEntries.firstWhere(
          (recipe) => recipe.id == recipeEntry.id,
          orElse: () => recipeEntry,
        );
        final isDefaultImage = currentEntry.imagePath.isEmpty;
        final colorScheme = Theme.of(context).colorScheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(currentEntry.name),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeEntryEditScreen(recipeEntry: currentEntry),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                tooltip: 'Edit recipe',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: isDefaultImage
                          ? colorScheme.primaryContainer
                          : null,
                      image: isDefaultImage
                          ? null
                          : DecorationImage(
                              image: currentEntry.image,
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: isDefaultImage
                        ? Center(
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 48,
                              color: colorScheme.onPrimaryContainer.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Meal Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  currentEntry.mealType.isEmpty
                      ? 'Not specified'
                      : currentEntry.mealType,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cuisine Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  currentEntry.cuisineType.isEmpty
                      ? 'Not specified'
                      : currentEntry.cuisineType,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(currentEntry.description),
                const SizedBox(height: 16),
                const Text(
                  'Instructions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(currentEntry.instructions),
                const SizedBox(height: 16),
                const Text(
                  'Ingredients',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                ...currentEntry.ingredients.map(
                  (ingredient) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('• $ingredient'),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () => _confirmDelete(context, recipeRepo, currentEntry),
            tooltip: 'Delete recipe',
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        );
      },
    );
  }
}
