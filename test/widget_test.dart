// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_note_calc_app/main.dart';

void main() {
  setUp(() async {
    // Initialize mock storage so SharedPreferences.getInstance() works in tests
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App launches and shows FAB', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Icon picker sheet appears when FAB is tapped', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(MyApp(sharedPreferences: prefs));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    // Expect at least the default icon in the grid
    expect(find.text('📝'), findsWidgets);
  });
}
