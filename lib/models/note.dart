import 'package:uuid/uuid.dart';

class Note {
  final String id;
  String name;
  String content;
  DateTime createdAt;
  DateTime modifiedAt;
  List<String> tags;
  bool isPinned;
  String? category;

  Note({
    String? id,
    required this.name,
    this.content = '',
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
    this.isPinned = false,
    this.category,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now(),
        tags = tags ?? [];

  void updateContent(String newContent) {
    content = newContent;
    modifiedAt = DateTime.now();
  }

  void updateName(String newName) {
    name = newName;
    modifiedAt = DateTime.now();
  }

  void addTag(String tag) {
    if (!tags.contains(tag)) {
      tags.add(tag);
      modifiedAt = DateTime.now();
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
    modifiedAt = DateTime.now();
  }

  void togglePin() {
    isPinned = !isPinned;
    modifiedAt = DateTime.now();
  }

  void setCategory(String? newCategory) {
    category = newCategory;
    modifiedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt.toIso8601String(),
        'tags': tags,
        'isPinned': isPinned,
        'category': category,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        name: json['name'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        modifiedAt: DateTime.parse(json['modifiedAt'] as String),
        tags: List<String>.from(json['tags'] as List),
        isPinned: json['isPinned'] as bool,
        category: json['category'] as String?,
      );
} 