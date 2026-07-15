import 'package:flutter/material.dart';

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
  const RecipeEntryEditScreen({super.key});

  @override
  State<RecipeEntryEditScreen> createState() => _RecipeEntryEditScreenState();
}

class _RecipeEntryEditScreenState extends State<RecipeEntryEditScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
