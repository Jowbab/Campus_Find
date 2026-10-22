import 'package:flutter/material.dart';

import 'lib/home_screen.dart';
import 'lib/item_store.dart';

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
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: HomeScreen(store: store),
    );
  }
}
