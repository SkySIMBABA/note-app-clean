import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import '../services/expression_service.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String _lang = 'zh';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  late AnimationController _totoroAnimationController;
  late Animation<Offset> _totoroAnimation;

  final Map<String, Map<String, String>> _localized = {
    'zh': {
      'title': '朵朵计算',
      'search': '搜索笔记...',
      'new_note': '新笔记',
      'change_bg': '更换背景',
      'select_lang': '选择语言',
      'no_notes': '暂无笔记，点击右下角 + 创建',
      'no_search': '没有找到匹配的笔记',
      'rename_note': '重命名笔记',
      'note_name_hint': '请输入新的笔记名称',
      'cancel': '取消',
      'rename': '重命名',
      'delete_note': '删除笔记',
      'delete_confirm': '确定要删除这个笔记吗？',
      'delete': '删除',
      'total': '总计',
    },
    'en': {
      'title': 'Cloud Calculator',
      'search': 'Search notes...',
      'new_note': 'New Note',
      'change_bg': 'Change Background',
      'select_lang': 'Select Language',
      'no_notes': 'No notes found, click the + button to create a new one',
      'no_search': 'No notes found matching the search',
      'rename_note': 'Rename Note',
      'note_name_hint': 'Enter new note name',
      'cancel': 'Cancel',
      'rename': 'Rename',
      'delete_note': 'Delete Note',
      'delete_confirm': 'Are you sure you want to delete this note?',
      'delete': 'Delete',
      'total': 'Total',
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Slower animation
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 0), // Start at original position
      end: const Offset(0, -0.1), // Move up by 10% of height
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)) // Smooth curve
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward(); // Start animation

    _totoroAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Slightly different speed
    );
    _totoroAnimation = Tween<Offset>(
      begin: const Offset(0, 0), // Start at original position
      end: const Offset(0, -0.05), // Move up slightly less
    ).animate(CurvedAnimation(parent: _totoroAnimationController, curve: Curves.easeInOut)) // Smooth curve
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _totoroAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _totoroAnimationController.forward();
        }
      });
    _totoroAnimationController.forward(); // Start animation
  }

  @override
  void dispose() {
    _animationController.dispose();
    _totoroAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_localized[_lang]!['select_lang']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('简体中文'),
              onTap: () => setState(() {
                _lang = 'zh';
                                Navigator.pop(context);
              }),
            ),
            ListTile(
              title: const Text('English'),
              onTap: () => setState(() {
                _lang = 'en';
                                Navigator.pop(context);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _renameNote(Note note) async {
    final nameController = TextEditingController(text: note.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_localized[_lang]!['rename_note']!),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(hintText: _localized[_lang]!['note_name_hint']),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(_localized[_lang]!['cancel']!)),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: Text(_localized[_lang]!['rename']!),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      note.name = newName;
      await context.read<NoteService>().updateNote(note);
    }
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_localized[_lang]!['delete_note']!),
        content: Text(_localized[_lang]!['delete_confirm']!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_localized[_lang]!['cancel']!),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_localized[_lang]!['delete']!),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await context.read<NoteService>().deleteNote(note.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteService = Provider.of<NoteService>(context);
    final notes = noteService.notes;

    final filteredNotes = notes.where((note) {
      final matchesSearch = note.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5), // Lighter pink bubble background
            borderRadius: BorderRadius.circular(25), // More rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08), // Softer shadow
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // To wrap content
            children: [
              Text(
                _localized[_lang]!['title']!,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface, // Text color set to onSurface
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10), // Spacing between title and icon
              SlideTransition(
                position: _totoroAnimation,
                child: Image.asset(
                  'assets/images/totoro.png',
                  width: 40, // Adjust size as needed
                  height: 40,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0), // Add padding to the right
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5), // Lighter pink bubble background
                borderRadius: BorderRadius.circular(25), // More rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08), // Softer shadow
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.language, color: Theme.of(context).colorScheme.onSecondary), // Themed icon color
                onPressed: _showLanguageDialog,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack( // Use Stack to place image behind content
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Your Totoro background image
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: kToolbarHeight + 24), // Increased space for a softer feel
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20), // Increased horizontal margin
                padding: const EdgeInsets.all(18), // Increased padding
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95), // Slightly more opaque
                  borderRadius: BorderRadius.circular(30), // More rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08), // Softer shadow
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: _localized[_lang]!['search'],
                        hintStyle: TextStyle(color: Colors.grey[500]), // Softer hint text
                        prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary), // Themed icon
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22), // More rounded search bar
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FDFE), // Very light fill color
                        contentPadding: const EdgeInsets.symmetric(vertical: 14), // Adjusted padding
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Increased space before note list
              Expanded(
                child: filteredNotes.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isNotEmpty
                              ? _localized[_lang]!['no_search']!
                              : _localized[_lang]!['no_notes']!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]), // Softer text style
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjusted padding
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // Changed to 4 columns as requested
                          crossAxisSpacing: 18, // Spacing between columns
                          mainAxisSpacing: 18, // Spacing between rows
                          childAspectRatio: 0.9, // Adjust aspect ratio for better card appearance
                        ),
                        itemCount: filteredNotes.length,
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          final total = ExpressionService.calculateTotal(note.content);

                          return Card(
                            margin: EdgeInsets.zero, // Removed margin as GridView handles spacing
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)), // More rounded
                            elevation: 8, // Slightly more pronounced shadow for bubble effect
                            shadowColor: Colors.black.withOpacity(0.12), // Consistent shadow color
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotePage(note: note, lang: _lang),
                                ),
                              ).then((_) => setState(() {})),
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.white.withOpacity(0.95), // Themed bottom sheet
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                                  ),
                                  builder: (context) => Wrap(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary), // Themed icon
                                        title: Text(_localized[_lang]!['rename_note']!),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _renameNote(note);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.error), // Themed icon for delete
                                        title: Text(_localized[_lang]!['delete_note']!),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _deleteNote(note);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(24), // Increased padding
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.name,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onSurface,
                                      ), // Larger and themed text
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (note.content.isNotEmpty) ...[
                                      const SizedBox(height: 6), // Adjusted spacing
                                      Text(
                                        note.content,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]), // Themed text
                                      ),
                                    ],
                                    if (total > 0) ...[
                                      const SizedBox(height: 8), // Spacing for total
                                      Text(
                                        '${_localized[_lang]!['total']!}: ${ExpressionService.formatNumber(total)}',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: theme.colorScheme.secondary, // Themed total color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: SlideTransition(
        position: _animation,
        child: FloatingActionButton(
          onPressed: () async {
            final note = Note(
              name: _localized[_lang]!['new_note']!,
              category: null,
            );
            await context.read<NoteService>().addNote(note);
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotePage(note: note, lang: _lang),
                ),
              );
            }
          },
          backgroundColor: Theme.of(context).colorScheme.primary, // Themed FAB
          child: Image.asset(
            'assets/images/leaf.png', // Your leaf image
            width: 30, // Adjust size as needed
            height: 30,
          ),
          elevation: 6, // Increased FAB elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded corners for bubble effect
          ),
        ),
      ),
    );
  }
} 