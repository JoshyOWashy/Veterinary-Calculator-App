import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

// Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Settings'),
        )
      ],
    );
  }
}
