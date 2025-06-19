import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../models/note.dart';
import '../services/expression_service.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final String lang;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.lang,
    required this.onTap,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> with TickerProviderStateMixin {
  late AnimationController _hoverAnimationController;
  late AnimationController _floatAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _floatAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _hoverAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _floatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _floatAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _floatAnimationController.repeat();
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    _floatAnimationController.dispose();
    super.dispose();
  }

  String _formatTotal(double total) {
    return ExpressionService.formatNumber(total);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final double total = ExpressionService.calculateTotal(widget.note.content);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _hoverAnimationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _hoverAnimationController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _hoverAnimationController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _floatAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.translate(
              offset: Offset(
                math.sin(_floatAnimation.value * 2 * math.pi) * 2,
                math.sin(_floatAnimation.value * 2 * math.pi + 1) * 3,
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.pink.shade900.withOpacity(0.2)
                            : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: isDark
                              ? Colors.pink.shade700.withOpacity(0.4)
                              : Colors.pink.shade100.withOpacity(0.4),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.pink.shade800.withOpacity(0.3)
                                : Colors.pink.shade100.withOpacity(0.3),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            left: 8,
                            child: GestureDetector(
                              onTap: () {
                                widget.note.togglePin();
                                context.read<NoteService>().updateNote(widget.note);
                              },
                              child: Icon(
                                widget.note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                                size: 20,
                                color: isDark ? Colors.yellowAccent : Colors.grey,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _floatAnimation.value * 2 * math.pi * 0.1,
                                  child: Opacity(
                                    opacity: 0.05,
                                    child: Transform.scale(
                                      scale: 1.0 + math.sin(_floatAnimation.value * 2 * math.pi) * 0.1,
                                      child: const Text(
                                        '✨',
                                        style: TextStyle(fontSize: 60),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _floatAnimation,
                                      builder: (context, child) {
                                        return Transform.rotate(
                                          angle: math.sin(_floatAnimation.value * 2 * math.pi) * 0.1,
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: isDark
                                                    ? [Colors.pink.shade600.withOpacity(0.3), Colors.pink.shade700.withOpacity(0.2)]
                                                    : [Colors.pink.shade200.withOpacity(0.3), Colors.pink.shade300.withOpacity(0.2)],
                                              ),
                                              borderRadius: BorderRadius.circular(18),
                                            ),
                                            child: Center(
                                              child: Text(
                                                widget.note.icon,
                                                style: const TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.note.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: isDark ? Colors.pink.shade100 : Colors.pink.shade800,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 12,
                                                color: isDark ? Colors.pink.shade300 : Colors.pink.shade400,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                widget.lang == 'zh'
                                                    ? '${widget.note.createdAt.month}月${widget.note.createdAt.day}日'
                                                    : '${widget.note.createdAt.month}/${widget.note.createdAt.day}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark ? Colors.pink.shade300 : Colors.pink.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (widget.note.content.isNotEmpty) ...[
                                  Text(
                                    widget.note.content,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? Colors.pink.shade200.withOpacity(0.7) : Colors.pink.shade600,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                if (total > 0) ...[
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AnimatedBuilder(
                                      animation: _floatAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: 1.0 + math.sin(_floatAnimation.value * 4 * math.pi) * 0.02,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: isDark
                                                    ? [Colors.pink.shade500, Colors.pink.shade600]
                                                    : [Colors.pink.shade400, Colors.pink.shade600],
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
                                            child: Text(
                                              '¥${_formatTotal(total)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -8,
                            right: -8,
                            child: AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _floatAnimation.value * 2 * math.pi * 0.2,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.pink.shade600.withOpacity(0.3) : Colors.pink.shade200.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: -4,
                            left: -4,
                            child: AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: -_floatAnimation.value * 2 * math.pi * 0.15,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.pink.shade500.withOpacity(0.4) : Colors.pink.shade100.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                            ),
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
    );
  }
} 