class RecipeEntry {
  static const String defaultImagePath = 'assets/images/default_recipe_image.png';
  
  final int id;
  final String name;
  final String description;
  final String instructions;
  final String mealType;
  final String cuisineType;
  String imagePath = defaultImagePath;
  final List<String> ingredients;

  RecipeEntry(
    this.id,
    this.name,
    this.description,
    this.instructions,
    this.mealType,
    this.cuisineType,
    this.imagePath,
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
      'imagePath': imagePath,
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
      map['imagePath'],
      List<String>.from(map['ingredients']),
    );
  }
}
