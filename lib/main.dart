import 'package:flutter/material.dart';
import 'services/settings_service.dart';
import 'services/recipe_entry_repository.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MealOrganizer());
}

class MealOrganizer extends StatelessWidget {
  const MealOrganizer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>(
          create: (context) => SettingsService(),
        ),
        ChangeNotifierProvider<RecipeEntryRepository>(
          create: (context) => RecipeEntryRepository(),
        ),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settingsService, child) {
          return MaterialApp(
            title: 'Meal Organizer',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
              // add more theme data as needed
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              // add more dark theme data as needed
            ),
            themeMode: settingsService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
