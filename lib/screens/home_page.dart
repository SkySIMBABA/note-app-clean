import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/note_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/language_selector.dart';
import '../widgets/tag_selector.dart';
import '../widgets/totoro_background.dart';
import 'note_page.dart';
import '../app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String _searchQuery = '';
  String? _selectedTag;
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _fabAnimation;
  late Animation<double> _headerAnimation;

  final Map<String, Map<String, String>> _localized = {
    'zh': {
      'title': '朵朵笔记',
      'search': '搜索笔记...',
      'newNote': '新笔记',
      'noNotes': '没有笔记，点击 + 创建',
      'noSearch': '没有找到匹配的笔记',
      'total': '总计',
      'settings': '设置',
    },
    'en': {
      'title': 'DUODUO Note',
      'search': 'Search notes...',
      'newNote': 'New Note',
      'noNotes': 'No notes yet, tap + to create',
      'noSearch': 'No matching notes found',
      'total': 'Total',
      'settings': 'Settings',
    },
  };

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fabAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    
    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerAnimationController, curve: Curves.easeOutBack),
    );
    
    // Start header animation
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _createNewNote() {
    // Show icon picker before creating
    _pickIcon().then((icon) {
      final noteService = Provider.of<NoteService>(context, listen: false);
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _localized['zh']!['newNote']!,
        content: '',
        icon: icon ?? '📝',
      );
      noteService.addNote(newNote);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => NotePage(note: newNote),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  Future<String?> _pickIcon() {
    const icons = ['📝','🍽️','🛍️','✈️','💼','💭'];
    return showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SizedBox(
        height: 200,
        child: GridView.count(
          crossAxisCount: 4,
          children: icons.map((icon) {
            return GestureDetector(
              onTap: () => Navigator.pop(ctx, icon),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 32))),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final noteService = Provider.of<NoteService>(context);
    final notes = noteService.notes;
    final appState = Provider.of<AppState>(context);
    final lang = appState.lang;

    final filteredNotes = notes.where((note) {
      final matchesSearch = note.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTag = _selectedTag == null || note.tags.contains(_selectedTag);
      return matchesSearch && matchesTag;
    }).toList();
    // Sort so pinned notes appear first
    filteredNotes.sort((a, b) => (b.isPinned ? 1 : 0) - (a.isPinned ? 1 : 0));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark ? [
              const Color(0xFF831843),
              const Color(0xFF7C2D12),
              const Color(0xFF831843),
            ] : [
              const Color(0xFFFDF2F8),
              const Color(0xFFFCE4EC),
              const Color(0xFFFDF2F8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background
            const TotoroBackground(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Animated header
                  AnimatedBuilder(
                    animation: _headerAnimation,
                    child: Opacity(
                      opacity: _headerAnimation.value.clamp(0.0, 1.0),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.pink.shade900.withOpacity(0.2)
                                    : Colors.pink.shade50.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.pink.shade800.withOpacity(0.2)
                                      : Colors.pink.shade200.withOpacity(0.6),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.pink.shade100.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Title and controls
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Image.asset('assets/images/totoro.png', height: 36),
                                          ),
                                          const SizedBox(width: 12),
                                          ShaderMask(
                                            shaderCallback: (bounds) => LinearGradient(
                                              colors: isDark ? [Colors.white, Colors.pink.shade200] : [Colors.pink.shade700, Colors.pink.shade500],
                                            ).createShader(bounds),
                                            child: Text(_localized[lang]!['title']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                      LanguageSelector(
                                        currentLang: lang,
                                        onLanguageChanged: (newLang){
                                          if (newLang != lang) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(newLang == 'zh' ? '已切换为中文' : 'Switched to English'),
                                                duration: Duration(milliseconds: 800),
                                              ),
                                            );
                                            appState.setLang(newLang);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Column(
                                    children: [
                                      SearchBarWidget(value: _searchQuery, onChanged: (val) => setState(() => _searchQuery = val), placeholder: _localized[lang]!['search']!),
                                      const SizedBox(height: 12),
                                      TagSelector(
                                        tags: noteService.getAllTags(),
                                        selectedTag: _selectedTag,
                                        onTagSelected: (tag) => setState(() => _selectedTag = tag),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                        child: child!,
                      );
                    },
                  ),
                  Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: filteredNotes.isEmpty ? _buildEmptyState(isDark) : _buildNotesGrid(filteredNotes, isDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: () {
                _fabAnimationController.forward().then((_) {
                  _fabAnimationController.reverse();
                });
                _createNewNote();
              },
              backgroundColor: isDark ? Colors.pink.shade400 : Colors.pink.shade600,
              child: Image.asset('assets/images/leaf.png', height: 28),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final appState = Provider.of<AppState>(context);
    final lang = appState.lang;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt,
            size: 64,
            color: isDark ? Colors.pink.shade300 : Colors.pink.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _localized[lang]!['noNotes']!,
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesGrid(List<Note> notes, bool isDark) {
    final appState = Provider.of<AppState>(context);
    final lang = appState.lang;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          lang: lang,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(note: note),
              ),
            );
          },
        );
      },
    );
  }
} 