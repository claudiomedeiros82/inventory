import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CommandLineInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;

  const CommandLineInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final terminalStyle = AppTheme.terminalStyle;

    return Row(
      children: [
        Text('>', style: terminalStyle),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            cursorColor: AppTheme.primaryColor,
            style: terminalStyle,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
