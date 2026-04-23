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
import 'widgets/terminal_alert_dialog.dart';
import 'theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _commandController = TextEditingController();
  final FocusNode _commandFocusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = -1;
  int _lastSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _commandFocusNode.addListener(_onCommandFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = context.read<InventoryController>();
      await controller.loadItems();
      if (!mounted) return;
      if (controller.errorMessage != null) {
        _showAlertDialog('ERRO AO CARREGAR', controller.errorMessage!);
      }
      _keyboardFocusNode.requestFocus();
    });
  }

  void _onCommandFocusChange() {
    if (_commandFocusNode.hasFocus && _selectedIndex != -1) {
      setState(() {
        _lastSelectedIndex = _selectedIndex;
        _selectedIndex = -1;
      });
    }
  }

  @override
  void dispose() {
    _commandFocusNode.removeListener(_onCommandFocusChange);
    _commandController.dispose();
    _commandFocusNode.dispose();
    _keyboardFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleCommand(String value) async {
    if (value.isEmpty) return;

    final controller = context.read<InventoryController>();
    final parts = value.trim().split(' ');
    final cmd = parts[0].toLowerCase();
    final args = parts.skip(1).join(' ');

    if (cmd == 'add') {
      if (args.trim().isEmpty) {
        _showAlertDialog('COMANDO INVÁLIDO', 'Uso: add <nome do item>');
        return;
      }
      await controller.addItem(args);
      controller.clearStatus();
      _selectAndScrollToItem(args, controller);
    } else if (cmd == 'remove' || cmd == 'del') {
      final index = int.tryParse(args);
      if (index != null && index > 0) {
        final items = controller.items;
        if (index <= items.length) {
          _showRemovalDialog(items[index - 1]);
        }
      }
    } else if (cmd == 'filter') {
      controller.setSearchQuery(args);
      controller.clearStatus();
      setState(() {
        _selectedIndex = -1;
      });
    } else if (cmd == 'search') {
      // Limpa filtro, navega e destaca o primeiro item encontrado na lista completa
      controller.setSearchQuery('');
      final index = controller.searchItem(args);
      setState(() {
        _selectedIndex = index;
      });
      if (index != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex(index));
      }
    } else if (cmd == 'clear') {
      controller.setSearchQuery('');
      controller.clearStatus();
      setState(() {
        _selectedIndex = -1;
      });
    }

    _commandController.clear();
    _commandFocusNode.requestFocus();
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => TerminalAlertDialog(title: title, message: message),
    );
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
              final newCount = controller.items.length;
              if (newCount == 0) {
                _selectedIndex = -1;
              } else {
                _selectedIndex = _selectedIndex.clamp(0, newCount - 1);
              }
            });
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _selectAndScrollToItem(String nome, InventoryController controller) {
    final items = controller.items;
    final index = items.indexWhere(
      (item) => item.nome.toLowerCase() == nome.toLowerCase(),
    );
    if (index == -1) return;
    setState(() {
      _selectedIndex = index;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(index);
    });
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

  /// Retorna true se a tecla deve ser tratada como navegação da lista
  /// (setas, Delete, Backspace, Enter, Escape, Tab, Ctrl/Alt combos).
  bool _isNavigationKey(LogicalKeyboardKey key) {
    final navigationKeys = {
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.delete,
      LogicalKeyboardKey.backspace,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.numpadEnter,
      LogicalKeyboardKey.escape,
      LogicalKeyboardKey.tab,
      LogicalKeyboardKey.home,
      LogicalKeyboardKey.end,
      LogicalKeyboardKey.pageUp,
      LogicalKeyboardKey.pageDown,
      LogicalKeyboardKey.f1,
      LogicalKeyboardKey.f2,
      LogicalKeyboardKey.f3,
      LogicalKeyboardKey.f4,
      LogicalKeyboardKey.f5,
      LogicalKeyboardKey.f6,
      LogicalKeyboardKey.f7,
      LogicalKeyboardKey.f8,
      LogicalKeyboardKey.f9,
      LogicalKeyboardKey.f10,
      LogicalKeyboardKey.f11,
      LogicalKeyboardKey.f12,
    };
    if (navigationKeys.contains(key)) return true;
    // Ignorar combinações com Ctrl ou Alt
    final isCtrl = HardwareKeyboard.instance.isControlPressed;
    final isAlt = HardwareKeyboard.instance.isAltPressed;
    if (isCtrl || isAlt) return true;
    return false;
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final key = event.logicalKey;
    final controller = context.read<InventoryController>();
    final itemsCount = controller.items.length;

    if (_commandFocusNode.hasFocus) {
      if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.arrowDown) {
        _keyboardFocusNode.requestFocus();
        if (itemsCount > 0) {
          setState(() {
            if (_lastSelectedIndex != -1 && _lastSelectedIndex < itemsCount) {
              _selectedIndex = _lastSelectedIndex;
            } else if (key == LogicalKeyboardKey.arrowUp) {
              _selectedIndex = itemsCount - 1;
            } else {
              _selectedIndex = 0;
            }
          });
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex(_selectedIndex));
        }
        return;
      }
      return;
    }

    // Teclas de navegação da lista
    if (key == LogicalKeyboardKey.arrowDown) {
      if (itemsCount == 0) return;
      setState(() {
        _selectedIndex = (_selectedIndex + 1).clamp(0, itemsCount - 1);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex(_selectedIndex));
      return;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      if (itemsCount == 0) return;
      setState(() {
        _selectedIndex = (_selectedIndex - 1).clamp(0, itemsCount - 1);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToIndex(_selectedIndex));
      return;
    }
    if (key == LogicalKeyboardKey.delete) {
      if (_selectedIndex != -1 && _selectedIndex < itemsCount) {
        _showRemovalDialog(controller.items[_selectedIndex]);
      }
      return;
    }

    // Para qualquer outra tecla que produza um caractere imprimível,
    // redirecionar o foco para o input já com o caractere inserido.
    if (!_isNavigationKey(key)) {
      final character = event.character;
      if (character != null && character.isNotEmpty) {
        // Appenda o caractere no campo e move o cursor para o final
        final current = _commandController.text;
        final newText = current + character;
        _commandController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
        _commandFocusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: BezelFrame(
          child: CRTScreen(
            child: KeyboardListener(
            focusNode: _keyboardFocusNode,
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
    ),
  );
  }
}
