import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TerminalMenu extends StatelessWidget {
  const TerminalMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(color: AppTheme.primaryColor, thickness: 2),
        Text(
          '> MENU: [ADD] Name | [FILTER] Name | [SEARCH] Name | [DEL] or [REMOVE] Index | [CLEAR]',
          style: AppTheme.terminalStyle.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
