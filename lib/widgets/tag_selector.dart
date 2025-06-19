import 'package:flutter/material.dart';

class TagSelector extends StatelessWidget {
  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String?> onTagSelected;

  const TagSelector({
    Key? key,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selectedTag == null,
            onSelected: (_) => onTagSelected(null),
          ),
          const SizedBox(width: 8),
          for (var tag in tags) ...[
            ChoiceChip(
              label: Text(tag),
              selected: selectedTag == tag,
              onSelected: (_) => onTagSelected(tag),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
} 