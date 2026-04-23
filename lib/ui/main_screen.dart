import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controllers/inventory_controller.dart';
import 'widgets/bezel_frame.dart';
import 'widgets/crt_screen.dart';
import 'widgets/ascii_dialog.dart';
import 'widgets/terminal_header.dart';
import 'widgets/inventory_list_view.dart';
import 'widgets/command_line_input.dart';
import 'widgets/terminal_menu.dart';
import '../core/domain/item_entity.dart';
import 'theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _commandController = TextEditingController();
  final FocusNode _commandFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryController>().loadItems();
    });
  }

  void _handleCommand(String value) {
    if (value.isEmpty) return;

    final controller = context.read<InventoryController>();
    final parts = value.trim().split(' ');
    final cmd = parts[0].toLowerCase();
    final args = parts.skip(1).join(' ');

    if (cmd == 'add') {
      controller.addItem(args);
    } else if (cmd == 'remove' || cmd == 'del') {
      final index = int.tryParse(args);
      if (index != null && index > 0) {
        final items = controller.items;
        if (index <= items.length) {
          _showRemovalDialog(items[index - 1]);
        }
      }
    } else if (cmd == 'search') {
      controller.setSearchQuery(args);
      setState(() {
        _selectedIndex = -1;
      });
    } else if (cmd == 'clear') {
      controller.setSearchQuery('');
      setState(() {
        _selectedIndex = -1;
      });
    }

    _commandController.clear();
    _commandFocusNode.requestFocus();
  }

  void _showRemovalDialog(ItemEntity item) {
    showDialog(
      context: context,
      builder: (context) => ASCIIDialog(
        title: 'CONFIRMAÇÃO DE REMOÇÃO',
        message: 'DESEJA REMOVER O ITEM:\n${item.nome.toUpperCase()}?',
        onConfirm: () async {
          final controller = context.read<InventoryController>();
          final navigator = Navigator.of(context);
          await controller.removeItem(item.nome);
          
          navigator.pop();
          if (mounted) {
            setState(() {
              _selectedIndex = -1;
            });
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;
    
    const double itemHeight = 32.0;
    final double targetOffset = index * itemHeight;
    final double viewportHeight = _scrollController.position.viewportDimension;
    final double currentOffset = _scrollController.offset;
    
    if (targetOffset < currentOffset) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    } else if (targetOffset + itemHeight > currentOffset + viewportHeight) {
      _scrollController.animateTo(
        targetOffset - viewportHeight + itemHeight,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final controller = context.read<InventoryController>();
      final itemsCount = controller.items.length;
      if (itemsCount == 0) return;

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1).clamp(0, itemsCount - 1);
        });
        _scrollToIndex(_selectedIndex);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1).clamp(0, itemsCount - 1);
        });
        _scrollToIndex(_selectedIndex);
      } else if (event.logicalKey == LogicalKeyboardKey.delete) {
        if (_selectedIndex != -1) {
          final items = controller.items;
          if (_selectedIndex < items.length) {
            _showRemovalDialog(items[_selectedIndex]);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BezelFrame(
        child: CRTScreen(
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: _handleKeyEvent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TerminalHeader(),
                Expanded(
                  child: InventoryListView(
                    scrollController: _scrollController,
                    selectedIndex: _selectedIndex,
                  ),
                ),
                const TerminalMenu(),
                CommandLineInput(
                  controller: _commandController,
                  focusNode: _commandFocusNode,
                  onSubmitted: _handleCommand,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
