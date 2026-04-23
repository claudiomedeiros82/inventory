import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/core/domain/custom_linked_list.dart';
import 'package:inventory/core/domain/item_entity.dart';

void main() {
  group('CustomLinkedList Tests', () {
    late CustomLinkedList list;

    setUp(() {
      list = CustomLinkedList();
    });

    test('should add items to the list', () {
      list.add(ItemEntity(nome: 'Item 1'));
      list.add(ItemEntity(nome: 'Item 2'));

      expect(list.size, 2);
      expect(list.head?.item.nome, 'Item 1');
      expect(list.head?.next?.item.nome, 'Item 2');
    });

    test('should search for an item and return its index', () {
      list.add(ItemEntity(nome: 'Item 1'));
      list.add(ItemEntity(nome: 'Item 2'));
      list.add(ItemEntity(nome: 'Item 3'));

      expect(list.search('Item 1'), 0);
      expect(list.search('Item 2'), 1);
      expect(list.search('Item 3'), 2);
      expect(list.search('Non-existent'), -1);
    });

    test('should be diacritic-insensitive when searching and removing', () {
      list.add(ItemEntity(nome: 'Maçã'));
      list.add(ItemEntity(nome: 'Água'));
      list.add(ItemEntity(nome: 'Conceição'));

      // Search tests
      expect(list.search('maca'), 0);
      expect(list.search('agua'), 1);
      expect(list.search('conceicao'), 2);

      // Remove tests
      expect(list.remove('agua'), isTrue);
      expect(list.size, 2);
      expect(list.search('maca'), 0);
      expect(list.search('conceicao'), 1);
    });

    test('should remove item from the beginning', () {
      list.add(ItemEntity(nome: 'Item 1'));
      list.add(ItemEntity(nome: 'Item 2'));

      final removed = list.remove('Item 1');
      
      expect(removed, isTrue);
      expect(list.size, 1);
      expect(list.head?.item.nome, 'Item 2');
    });

    test('should remove item from the middle', () {
      list.add(ItemEntity(nome: 'Item 1'));
      list.add(ItemEntity(nome: 'Item 2'));
      list.add(ItemEntity(nome: 'Item 3'));

      final removed = list.remove('Item 2');
      
      expect(removed, isTrue);
      expect(list.size, 2);
      expect(list.head?.item.nome, 'Item 1');
      expect(list.head?.next?.item.nome, 'Item 3');
    });

    test('should remove item from the end', () {
      list.add(ItemEntity(nome: 'Item 1'));
      list.add(ItemEntity(nome: 'Item 2'));

      final removed = list.remove('Item 2');
      
      expect(removed, isTrue);
      expect(list.size, 1);
      expect(list.head?.item.nome, 'Item 1');
      expect(list.head?.next, isNull);
    });

    test('should clear the list', () {
      list.add(ItemEntity(nome: 'Item 1'));
      list.clear();
      
      expect(list.size, 0);
      expect(list.head, isNull);
    });
  });
}
