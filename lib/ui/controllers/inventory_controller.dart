import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import '../../core/domain/item_entity.dart';
import '../../services/inventory_service.dart';

class InventoryController extends ChangeNotifier {
  final InventoryService _service;
  String _searchQuery = '';
  String? _errorMessage;
  bool _isLoading = false;

  InventoryController(this._service);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<ItemEntity> get items {
    final allItems = _service.list.toList();
    if (_searchQuery.isEmpty) return allItems;
    
    final target = removeDiacritics(_searchQuery.toLowerCase());
    return allItems.where((item) => 
      removeDiacritics(item.nome.toLowerCase()).contains(target)
    ).toList();
  }

  Future<void> loadItems() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.loadInventory();
    } catch (e) {
      _errorMessage = 'Erro ao carregar inventário: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  Future<void> addItem(String nome) async {
    await _service.addItem(nome);
    notifyListeners();
  }

  Future<bool> removeItem(String nome) async {
    final removed = await _service.removeItem(nome);
    if (removed) {
      notifyListeners();
    }
    return removed;
  }

  int searchItem(String nome) {
    return _service.searchItem(nome);
  }
}
