import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _lang = 'zh';
  String get lang => _lang;

  void setLang(String lang) {
    if (_lang != lang) {
      _lang = lang;
      notifyListeners();
    }
  }
} 