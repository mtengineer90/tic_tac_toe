import 'package:flutter/material.dart';
import 'package:tic_tac_toe/players_info.dart';

import 'game_panel.dart';
import 'home.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomePage());

      case 'playerinfo':
          return MaterialPageRoute(builder: (_) => PlayersInfo());

      case 'gamepanel':
        if (args is List<String>) {
          return MaterialPageRoute(builder: (_) => Game(player1:args[0] ,player2: args[1],));
        }
        else {
          return MaterialPageRoute(builder: (_) => const Game(player1:'' ,player2: '',));
        }

      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}