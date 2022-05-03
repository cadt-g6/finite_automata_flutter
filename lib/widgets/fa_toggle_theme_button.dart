// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:finite_automata_flutter/app.dart';
import 'package:flutter/material.dart';

class FaToggleThemeButton extends StatefulWidget {
  FaToggleThemeButton({
    Key? key,
  }) : super(key: key);

  @override
  State<FaToggleThemeButton> createState() => _FaToggleThemeButtonState();
}

class _FaToggleThemeButtonState extends State<FaToggleThemeButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: App.of(context)?.isDarkMode == true ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
      onPressed: () {
        setState(() {
          App.of(context)?.toggleDarkMode();
        });
      },
    );
  }
}
