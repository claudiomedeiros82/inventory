import '../core/domain/custom_linked_list.dart';
import '../core/domain/item_entity.dart';
import '../core/repositories/file_interface.dart';

class InventoryService {
  final IFileRepository _repository;
  final CustomLinkedList _list = CustomLinkedList();

  CustomLinkedList get list => _list;

  InventoryService(this._repository);

  List<ItemEntity> getItems() => _list.toList();

  Future<void> loadInventory() async {
    _list.clear();
    final lines = await _repository.readLines();
    for (final line in lines) {
      if (line.trim().isNotEmpty) {
        _list.add(ItemEntity(nome: line.trim()));
      }
    }
  }

  Future<void> addItem(String nome) async {
    if (nome.trim().isNotEmpty) {
      _list.add(ItemEntity(nome: nome.trim()));
      await _save();
    }
  }

  Future<bool> removeItem(String nome) async {
    final removed = _list.remove(nome);
    if (removed) {
      await _save();
    }
    return removed;
  }

  int searchItem(String nome) => _list.search(nome);

  Future<void> _save() async {
    final items = _list.toList();
    final lines = items.map((e) => e.nome).toList();
    await _repository.writeLines(lines);
  }
}
