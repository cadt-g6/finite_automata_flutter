import 'package:bot_toast/bot_toast.dart';
import 'package:finite_automata_flutter/configs/theme_config.dart';
import 'package:finite_automata_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isDarkMode = true;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return MaterialApp(
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeConfig.light().get(),
      darkTheme: ThemeConfig.dark().get(),
      home: const HomeScreen(),
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return child;
      },
    );
  }
}
