import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            ],
          ),
        ),
      ),
    );
  }
}
