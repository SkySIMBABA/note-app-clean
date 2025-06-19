import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/note.dart';
import '../services/note_service.dart';
import '../services/expression_service.dart';
import '../widgets/highlighted_text_controller.dart';
import '../app_state.dart';

class NotePage extends StatefulWidget {
  final Note note;

  const NotePage({super.key, required this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController _nameController;
  late HighlightedTextController _contentController;
  Timer? _debounce;
  List<ExpressionResult> _calculatedExpressions = [];
  double _totalResult = 0.0;

  final Map<String, Map<String, String>> _localized = {
    'zh': {
      'note_name_hint': '笔记名称',
      'note_content': '在这里写下你的笔记和账单，例如：\n午餐 100/2\n晚餐 50+60',
      'delete_note': '删除笔记',
      'delete_confirm': '确定要删除吗？',
      'cancel': '取消',
      'delete': '删除',
      'calculation_results': '计算结果',
      'total': '总计',
      'no_expressions': '没有检测到可计算的表达式',
      'add_tag_hint': '添加标签',
    },
    'en': {
      'note_name_hint': 'Note title',
      'note_content': 'Write your notes and bills here, e.g.:\nLunch 100/2\nDinner 50+60',
      'delete_note': 'Delete Note',
      'delete_confirm': 'Are you sure you want to delete?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'calculation_results': 'Calculation Results',
      'total': 'Total',
      'no_expressions': 'No calculable expressions detected',
      'add_tag_hint': 'Add tag',
    }
  };

  String get lang => Provider.of<AppState>(context).lang;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.note.name);
    _contentController = HighlightedTextController(text: widget.note.content);

    _nameController.addListener(_onChanged);
    _contentController.addListener(_onChanged);

    _performCalculations(); // Initial calculation on load
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _saveNote();
      _performCalculations(); // Recalculate on content change
    });
  }

  void _saveNote() {
    final noteService = context.read<NoteService>();
    widget.note.name = _nameController.text;
    widget.note.content = _contentController.text;
    widget.note.modifiedAt = DateTime.now();
    noteService.updateNote(widget.note);
  }

  void _performCalculations() {
    final expressions = ExpressionService.extractExpressions(_contentController.text);
    final List<ExpressionResult> results = [];
    double total = 0.0;

    for (final expr in expressions) {
      final result = ExpressionService.evaluate(expr);
      results.add(ExpressionResult(
        expression: expr,
        result: result,
        category: '', // Category is not used for individual expressions
      ));
      total += result;
    }

    setState(() {
      _calculatedExpressions = results;
      _totalResult = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.note.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _nameController,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  cursorColor: isDark ? Colors.white : Colors.black87,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _localized[lang]!['note_name_hint'],
                    hintStyle: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: (isDark ? Colors.white : Colors.black87).withOpacity(0.5),
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.15),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  maxLines: 1,
                  onTap: () {
                    _nameController.selection = TextSelection(baseOffset: 0, extentOffset: _nameController.text.length);
                  },
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: theme.colorScheme.error), // Themed delete icon
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(_localized[lang]!['delete_note']!),
                  content: Text(_localized[lang]!['delete_confirm']!),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(_localized[lang]!['cancel']!, style: TextStyle(color: theme.colorScheme.secondary)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(_localized[lang]!['delete']!, style: TextStyle(color: theme.colorScheme.error)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await context.read<NoteService>().deleteNote(widget.note.id);
                if (mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark ? [
              const Color(0xFF831843), // Dark pink
              const Color(0xFF7C2D12), // Dark brown
              const Color(0xFF831843), // Dark pink
            ] : [
              const Color(0xFFFDF2F8), // Light pink
              const Color(0xFFF0F9FF), // Light blue
              const Color(0xFFFFFFFF), // White
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Increased padding
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12), // Inner padding for the text field area
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _contentController,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          cursorColor: isDark ? Colors.white : Colors.black87,
                          decoration: InputDecoration(
                            hintText: _localized[lang]!['note_content'],
                            hintStyle: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Tag chips
                    Wrap(
                      spacing: 8,
                      children: widget.note.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          onDeleted: () {
                            setState(() {
                              widget.note.removeTag(tag);
                              _saveNote();
                            });
                          },
                        );
                      }).toList(),
                    ),
                    // Tag input
                    TextField(
                      decoration: InputDecoration(
                        hintText: _localized[lang]!['add_tag_hint'],
                        prefixIcon: const Icon(Icons.label),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onSubmitted: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            widget.note.addTag(val);
                            _saveNote();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(width: 2, thickness: 1, color: theme.colorScheme.outlineVariant.withOpacity(0.5)), // Softer divider
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45, // Adjusted width for results
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_localized[lang]!['calculation_results']!, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onSurface)),
                    const SizedBox(height: 12), // Adjusted spacing
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12), // Inner padding for the results area
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _calculatedExpressions.isEmpty
                            ? Center(
                                child: Text(
                                  _localized[lang]!['no_expressions']!,
                                  style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                itemCount: _calculatedExpressions.length,
                                itemBuilder: (context, index) {
                                  final exprResult = _calculatedExpressions[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0), // Adjusted padding
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${exprResult.expression} = ',
                                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant), // Softer color for expression
                                          ),
                                          TextSpan(
                                            text: ExpressionService.formatNumber(exprResult.result),
                                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary), // Slightly larger and themed result
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_localized[lang]!['total']!}: ${ExpressionService.formatNumber(_totalResult)}',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface), // Themed total
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Let user pick a new icon for the note
  Future<String?> _pickIcon() {
    const icons = ['📝','🍽️','🛍️','✈️','💼','💭'];
    return showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        final current = widget.note.icon;
        final themeCtx = Theme.of(ctx);
        return SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 4,
            children: icons.map((icon) {
              final isSelected = icon == current;
              return GestureDetector(
                onTap: () => Navigator.pop(ctx, icon),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: themeCtx.colorScheme.primary, width: 3) : null,
                  ),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 32))),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}