import "package:flutter/material.dart";
import "../models/recipe_entry.dart";

class RecipeEntryCard extends StatelessWidget {
  final RecipeEntry recipeEntry;
  const RecipeEntryCard({super.key, required this.recipeEntry});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: recipeEntry.image,
            fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
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
      ),
    );
  }
}
