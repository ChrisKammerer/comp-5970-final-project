class RecipeEntry {
  final int id;
  final String name;
  final String description;
  final String instructions;
  final String mealType;
  final String cuisineType;
  final List<String> ingredients;

  RecipeEntry(
    this.id,
    this.name,
    this.description,
    this.instructions,
    this.mealType,
    this.cuisineType,
    this.ingredients,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructions': instructions,
      'mealType': mealType,
      'cuisineType': cuisineType,
      'ingredients': ingredients,
    };
  }

  factory RecipeEntry.fromMap(Map<String, dynamic> map) {
    return RecipeEntry(
      map['id'],
      map['name'],
      map['description'],
      map['instructions'],
      map['mealType'],
      map['cuisineType'],
      List<String>.from(map['ingredients']),
    );
  }
}
