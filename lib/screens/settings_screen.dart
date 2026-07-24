import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cuisine_type_repository.dart';
import '../services/recipe_entry_repository.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmResetToDefaults(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
          'This will erase all recipes and cuisine types you\'ve added and restore the original defaults. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final recipeRepo = Provider.of<RecipeEntryRepository>(
      context,
      listen: false,
    );
    final cuisineRepo = Provider.of<CuisineTypeRepository>(
      context,
      listen: false,
    );

    await recipeRepo.resetToDefaults();
    await cuisineRepo.resetToDefaults();
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Dark Mode'),
                  trailing: Switch(
                    value: settingsService.isDarkMode,
                    onChanged: (value) {
                      settingsService.toggleDarkMode();
                    },
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Reset to Defaults'),
                  subtitle: const Text(
                    'Erase all recipes and cuisine types you\'ve added',
                  ),
                  trailing: const Icon(Icons.restore, color: Colors.red),
                  onTap: () => _confirmResetToDefaults(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
