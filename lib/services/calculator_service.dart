import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  static double? calculate(String expression) {
    try {
      // Clean the expression
      expression = expression.trim();
      if (expression.isEmpty) return null;

      // Replace common math functions
      expression = expression
          .replaceAll('sqrt', 'sqrt')
          .replaceAll('^', 'pow')
          .replaceAll('π', 'pi')
          .replaceAll('e', 'e');

      // Parse and evaluate the expression
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Handle special cases
      if (result.isInfinite || result.isNaN) {
        return null;
      }

      return result;
    } catch (e) {
      return null;
    }
  }

  static String formatNumber(double number) {
    if (number == number.toInt()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2);
  }

  static bool isValidExpression(String expression) {
    try {
      Parser p = Parser();
      p.parse(expression);
      return true;
    } catch (e) {
      return false;
    }
  }

  static List<String> getSupportedOperations() {
    return [
      'Basic: +, -, *, /',
      'Power: ^ (e.g., 2^3)',
      'Square root: sqrt (e.g., sqrt(16))',
      'Constants: π, e',
      'Parentheses: ( )',
      'Functions: sin, cos, tan, log, ln',
    ];
  }
} 