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

  List<ItemEntity>? _cachedItems;
  String _cachedQuery = '';

  void _invalidateCache() => _cachedItems = null;

  List<ItemEntity> get items {
    if (_cachedItems != null && _searchQuery == _cachedQuery) return _cachedItems!;
    _cachedQuery = _searchQuery;
    final allItems = _service.getItems();
    if (_searchQuery.isEmpty) return _cachedItems = allItems;
    final target = removeDiacritics(_searchQuery.toLowerCase());
    return _cachedItems = allItems
        .where((item) => removeDiacritics(item.nome.toLowerCase()).contains(target))
        .toList();
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
      _invalidateCache();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _invalidateCache();
    notifyListeners();
  }

  Future<void> addItem(String nome) async {
    await _service.addItem(nome);
    _invalidateCache();
    notifyListeners();
  }

  Future<bool> removeItem(String nome) async {
    final removed = await _service.removeItem(nome);
    if (removed) {
      _invalidateCache();
      notifyListeners();
    }
    return removed;
  }

  String? _statusMessage;
  String? get statusMessage => _statusMessage;

  void clearStatus() {
    _statusMessage = null;
    notifyListeners();
  }

  // Retorna o índice (0-based) do primeiro item encontrado na lista completa,
  // ou -1 se não encontrado. Atualiza statusMessage com o resultado.
  int searchItem(String nome) {
    final index = _service.searchItem(nome);
    if (index == -1) {
      _statusMessage = 'ITEM NAO ENCONTRADO: "$nome"';
    } else {
      final item = _service.getItems()[index];
      _statusMessage = 'ITEM #${index + 1} LOCALIZADO: "${item.nome}"';
    }
    notifyListeners();
    return index;
  }
}
