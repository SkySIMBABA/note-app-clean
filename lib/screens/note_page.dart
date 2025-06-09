import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/note.dart';
import '../services/note_service.dart';
import '../services/expression_service.dart';
import '../widgets/highlighted_text_controller.dart';

class NotePage extends StatefulWidget {
  final Note note;
  final String lang;

  const NotePage({super.key, required this.note, required this.lang});

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
      'note_content': '在这里写下你的笔记和账单，例如：\n午餐 100/2\n晚餐 50+60',
      'delete_note': '删除笔记',
      'delete_confirm': '确定要删除吗？',
      'cancel': '取消',
      'delete': '删除',
      'calculation_results': '计算结果',
      'total': '总计',
      'no_expressions': '没有检测到可计算的表达式',
    },
    'en': {
      'note_content': 'Write your notes and bills here, e.g.:\nLunch 100/2\nDinner 50+60',
      'delete_note': 'Delete Note',
      'delete_confirm': 'Are you sure you want to delete?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'calculation_results': 'Calculation Results',
      'total': 'Total',
      'no_expressions': 'No calculable expressions detected',
    }
  };

  String get lang => widget.lang; // Use the passed language

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
    
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background for NotePage
      appBar: AppBar(
        title: TextField(
          controller: _nameController,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface), // Themed title style
          decoration: InputDecoration(
            border: InputBorder.none, // No border for the TextField
            hintText: _localized[lang]!['note_name_hint'], // You might want to add this to _localized map
            hintStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ),
          maxLines: 1,
          onTap: () { // Select all text on tap
            _nameController.selection = TextSelection(baseOffset: 0, extentOffset: _nameController.text.length);
          },
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
      body: Row(
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
                        color: theme.colorScheme.surface.withOpacity(0.8), // Soft background for input
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
                        decoration: InputDecoration(
                          hintText: _localized[lang]!['note_content'], // Use hintText instead of labelText
                          hintStyle: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic), // Softer hint
                          border: InputBorder.none, // No border
                          contentPadding: EdgeInsets.zero, // Remove default content padding
                        ),
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
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
                        color: theme.colorScheme.surface.withOpacity(0.8), // Soft background for results
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
    );
  }
}