import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'item_store.dart';

void main() {
  runApp(CampusFindApp(store: ItemStore(seed: sampleItems())));
}

class CampusFindApp extends StatelessWidget {
  const CampusFindApp({super.key, required this.store});

  final ItemStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusFind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF176B57),
        useMaterial3: true,
      ),
      home: HomeScreen(store: store),
    );
  }
}
