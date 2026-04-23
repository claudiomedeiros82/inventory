import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class TerminalAlertDialog extends StatefulWidget {
  final String title;
  final String message;

  const TerminalAlertDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  State<TerminalAlertDialog> createState() => _TerminalAlertDialogState();
}

class _TerminalAlertDialogState extends State<TerminalAlertDialog> {
  static const int _contentWidth = 36;
  // Comprimento total da linha: | + espaço + _contentWidth + espaço + | = _contentWidth + 4
  // Quantidade de traços internos (entre os dois +): _contentWidth + 2
  static const int _innerDashes = _contentWidth + 2;

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
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
    }
  }

  String _formatTitle(String title) {
    if (title.length > _contentWidth) return title.substring(0, _contentWidth);
    return title.padRight(_contentWidth);
  }

  @override
  Widget build(BuildContext context) {
    // Topo com ícone [!]: "+--[!]--" (8 chars) + traços restantes + "+"
    // Total = 1 + 7 + (_innerDashes - 7) + 1 = _innerDashes + 2 ✓
    final String topBorder = '+--[!]--${'-' * (_innerDashes - 7)}+';
    final String midLine = '| ${_formatTitle(widget.title)} |';
    final String botBorder = '+${'-' * _innerDashes}+';

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
                  '$topBorder\n$midLine\n$botBorder',
                  style: terminalStyle,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: terminalStyle,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: AppTheme.primaryColor.withAlpha(40),
                      child: Text(
                        '> [ OK ]',
                        style: terminalStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          shadows: const [
                            Shadow(blurRadius: 8, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
