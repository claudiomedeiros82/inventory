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
          child: Container(color: AppTheme.screenBackgroundColor),
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
            child: CustomPaint(painter: ScanlinePainter()),
          ),
        ),

        // Lens curvature vignette (stronger at edges for CRT glass look)
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.1,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(40),
                    Colors.black.withAlpha(130),
                  ],
                  stops: const [0.0, 0.75, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Phosphor green glow overlay (subtle warm bloom from content)
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    AppTheme.primaryColor.withAlpha(8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Corner darkening (CRT corners are always darker)
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: CornerVignettePainter()),
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
      ..color = Colors.black.withAlpha(35)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.height; i += 3) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CornerVignettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Darken each corner with radial gradients
    final corners = [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ];

    for (final corner in corners) {
      final cx = corner.x == -1 ? 0.0 : size.width;
      final cy = corner.y == -1 ? 0.0 : size.height;
      final radius = size.shortestSide * 0.55;

      final gradient = RadialGradient(
        center: corner,
        radius: 1.0,
        colors: [
          Colors.black.withAlpha(120),
          Colors.transparent,
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        );

      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
