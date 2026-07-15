import 'package:flutter/material.dart';
import '../widgets/recipe_entry_card.dart';
import '../services/recipe_entry_repository.dart';
import 'package:provider/provider.dart';

class RecipeBrowseScreen extends StatelessWidget {
  const RecipeBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Recipes')),
      body: SafeArea(child: RecipeCardBuilder()),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to the recipe creation screen
            },
            icon: Icon(Icons.add),
            label: Text('Add Recipe'),
          ),
        )
      )
    );
  }
}

class RecipeCardBuilder extends StatelessWidget {
  const RecipeCardBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecipeEntryRepository(),
      child: Consumer<RecipeEntryRepository>(
        builder: (context, recipeRepo, child) {
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
      ),
    );
  }
}
