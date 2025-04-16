import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/injection.dart';
import 'presentation/providers/cat_provider.dart';
import 'presentation/providers/liked_cat_provider.dart';
import 'presentation/screens/main_screen.dart';

void main() {
  setupInjection();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<CatProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LikedCatProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Cat Tinder', home: MainScreen());
  }
}
