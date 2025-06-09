import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService with ChangeNotifier {
  static const String _storageKey = 'notes';
  final SharedPreferences _prefs;
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NoteService(this._prefs) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final String? notesJson = _prefs.getString(_storageKey);
    if (notesJson != null) {
      final List<dynamic> decoded = jsonDecode(notesJson);
      _notes = decoded.map((json) => Note.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> saveNotes() async {
    final String encoded = jsonEncode(_notes.map((note) => note.toJson()).toList());
    await _prefs.setString(_storageKey, encoded);
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    await saveNotes();
  }

  Future<void> updateNote(Note updatedNote) async {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      await saveNotes();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await saveNotes();
  }

  List<Note> searchNotes(String query) {
    query = query.toLowerCase();
    return _notes.where((note) {
      return note.name.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          note.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  List<String> getAllCategories() {
    return _notes
        .map((note) => note.category)
        .where((category) => category != null)
        .map((category) => category!)
        .toSet()
        .toList();
  }

  List<String> getAllTags() {
    return _notes
        .expand((note) => note.tags)
        .toSet()
        .toList();
  }
} 