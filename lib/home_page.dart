import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../models/note.dart';
import '../services/note_service.dart';
import '../widgets/note_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/language_selector.dart';
import '../widgets/category_selector.dart';
import '../widgets/totoro_background.dart';
import 'note_page.dart';
import 'app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'all';
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
    final appState = Provider.of<AppState>(context, listen: false);
    final lang = appState.lang;
    final noteService = Provider.of<NoteService>(context, listen: false);
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _localized[lang]!['newNote']!,
      content: '',
      total: 0,
      date: DateTime.now(),
      category: _selectedCategory != 'all' ? _selectedCategory : null,
    );
    noteService.addNote(newNote);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            NotePage(note: newNote),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
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
      final matchesCategory = _selectedCategory == 'all' || note.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark ? [
              const Color(0xFF831843), // Dark pink
              const Color(0xFF7C2D12), // Dark brown
              const Color(0xFF831843), // Dark pink
            ] : [
              const Color(0xFFFDF2F8), // Light pink
              const Color(0xFFF0F9FF), // Light blue
              const Color(0xFFFFFFFF), // White
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
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -50 * (1 - _headerAnimation.value)),
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
                                                  gradient: LinearGradient(
                                                    colors: isDark ? [
                                                      Colors.pink.shade400,
                                                      Colors.pink.shade600,
                                                    ] : [
                                                      Colors.pink.shade300,
                                                      Colors.pink.shade500,
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.pink.shade200.withOpacity(0.5),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.pets,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              ShaderMask(
                                                shaderCallback: (bounds) => LinearGradient(
                                                  colors: isDark ? [
                                                    Colors.white,
                                                    Colors.pink.shade200,
                                                  ] : [
                                                    Colors.pink.shade700,
                                                    Colors.pink.shade500,
                                                  ],
                                                ).createShader(bounds),
                                                child: Text(
                                                  _localized[lang]!['title']!,
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          LanguageSelector(
                                            currentLang: lang,
                                            onLanguageChanged: (newLang) {
                                              if (newLang != lang) {
                                                appState.setLang(newLang);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Search and category
                                      Column(
                                        children: [
                                          SearchBarWidget(
                                            value: _searchQuery,
                                            onChanged: (value) {
                                              setState(() {
                                                _searchQuery = value;
                                              });
                                            },
                                            placeholder: _localized[lang]!['search']!,
                                          ),
                                          const SizedBox(height: 12),
                                          CategorySelector(
                                            selectedCategory: _selectedCategory,
                                            onSelectCategory: (category) {
                                              setState(() {
                                                _selectedCategory = category;
                                              });
                                            },
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
                      );
                    },
                  ),
                  
                  // Notes grid
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: filteredNotes.isEmpty
                          ? _buildEmptyState(isDark)
                          : _buildNotesGrid(filteredNotes, isDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button with playful animation
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark ? [
                    Colors.pink.shade500,
                    Colors.pink.shade600,
                  ] : [
                    Colors.pink.shade400,
                    Colors.pink.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade200.withOpacity(0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: _createNewNote,
                  onTapDown: (_) => _fabAnimationController.forward(),
                  onTapUp: (_) => _fabAnimationController.reverse(),
                  onTapCancel: () => _fabAnimationController.reverse(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark ? [
                        Colors.pink.shade500.withOpacity(0.1),
                        Colors.pink.shade700.withOpacity(0.1),
                      ] : [
                        Colors.pink.shade300.withOpacity(0.1),
                        Colors.pink.shade500.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Center(
                    child: Text(
                      '🐻',
                      style: TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isNotEmpty
                ? _localized[lang]!['noSearch']!
                : _localized[lang]!['noNotes']!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.pink.shade200 : Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesGrid(List<Note> notes, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 
                       MediaQuery.of(context).size.width > 800 ? 3 : 
                       MediaQuery.of(context).size.width > 600 ? 2 : 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: NoteCard(
                  note: notes[index],
                  lang: lang,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => 
                            NotePage(note: notes[index]),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutCubic;

                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}