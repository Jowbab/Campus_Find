import 'dart:typed_data';

import 'package:flutter/material.dart';

enum ItemType { lost, found }

enum ItemCategory {
  electronics('Electronics', Icons.devices),
  bags('Bags', Icons.backpack),
  idCards('IDs & Cards', Icons.badge),
  keys('Keys', Icons.key),
  clothing('Clothing', Icons.checkroom),
  books('Books & Notes', Icons.menu_book),
  other('Other', Icons.category);

  const ItemCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Known spots on campus, so reports are consistent and easy to search.
const List<String> campusLocations = [
  'Library',
  'Cafeteria',
  'Gymnasium',
  'Main Building',
  'Science Building',
  'Engineering Hall',
  'Student Center',
  'Parking Lot',
  'Dormitory',
  'Other',
];

class CampusItem {
  CampusItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.category,
    required this.location,
    required this.contact,
    required this.postedAt,
    this.photo,
    this.isReturned = false,
  });

  final String id;
  final String title;
  final String description;
  final ItemType type;
  final ItemCategory category;
  final String location;
  final String contact;
  final DateTime postedAt;

  /// Raw image bytes. Using bytes instead of file paths lets the photo
  /// display on every platform, including web.
  final Uint8List? photo;

  bool isReturned;
}

String timeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} h ago';
  return '${diff.inDays} d ago';
}
