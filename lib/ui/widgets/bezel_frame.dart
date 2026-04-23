import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';
import '../theme/app_theme.dart';

class BezelFrame extends StatefulWidget {
  final Widget child;

  const BezelFrame({super.key, required this.child});

  @override
  State<BezelFrame> createState() => _BezelFrameState();
}

class _BezelFrameState extends State<BezelFrame> {
  bool _closeHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          // Large drop shadow (monitor weight)
          BoxShadow(
            color: Colors.black.withAlpha(230),
            blurRadius: 50,
            spreadRadius: 8,
            offset: const Offset(0, 20),
          ),
          // Ambient green glow from the phosphor screen
          BoxShadow(
            color: AppTheme.primaryColor.withAlpha(18),
            blurRadius: 80,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: const BoxDecoration(
            // 3D bevel gradient: lighter top-left, darker bottom-right
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.bezelHighlight,
                AppTheme.bezelColor,
                AppTheme.bezelShadow,
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
          child: Column(
            children: [
              // Top bezel edge strip (wider for top-heavy CRT monitor look)
              _buildTopEdge(),
              // Middle row: left bevel + screen + right bevel
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSideEdge(isLeft: true),
                    Expanded(child: _buildScreenRecess(widget.child)),
                    _buildSideEdge(isLeft: false),
                  ],
                ),
              ),
              // Bottom chin panel with power LED
              _buildBottomChin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopEdge() {
    return SizedBox(
      height: 22,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.bezelHighlight,
                    AppTheme.bezelColor,
                  ],
                ),
              ),
            ),
          ),
          // Drag handle covering the entire top strip
          Positioned.fill(
            child: DragToMoveArea(child: Container()),
          ),
          // Hidden close button — visible only on hover
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: MouseRegion(
              onEnter: (_) => setState(() => _closeHovered = true),
              onExit: (_) => setState(() => _closeHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => windowManager.close(),
                child: AnimatedOpacity(
                  opacity: _closeHovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: Center(
                    child: Text(
                      '×',
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.primaryColor,
                        fontSize: 15,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideEdge({required bool isLeft}) {
    return Container(
      width: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
          end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
          colors: isLeft
              ? [AppTheme.bezelHighlight, AppTheme.bezelColor]
              : [AppTheme.bezelShadow, AppTheme.bezelColor],
        ),
      ),
    );
  }

  Widget _buildScreenRecess(Widget content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        // Outer rim of the recess (inverted gradient = recessed appearance)
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Top-left is darker (inside the recess, away from light)
              Color(0xFF080806),
              // Bottom-right is slightly lighter (recess lip catches light)
              Color(0xFF2A2A1E),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(3),
            // Green phosphor glow along inner screen edges
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withAlpha(30),
                blurRadius: 12,
                spreadRadius: -2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: content,
        ),
      ),
    );
  }

  Widget _buildBottomChin() {
    return Container(
      height: 38,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.bezelColor,
            AppTheme.bezelShadow,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Power indicator LED
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withAlpha(210),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'BUNKER  OS  v1.5',
            style: GoogleFonts.robotoMono(
              color: AppTheme.primaryColor.withAlpha(90),
              fontSize: 8,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}
