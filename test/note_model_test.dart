import 'package:flutter_test/flutter_test.dart';
import 'package:new_note_calc_app/models/note.dart';

void main() {
  group('Note JSON serialization', () {
    test('toJson and fromJson preserves icon', () {
      final note = Note(name: 'Test', icon: '✈️');
      final json = note.toJson();
      expect(json['icon'], '✈️');
      final note2 = Note.fromJson(json);
      expect(note2.icon, '✈️');
    });

    test('fromJson assigns default icon when missing', () {
      final now = DateTime.now().toIso8601String();
      final json = {
        'id': '1',
        'name': 'NoIcon',
        'content': '',
        'createdAt': now,
        'modifiedAt': now,
        'tags': <String>[],
        'isPinned': false,
        'category': null,
        // no 'icon'
      };
      final note = Note.fromJson(json);
      expect(note.icon, '📝');
    });
  });
} 