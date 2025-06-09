import 'package:flutter/material.dart';
import '../services/expression_service.dart';

class HighlightedTextController extends TextEditingController {
  HighlightedTextController({String? text}) : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    final String fullText = value.text;
    final List<String> expressions = ExpressionService.extractExpressions(fullText);

    int lastIndex = 0;
    for (final expr in expressions) {
      final int startIndex = fullText.indexOf(expr, lastIndex);
      if (startIndex != -1) {
        // Add non-highlighted text before the expression
        if (startIndex > lastIndex) {
          children.add(TextSpan(
            text: fullText.substring(lastIndex, startIndex),
            style: style,
          ));
        }

        // Add highlighted expression
        children.add(TextSpan(
          text: expr,
          style: style?.copyWith(color: Colors.blue[700]) ?? TextStyle(color: Colors.blue[700]),
        ));

        lastIndex = startIndex + expr.length;
      }
    }

    // Add any remaining non-highlighted text
    if (lastIndex < fullText.length) {
      children.add(TextSpan(
        text: fullText.substring(lastIndex, fullText.length),
        style: style,
      ));
    }

    return TextSpan(style: style, children: children);
  }
} 