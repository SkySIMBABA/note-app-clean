import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_note_calc_app/widgets/note_card.dart';
import 'package:new_note_calc_app/models/note.dart';

void main() {
  testWidgets('NoteCard displays provided icon and name', (WidgetTester tester) async {
    // Create a sample note
    final note = Note(
      id: 'test1',
      name: 'Sample',
      content: 'Content',
      icon: '🍽️',
    );

    // Pump the NoteCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteCard(
            note: note,
            lang: 'en',
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify icon and name are displayed
    expect(find.text('🍽️'), findsOneWidget);
    expect(find.text('Sample'), findsOneWidget);
  });
} 