import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class TotoroBackground extends StatefulWidget {
  const TotoroBackground({super.key});

  @override
  State<TotoroBackground> createState() => _TotoroBackgroundState();
}

class _TotoroBackgroundState extends State<TotoroBackground>
    with TickerProviderStateMixin {
  late AnimationController _swayController;
  late AnimationController _floatController;
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();
    
    // Playful animation controllers with enhanced timing
    _swayController = AnimationController(
      duration: const Duration(seconds: 6), // Slower for more peaceful feel
      vsync: this,
    )..repeat();
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 8), // Slower floating
      vsync: this,
    )..repeat();
    
    _bounceController = AnimationController(
      duration: const Duration(seconds: 5), // Slower bouncing
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    )..repeat();
    
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _swayController.dispose();
    _floatController.dispose();
    _bounceController.dispose();
    _pulseController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        // Large trees with enhanced sway animation
        AnimatedBuilder(
          animation: _swayController,
          builder: (context, child) {
            return Positioned(
              bottom: 0,
              left: 40,
              child: Transform.rotate(
                angle: math.sin(_swayController.value * 2 * math.pi) * 0.08, // More pronounced sway
                child: Opacity(
                  opacity: isDark ? 0.15 : 0.1,
                  child: const Text(
                    '🌲',
                    style: TextStyle(fontSize: 140), // Larger trees
                  ),
                ),
              ),
            );
          },
        ),
        
        AnimatedBuilder(
          animation: _swayController,
          builder: (context, child) {
            return Positioned(
              bottom: 0,
              right: 80,
              child: Transform.rotate(
                angle: math.sin((_swayController.value + 0.5) * 2 * math.pi) * 0.08,
                child: Opacity(
                  opacity: isDark ? 0.15 : 0.1,
                  child: const Text(
                    '🌳',
                    style: TextStyle(fontSize: 160),
                  ),
                ),
              ),
            );
          },
        ),

        // More floating leaves with enhanced movement
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: 80 + math.sin(_floatController.value * 2 * math.pi) * 30, // More movement
              left: MediaQuery.of(context).size.width * 0.25,
              child: Transform.rotate(
                angle: _floatController.value * 4 * math.pi, // Faster rotation
                child: Opacity(
                  opacity: isDark ? 0.4 : 0.3,
                  child: const Text(
                    '🍃',
                    style: TextStyle(fontSize: 36), // Larger leaves
                  ),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: 160 + math.sin((_floatController.value + 0.3) * 2 * math.pi) * 25,
              right: MediaQuery.of(context).size.width * 0.25,
              child: Transform.rotate(
                angle: (_floatController.value + 0.3) * 3 * math.pi,
                child: Opacity(
                  opacity: isDark ? 0.4 : 0.3,
                  child: const Text(
                    '🍂',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
            );
          },
        ),

        // Additional floating elements
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: 240 + math.sin((_floatController.value + 0.6) * 2 * math.pi) * 20,
              left: MediaQuery.of(context).size.width * 0.7,
              child: Transform.rotate(
                angle: (_floatController.value + 0.6) * 2 * math.pi,
                child: Opacity(
                  opacity: isDark ? 0.3 : 0.25,
                  child: const Text(
                    '🌿',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),

        // Enhanced Totoro silhouette with more playful movement
        AnimatedBuilder(
          animation: Listenable.merge([_floatController, _pulseController]),
          builder: (context, child) {
            return Positioned(
              bottom: MediaQuery.of(context).size.height * 0.3 + 
                     math.sin(_floatController.value * 2 * math.pi) * 15,
              left: MediaQuery.of(context).size.width * 0.1 + 
                    math.cos(_floatController.value * 2 * math.pi) * 10,
              child: Transform.scale(
                scale: 1.0 + math.sin(_pulseController.value * 2 * math.pi) * 0.1,
                child: Opacity(
                  opacity: isDark ? 0.08 : 0.05,
                  child: const Text(
                    '🐻',
                    style: TextStyle(fontSize: 120),
                  ),
                ),
              ),
            );
          },
        ),

        // Sparkles and magical elements
        AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.2 + 
                  math.sin(_sparkleController.value * 2 * math.pi) * 10,
              right: MediaQuery.of(context).size.width * 0.2,
              child: Transform.scale(
                scale: 0.8 + math.sin(_sparkleController.value * 4 * math.pi) * 0.3,
                child: Opacity(
                  opacity: (0.3 + math.sin(_sparkleController.value * 3 * math.pi) * 0.2).clamp(0.0, 1.0),
                  child: const Text(
                    '✨',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.6 + 
                  math.sin((_sparkleController.value + 0.5) * 2 * math.pi) * 8,
              left: MediaQuery.of(context).size.width * 0.8,
              child: Transform.scale(
                scale: 0.6 + math.sin((_sparkleController.value + 0.5) * 4 * math.pi) * 0.4,
                child: Opacity(
                  opacity: (0.2 + math.sin((_sparkleController.value + 0.5) * 3 * math.pi) * 0.3).clamp(0.0, 1.0),
                  child: const Text(
                    '⭐',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
          },
        ),

        // Enhanced bouncing nature elements
        AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            return Positioned(
              bottom: 16 + math.sin(_bounceController.value * 2 * math.pi).abs() * 40,
              left: 16,
              child: Transform.rotate(
                angle: math.sin(_bounceController.value * 2 * math.pi) * 0.2,
                child: Opacity(
                  opacity: isDark ? 0.3 : 0.2,
                  child: const Text(
                    '🌿',
                    style: TextStyle(fontSize: 52),
                  ),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.3 + 
                   math.sin((_bounceController.value + 0.5) * 2 * math.pi).abs() * 25,
              right: 32,
              child: Transform.rotate(
                angle: math.sin((_bounceController.value + 0.5) * 2 * math.pi) * 0.3,
                child: Opacity(
                  opacity: isDark ? 0.3 : 0.25,
                  child: const Text(
                    '🍃',
                    style: TextStyle(fontSize: 36),
                  ),
                ),
              ),
            );
          },
        ),

        // Enhanced soot sprites with more playful movement
        AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.4 + 
                   math.sin(_bounceController.value * 2 * math.pi).abs() * 15,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.pink.shade300 : Colors.grey.shade800).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? Colors.pink.shade200 : Colors.grey.shade600).withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.5 + 
                   math.sin((_bounceController.value + 0.3) * 2 * math.pi).abs() * 12,
              right: MediaQuery.of(context).size.width * 0.3,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.pink.shade300 : Colors.grey.shade800).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),

        // Gradient overlays for enhanced depth
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark ? [
                Colors.pink.shade900.withOpacity(0.1),
                Colors.transparent,
                Colors.pink.shade800.withOpacity(0.1),
              ] : [
                Colors.pink.shade100.withOpacity(0.2),
                Colors.transparent,
                Colors.pink.shade50.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 