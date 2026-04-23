import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BezelFrame extends StatelessWidget {
  final Widget child;

  const BezelFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.bezelColor,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white.withAlpha(25),
            offset: const Offset(-2, -2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.screenBackgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppTheme.bezelBorderColor, width: 4),
          boxShadow: [
            // Inner shadow simulation
            BoxShadow(
              color: Colors.black.withAlpha(200),
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
