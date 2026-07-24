import 'package:flutter/material.dart';
import '../../widgets/recipe_entry_card.dart';
import '../../services/recipe_entry_repository.dart';
import 'edit_recipe_entry_screen.dart';
import 'package:provider/provider.dart';

class RecipeBrowseScreen extends StatelessWidget {
  const RecipeBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Recipes')),
      body: const SafeArea(child: RecipeCardBuilder()),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeEntryEditScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Recipe'),
          ),
        ),
      ),
    );
  }
}

class RecipeCardBuilder extends StatelessWidget {
  const RecipeCardBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeEntryRepository>(
      builder: (context, recipeRepo, child) {
        if (recipeRepo.recipeEntries.isEmpty) {
          return const Center(
            child: Text('No recipes yet. Tap "Add Recipe" to create one.'),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
          ),
          itemCount: recipeRepo.recipeEntries.length,
          itemBuilder: (context, index) {
            final recipe = recipeRepo.recipeEntries[index];
            return RecipeEntryCard(recipeEntry: recipe);
          },
        );
      },
    );
  }
}
