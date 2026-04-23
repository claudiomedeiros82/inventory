import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/inventory_controller.dart';
import '../theme/app_theme.dart';

class InventoryListView extends StatelessWidget {
  final ScrollController scrollController;
  final int selectedIndex;

  const InventoryListView({
    super.key,
    required this.scrollController,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final terminalStyle = AppTheme.terminalStyle;

    return Consumer<InventoryController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return Center(
            child: Text('LOADING DATA...', style: terminalStyle),
          );
        }

        final items = controller.items;
        if (items.isEmpty) {
          return Center(
            child: Text('[NO DATA FOUND]', style: terminalStyle),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemExtent: 32.0,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = index == selectedIndex;
            final indexStr = (index + 1).toString().padLeft(3, '0');

            return Container(
              height: 32.0,
              color: isSelected ? AppTheme.primaryColor.withAlpha(30) : null,
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Row(
                children: [
                  Text(
                    isSelected ? '> ' : '  ',
                    style: terminalStyle,
                  ),
                  Text(
                    '[$indexStr]> ${item.nome.toUpperCase()}',
                    style: terminalStyle.copyWith(
                      color: isSelected ? Colors.white : AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
