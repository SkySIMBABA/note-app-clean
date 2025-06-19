import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class LanguageSelector extends StatefulWidget {
  final String currentLang;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLang,
    required this.onLanguageChanged,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> with TickerProviderStateMixin {
  bool _isOpen = false;

  final Map<String, Map<String, String>> _languages = {
    'zh': {'name': '简体中文', 'flag': '🇨🇳'},
    'en': {'name': 'English', 'flag': '🇺🇸'},
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isOpen = !_isOpen;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.pink.shade900.withOpacity(0.3)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark 
                    ? Colors.pink.shade700.withOpacity(0.3)
                    : Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_languages[widget.currentLang]!['flag']} ${_languages[widget.currentLang]!['name']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.pink.shade100 : Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 16,
                  color: isDark ? Colors.pink.shade300 : Colors.black54,
                ),
              ],
            ),
          ),
        ),
        if (_isOpen)
          Positioned(
            top: 50,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: isDark 
                        ? Colors.pink.shade900.withOpacity(0.4)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark 
                          ? Colors.pink.shade700.withOpacity(0.3)
                          : Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                            ? Colors.pink.shade800.withOpacity(0.2)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _languages.entries.map((entry) {
                      final isSelected = entry.key == widget.currentLang;
                      return GestureDetector(
                        onTap: () {
                          widget.onLanguageChanged(entry.key);
                          setState(() {
                            _isOpen = false;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? isDark 
                                    ? Colors.pink.shade800.withOpacity(0.3)
                                    : const Color(0xFF10B981).withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Text(
                                entry.value['flag']!,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                entry.value['name']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? isDark 
                                          ? Colors.pink.shade200
                                          : const Color(0xFF059669)
                                      : isDark 
                                          ? Colors.pink.shade100
                                          : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
} 