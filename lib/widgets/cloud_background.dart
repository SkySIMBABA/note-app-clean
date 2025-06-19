import 'package:flutter/material.dart';
import 'dart:math' as math;

class CloudBackground extends StatefulWidget {
  const CloudBackground({super.key});

  @override
  State<CloudBackground> createState() => _CloudBackgroundState();
}

class _CloudBackgroundState extends State<CloudBackground>
    with TickerProviderStateMixin {
  late AnimationController _driftController;
  late AnimationController _floatController;
  late AnimationController _twinkleController;

  @override
  void initState() {
    super.initState();
    
    _driftController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _twinkleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _driftController.dispose();
    _floatController.dispose();
    _twinkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Large drifting clouds
        AnimatedBuilder(
          animation: _driftController,
          builder: (context, child) {
            return Positioned(
              top: 60,
              left: -50 + (_driftController.value * MediaQuery.of(context).size.width * 0.3),
              child: Transform.scale(
                scale: 1.0 + math.sin(_driftController.value * 2 * math.pi) * 0.1,
                child: const Opacity(
                  opacity: 0.15,
                  child: Text(
                    '☁️',
                    style: TextStyle(fontSize: 120),
                  ),
                ),
              ),
            );
          },
        ),
        
        AnimatedBuilder(
          animation: _driftController,
          builder: (context, child) {
            return Positioned(
              top: 120,
              right: -80 + (math.sin((_driftController.value + 0.5) * 2 * math.pi) * 50),
              child: Transform.scale(
                scale: 0.8 + math.cos(_driftController.value * 2 * math.pi) * 0.1,
                child: const Opacity(
                  opacity: 0.12,
                  child: Text(
                    '☁️',
                    style: TextStyle(fontSize: 100),
                  ),
                ),
              ),
            );
          },
        ),

        // Medium clouds
        AnimatedBuilder(
          animation: _driftController,
          builder: (context, child) {
            return Positioned(
              top: 200,
              left: MediaQuery.of(context).size.width * 0.6 + 
                   math.sin((_driftController.value + 0.3) * 2 * math.pi) * 30,
              child: const Opacity(
                opacity: 0.1,
                child: Text(
                  '☁️',
                  style: TextStyle(fontSize: 80),
                ),
              ),
            );
          },
        ),

        // Floating sky elements
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: 100 + math.sin(_floatController.value * 2 * math.pi) * 15,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Transform.rotate(
                angle: _floatController.value * 0.5,
                child: const Opacity(
                  opacity: 0.3,
                  child: Text(
                    '🌤️',
                    style: TextStyle(fontSize: 28),
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
              top: 180 + math.sin((_floatController.value + 0.4) * 2 * math.pi) * 12,
              right: MediaQuery.of(context).size.width * 0.15,
              child: const Opacity(
                opacity: 0.25,
                child: Text(
                  '⛅',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            );
          },
        ),

        // Twinkling stars/sparkles
        AnimatedBuilder(
          animation: _twinkleController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.8,
              child: Opacity(
                opacity: (0.2 + math.sin(_twinkleController.value * 2 * math.pi) * 0.1).clamp(0.0, 1.0),
                child: const Text(
                  '✨',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _twinkleController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Opacity(
                opacity: (0.15 + math.sin((_twinkleController.value + 0.5) * 2 * math.pi) * 0.1).clamp(0.0, 1.0),
                child: const Text(
                  '✨',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),

        // Floating cloud particles
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.4 + 
                   math.sin(_floatController.value * 2 * math.pi) * 8,
              left: MediaQuery.of(context).size.width * 0.3,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.2),
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
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.6 + 
                   math.sin((_floatController.value + 0.3) * 2 * math.pi) * 10,
              right: MediaQuery.of(context).size.width * 0.25,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),

        // Additional floating particles
        AnimatedBuilder(
          animation: _floatController,
          builder: (context, child) {
            return Positioned(
              top: MediaQuery.of(context).size.height * 0.7 + 
                   math.sin((_floatController.value + 0.7) * 2 * math.pi) * 6,
              left: MediaQuery.of(context).size.width * 0.7,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          },
        ),

        // Gradient overlays for sky depth
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade50.withOpacity(0.1),
                Colors.transparent,
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 