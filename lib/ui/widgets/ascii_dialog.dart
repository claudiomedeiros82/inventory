import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class ASCIIDialog extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ASCIIDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<ASCIIDialog> createState() => _ASCIIDialogState();
}

class _ASCIIDialogState extends State<ASCIIDialog> {
  static const int _maxTitleLength = 36;

  int _selectedIndex = 0; // 0 for OK, 1 for CANCEL
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft || 
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() {
          _selectedIndex = _selectedIndex == 0 ? 1 : 0;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_selectedIndex == 0) {
          widget.onConfirm();
        } else {
          widget.onCancel();
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        widget.onCancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final terminalStyle = AppTheme.terminalStyle.copyWith(fontSize: 14);

    return Center(
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.screenBackgroundColor,
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withAlpha(50),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+${'-' * (_maxTitleLength + 2)}+\n'
                  '| ${widget.title.length > _maxTitleLength ? widget.title.substring(0, _maxTitleLength) : widget.title.padRight(_maxTitleLength)} |\n'
                  '+${'-' * (_maxTitleLength + 2)}+',
                  style: terminalStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: terminalStyle,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton('OK', 0),
                    const SizedBox(width: 40),
                    _buildButton('CANCEL', 1),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, int index) {
    final isSelected = _selectedIndex == index;
    final terminalStyle = AppTheme.terminalStyle.copyWith(
      color: isSelected ? Colors.white : AppTheme.primaryColor,
      fontSize: 16,
      shadows: isSelected ? [
        const Shadow(
          blurRadius: 8,
          color: Colors.white,
        ),
      ] : null,
    );

    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (index == 0) {
          widget.onConfirm();
        } else {
          widget.onCancel();
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: isSelected ? AppTheme.primaryColor.withAlpha(40) : Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSelected ? '> ' : '  ',
                style: terminalStyle.copyWith(color: AppTheme.primaryColor),
              ),
              Text(
                '[ $label ]',
                style: terminalStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
