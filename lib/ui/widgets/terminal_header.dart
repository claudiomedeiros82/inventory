import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/inventory_controller.dart';
import '../theme/app_theme.dart';

class TerminalHeader extends StatelessWidget {
  const TerminalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InventoryController>();
    final itemCount = controller.items.length;
    final statusMessage = controller.statusMessage;
    final terminalStyle = AppTheme.terminalStyle;

    return Column(
      children: [
        Text(
          '--- BUNKER OS v1.0.4 ---',
          textAlign: TextAlign.center,
          style: terminalStyle,
        ),
        const SizedBox(height: 10),
        Text(
          'SUPPLY MANIFEST - TOTAL ITEMS: $itemCount',
          textAlign: TextAlign.center,
          style: terminalStyle.copyWith(fontSize: 14),
        ),
        if (statusMessage != null) ...[
          const SizedBox(height: 4),
          Text(
            '> $statusMessage',
            textAlign: TextAlign.center,
            style: terminalStyle.copyWith(fontSize: 12),
          ),
        ],
        const Divider(color: AppTheme.primaryColor, thickness: 2),
      ],
    );
  }
}
