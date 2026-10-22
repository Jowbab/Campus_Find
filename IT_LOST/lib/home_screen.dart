import 'package:flutter/material.dart';

import 'campus_item.dart';
import 'item_detail_screen.dart';
import 'item_store.dart';
import 'post_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final ItemStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  ItemCategory? _category;
  ItemType? _type;
  bool _showReturned = false;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusFind'),
        actions: [
          IconButton(
            tooltip: _showReturned ? 'Hide returned items' : 'Show returned items',
            icon: Icon(_showReturned ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showReturned = !_showReturned),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Report item'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostItemScreen(store: store)),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: 'Search items or locations',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Category chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                ),
                for (final c in ItemCategory.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      avatar: Icon(c.icon, size: 18),
                      label: Text(c.label),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                  ),
              ],
            ),
          ),

          // Lost / Found filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<ItemType?>(
              segments: const [
                ButtonSegment(value: null, label: Text('All')),
                ButtonSegment(value: ItemType.lost, label: Text('Lost')),
                ButtonSegment(value: ItemType.found, label: Text('Found')),
              ],
              selected: {_type},
              onSelectionChanged: (selection) =>
                  setState(() => _type = selection.first),
            ),
          ),

          // Results
          Expanded(
            child: ListenableBuilder(
              listenable: store,
              builder: (context, _) {
                final items = store.filter(
                  query: _query,
                  category: _category,
                  type: _type,
                  showReturned: _showReturned,
                );

                if (items.isEmpty) {
                  return const Center(
                    child: Text('No items match your search.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ItemCard(
                      item: item,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemDetailScreen(
                            store: store,
                            itemId: item.id,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item, required this.onTap});

  final CampusItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: item.photo != null
                ? Image.memory(item.photo!, fit: BoxFit.cover)
                : ColoredBox(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(item.category.icon),
                  ),
          ),
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration:
                item.isReturned ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${item.location} • ${timeAgo(item.postedAt)}'),
        trailing: _StatusBadge(type: item.type, returned: item.isReturned),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.type, required this.returned});

  final ItemType type;
  final bool returned;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;

    if (returned) {
      label = 'Returned';
      color = Colors.green;
    } else if (type == ItemType.lost) {
      label = 'Lost';
      color = Colors.red;
    } else {
      label = 'Found';
      color = Colors.blue;
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      side: BorderSide(color: color),
      visualDensity: VisualDensity.compact,
    );
  }
}
