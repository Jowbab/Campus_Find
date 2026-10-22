import 'package:flutter/foundation.dart';

import 'campus_item.dart';

/// Holds all reported items and notifies listeners when they change.
/// Data lives in memory, so it resets when the app restarts. Swap this
/// for a database or Firebase later without changing the screens.
class ItemStore extends ChangeNotifier {
  ItemStore({List<CampusItem>? seed}) : _items = [...?seed];

  final List<CampusItem> _items;

  CampusItem? byId(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  /// Returns matching items, newest first.
  List<CampusItem> filter({
    String query = '',
    ItemCategory? category,
    ItemType? type,
    bool showReturned = false,
  }) {
    final q = query.trim().toLowerCase();

    final results = _items.where((item) {
      if (!showReturned && item.isReturned) return false;
      if (category != null && item.category != category) return false;
      if (type != null && item.type != type) return false;
      if (q.isEmpty) return true;

      return item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.location.toLowerCase().contains(q);
    }).toList();

    results.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return results;
  }

  void add(CampusItem item) {
    _items.add(item);
    notifyListeners();
  }

  void toggleReturned(String id) {
    final item = byId(id);
    if (item == null) return;
    item.isReturned = !item.isReturned;
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}

/// Demo data so the app isn't empty on first launch.
List<CampusItem> sampleItems() {
  final now = DateTime.now();
  return [
    CampusItem(
      id: 'seed-1',
      title: 'Black JanSport backpack',
      description: 'Has a chemistry notebook inside and a silver keychain.',
      type: ItemType.lost,
      category: ItemCategory.bags,
      location: 'Library',
      contact: 'maria.s@campus.edu',
      postedAt: now.subtract(const Duration(hours: 2)),
    ),
    CampusItem(
      id: 'seed-2',
      title: 'AirPods case (white)',
      description: 'Found on a table near the window seats.',
      type: ItemType.found,
      category: ItemCategory.electronics,
      location: 'Cafeteria',
      contact: 'Leave a message in the lost & found group chat',
      postedAt: now.subtract(const Duration(minutes: 45)),
    ),
    CampusItem(
      id: 'seed-3',
      title: 'Student ID - Dela Cruz, J.',
      description: 'Found near the gym entrance.',
      type: ItemType.found,
      category: ItemCategory.idCards,
      location: 'Gymnasium',
      contact: 'Drop-off at the Student Center front desk',
      postedAt: now.subtract(const Duration(days: 1)),
    ),
    CampusItem(
      id: 'seed-4',
      title: 'Car keys with red lanyard',
      description: 'Toyota key fob, lanyard says "Engineering Club".',
      type: ItemType.lost,
      category: ItemCategory.keys,
      location: 'Parking Lot',
      contact: 'ray.t@campus.edu',
      postedAt: now.subtract(const Duration(days: 3)),
      isReturned: true,
    ),
  ];
}
