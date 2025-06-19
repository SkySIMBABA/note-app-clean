import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteService with ChangeNotifier {
  static const String _storageKey = 'notes';
  final SharedPreferences _prefs;
  List<Note> _notes = [];
  
  // Return an unmodifiable list to prevent external modification
  List<Note> get notes => List.unmodifiable(_notes);

  NoteService(this._prefs) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final String? notesJson = _prefs.getString(_storageKey);
      if (notesJson != null) {
        final List<dynamic> decoded = jsonDecode(notesJson);
        _notes = decoded.map((json) => Note.fromJson(json)).toList();
        // Persist default icons for migrated notes
        await _saveNotes();
      }
      notifyListeners(); // Update UI after loading
    } catch (e) {
      // Handle deserialization errors gracefully
      _notes = [];
      debugPrint('Error loading notes: $e');
      notifyListeners();
    }
  }

  // Private save method for internal use only
  Future<void> _saveNotes() async {
    try {
      final String encoded = jsonEncode(_notes);
      await _prefs.setString(_storageKey, encoded);
    } catch (e) {
      debugPrint('Error saving notes: $e');
    }
  }

  Future<void> addNote(Note note) async {
    _notes.add(note);
    await _saveNotes();
    notifyListeners(); // Notify after save completes
  }

  Future<void> updateNote(Note updatedNote) async {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotes();
    notifyListeners();
  }

  // Optimized search with pre-lowered query
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return _notes;
    final lowerQuery = query.toLowerCase();
    return _notes.where((note) {
      return note.name.toLowerCase().contains(lowerQuery) ||
          note.content.toLowerCase().contains(lowerQuery) ||
          note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Null-safe category handling
  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  // Efficient category collection with null safety
  List<String> getAllCategories() {
    return _notes
        .map((note) => note.category)
        .whereType<String>() // Filter out nulls
        .toSet()
        .toList();
  }

  // More efficient tag collection
  List<String> getAllTags() {
    return _notes
        .expand((note) => note.tags)
        .toSet()
        .toList();
  }
} 