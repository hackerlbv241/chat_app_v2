import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
      ),
      body: Center(
        child: Text("Page de paramètres"),
      ),
    );
  }
}
