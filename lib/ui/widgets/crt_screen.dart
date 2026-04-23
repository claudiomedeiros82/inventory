import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CRTScreen extends StatelessWidget {
  final Widget child;

  const CRTScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // CRT Background
        Positioned.fill(
          child: Container(
            color: AppTheme.screenBackgroundColor,
          ),
        ),
        
        // Lens Curvature Effect (Slight gradient at edges)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.transparent,
                  Colors.black.withAlpha(50),
                  Colors.black.withAlpha(150),
                ],
                stops: const [0.0, 0.8, 1.0],
              ),
            ),
          ),
        ),

        // Main Content
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: child,
          ),
        ),

        // Scanlines Overlay
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ScanlinePainter(),
            ),
          ),
        ),

        // CRT Glow / Flicker (Subtle)
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withAlpha(5),
                    Colors.transparent,
                    AppTheme.primaryColor.withAlpha(5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withAlpha(30)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.height; i += 3) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
