import "package:auto_size_text/auto_size_text.dart";
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
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => RecipeEntryDetail(),
          //     ),
          //   );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: AutoSizeText(
                recipeEntry.name,
                maxLines: 2,
                minFontSize: 14,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _isDefaultImage ? colorScheme.primaryContainer : null,
                  image: _isDefaultImage
                      ? null
                      : DecorationImage(
                          image: recipeEntry.image,
                          fit: BoxFit.cover,
                        ),
                ),
                child: _isDefaultImage
                    ? Center(
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 64,
                          color: colorScheme.onPrimaryContainer.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
