import 'package:diacritic/diacritic.dart';
import 'item_entity.dart';
import 'node.dart';

class CustomLinkedList {
  Node? _head;
  int _size = 0;

  Node? get head => _head;
  int get size => _size;

  void add(ItemEntity item) {
    final newNode = Node(item);
    if (_head == null) {
      _head = newNode;
    } else {
      Node? current = _head;
      while (current?.next != null) {
        current = current?.next;
      }
      current?.next = newNode;
    }
    _size++;
  }

  bool remove(String nome) {
    if (_head == null) return false;

    final target = removeDiacritics(nome.trim().toLowerCase());

    if (removeDiacritics(_head!.item.nome.trim().toLowerCase()) == target) {
      _head = _head?.next;
      _size--;
      return true;
    }

    Node? current = _head;
    while (current?.next != null) {
      if (removeDiacritics(current!.next!.item.nome.trim().toLowerCase()) == target) {
        current.next = current.next!.next;
        _size--;
        return true;
      }
      current = current.next;
    }

    return false;
  }

  int search(String nome) {
    Node? current = _head;
    int index = 0;
    final target = removeDiacritics(nome.trim().toLowerCase());
    
    while (current != null) {
      final itemName = removeDiacritics(current.item.nome.trim().toLowerCase());
      if (itemName.contains(target)) {
        return index;
      }
      current = current.next;
      index++;
    }
    return -1;
  }

  void clear() {
    _head = null;
    _size = 0;
  }

  List<ItemEntity> toList() {
    final list = <ItemEntity>[];
    Node? current = _head;
    while (current != null) {
      list.add(current.item);
      current = current.next;
    }
    return list;
  }
}
