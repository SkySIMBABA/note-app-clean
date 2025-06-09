import 'package:math_expressions/math_expressions.dart';

// Represents the result of a single calculated expression
class ExpressionResult {
  final String expression;
  final double result;
  final String category;

  ExpressionResult({
    required this.expression,
    required this.result,
    required this.category,
  });
}

class ExpressionService {
  static List<String> extractExpressions(String text) {
    // Updated regex to capture more complete mathematical expressions, including parentheses.
    // It looks for a sequence starting with a number or a parenthesized expression,
    // followed by zero or more occurrences of an operator then another number or parenthesized expression.
    final regex = RegExp(r'((?:\d+(?:\.\d+)?|\([^()]*\))\s*(?:[+\-*\/]\s*(?:\d+(?:\.\d+)?|\([^()]*\)))*)');

    return regex
        .allMatches(text)
        .map((m) => m.group(0)!.trim())
        .where((s) => s.isNotEmpty && (s.contains(RegExp(r'\d')) || s.contains(RegExp(r'[+\-*\/]')) || s.contains(RegExp(r'[\(\)]'))))
        .toList();
  }

  static double calculateTotal(String text) {
    final expressions = extractExpressions(text);
    double total = 0;
    for (var expr in expressions) {
      try {
        total += evaluate(expr);
      } catch (_) {}
    }
    return total;
  }

  static double evaluate(String expr) {
    // 使用 math_expressions 库来求值
    try {
      Parser p = Parser();
      Expression exp = p.parse(expr.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      // 如果解析或评估失败，返回0.0或者抛出异常
      print("Error evaluating expression '$expr': $e");
      return 0.0;
    }
  }

  static String formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2);
  }
}
