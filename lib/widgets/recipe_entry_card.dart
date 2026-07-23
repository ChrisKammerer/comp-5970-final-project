import "package:flutter/material.dart";
import "../models/recipe_entry.dart";

class RecipeEntryCard extends StatelessWidget {
  final RecipeEntry recipeEntry;
  const RecipeEntryCard({super.key, required this.recipeEntry});

  bool get _isDefaultImage => recipeEntry.imagePath.isEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: BoxDecoration(
          color: _isDefaultImage ? colorScheme.primaryContainer : null,
          image: _isDefaultImage
              ? null
              : DecorationImage(
                  image: recipeEntry.image,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.35),
                    BlendMode.darken,
                  ),
                ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isDefaultImage)
              Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 64,
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                ),
              ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => RecipeEntryDetail(),
                //     ),
                //   );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipeEntry.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
