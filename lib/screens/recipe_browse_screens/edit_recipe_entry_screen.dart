import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_organizer/services/recipe_entry_repository.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../models/recipe_entry.dart';
import 'package:provider/provider.dart';

class FieldControllerGroup {
  final String label;
  final List<TextEditingController> controllers;

  FieldControllerGroup({required this.label, required List<String> values})
    : controllers = values.isNotEmpty
          ? values.map((v) => TextEditingController(text: v)).toList()
          : [TextEditingController()];

  List<String> get values => controllers.map((c) => c.text).toList();

  void addController() {
    controllers.add(TextEditingController());
  }

  void removeController(int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
    }
  }

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
  }
}

class RecipeEntryEditScreen extends StatefulWidget {
  final RecipeEntry? recipeEntry;
  const RecipeEntryEditScreen({super.key, this.recipeEntry});

  @override
  State<RecipeEntryEditScreen> createState() => _RecipeEntryEditScreenState();
}

class _RecipeEntryEditScreenState extends State<RecipeEntryEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _instructionsController;
  late final FieldControllerGroup _ingredientsGroup;
  late String _imagePath;

  @override
  void initState() {
    super.initState();
    final e = widget.recipeEntry;
    _nameController = TextEditingController(text: e?.name);
    _descriptionController = TextEditingController(text: e?.description);
    _instructionsController = TextEditingController(text: e?.instructions);
    _ingredientsGroup = FieldControllerGroup(
      label: 'Ingredients',
      values: e != null ? e.ingredients : [],
    );
    _imagePath = e?.imagePath ?? '';
  }

  Future<void> _pickBackgroundImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    final pickedPath = pickedFile?.path;
    if (pickedPath == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedPath)}';
    final savedImage = await File(
      pickedPath,
    ).copy(path.join(appDir.path, fileName));

    if (!mounted) return;
    setState(() {
      _imagePath = savedImage.path;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _ingredientsGroup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDefaultImage = _imagePath.isEmpty;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe Entry'),
        actions: [
          IconButton(
            onPressed: _pickBackgroundImage,
            icon: const Icon(Icons.add_photo_alternate),
            tooltip: 'Add background photo',
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
                  color: isDefaultImage ? colorScheme.primaryContainer : null,
                  image: isDefaultImage
                      ? null
                      : DecorationImage(
                          image: FileImage(File(_imagePath)),
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
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _instructionsController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Instructions'),
            ),
            const SizedBox(height: 12),
            const Text('Ingredients'),
            const SizedBox(height: 12),
            ..._ingredientsGroup.controllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Ingredient ${index + 1}',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _ingredientsGroup.removeController(index);
                        });
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _ingredientsGroup.addController();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add ingredient'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              final ingredients = _ingredientsGroup.values
                  .where((ingredient) => ingredient.trim().isNotEmpty)
                  .map((ingredient) => ingredient.trim())
                  .toList();

              if (widget.recipeEntry == null) {
                await Provider.of<RecipeEntryRepository>(
                  context,
                  listen: false,
                ).addRecipeEntry(
                  _nameController.text,
                  _descriptionController.text,
                  _instructionsController.text,
                  'mealTypePlaceholder',
                  'cuisineTypePlaceholder',
                  ingredients,
                  _imagePath,
                );
              } else {
                await Provider.of<RecipeEntryRepository>(
                  context,
                  listen: false,
                ).updateRecipeEntry(
                  widget.recipeEntry!.id,
                  _nameController.text,
                  _descriptionController.text,
                  _instructionsController.text,
                  "mealtype placeholder",
                  "cuisinetype placeholder",
                  _imagePath,
                  ingredients,
                );
              }

              if (!context.mounted) return;

              Navigator.pop(context);
            },
            label: Text("Save Recipe"),
          ),
        ),
      ),
    );
  }
}
