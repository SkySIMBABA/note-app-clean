import 'package:flutter/material.dart';
import 'dart:ui';

class SearchBarWidget extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final String placeholder;

  const SearchBarWidget({
    super.key,
    required this.value,
    required this.onChanged,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.pink.shade900.withOpacity(0.3)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark 
              ? Colors.pink.shade700.withOpacity(0.3)
              : Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: isDark 
                ? Colors.pink.shade300.withOpacity(0.5)
                : Colors.grey.shade500,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark 
                ? Colors.pink.shade300
                : theme.colorScheme.primary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: isDark ? Colors.pink.shade100 : Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }
} 