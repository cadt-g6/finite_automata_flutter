import 'package:finite_automata_flutter/screens/fa_detail_screen.dart';
import 'package:finite_automata_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FaDetailScreen(),
    );
  }
}
