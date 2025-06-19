import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class CategorySelector extends StatefulWidget {
  final String selectedCategory;
  final String currentLang;
  final ValueChanged<String> onSelectCategory;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.currentLang,
    required this.onSelectCategory,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'name': 'All', 'emoji': '📝'},
    {'id': 'food', 'name': 'Food', 'emoji': '🍽️'},
    {'id': 'shopping', 'name': 'Shopping', 'emoji': '🛍️'},
    {'id': 'travel', 'name': 'Travel', 'emoji': '✈️'},
    {'id': 'work', 'name': 'Work', 'emoji': '💼'},
    {'id': 'personal', 'name': 'Personal', 'emoji': '💭'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Localized names for categories
    const zhNames = {
      'all': '全部',
      'food': '食物',
      'shopping': '购物',
      'travel': '旅行',
      'work': '工作',
      'personal': '个人',
    };

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = widget.selectedCategory == category['id'];
          final id = category['id']!;
          final name = widget.currentLang == 'zh'
              ? zhNames[id]!
              : category['name']!;
          
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  math.sin(_animation.value * 2 * math.pi + index * 0.5) * 2,
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => widget.onSelectCategory(category['id']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: isDark
                                    ? [Colors.pink.shade600, Colors.pink.shade700]
                                    : [Colors.pink.shade400, Colors.pink.shade500],
                              )
                            : null,
                        color: !isSelected
                            ? (isDark
                                ? Colors.pink.shade900.withOpacity(0.3)
                                : Colors.pink.shade100.withOpacity(0.7))
                            : null,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isDark
                              ? Colors.pink.shade700.withOpacity(0.3)
                              : Colors.pink.shade200.withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.pink.shade200.withOpacity(0.5),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.rotate(
                            angle: isSelected
                                ? math.sin(_animation.value * 4 * math.pi) * 0.1
                                : 0,
                            child: Text(
                              category['emoji']!,
                              style: TextStyle(
                                fontSize: isSelected ? 18 : 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? Colors.pink.shade200
                                      : Colors.pink.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 