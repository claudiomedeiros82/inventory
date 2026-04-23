import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/data/repositories/memory_file_repository.dart';
import 'package:inventory/services/inventory_service.dart';

void main() {
  group('InventoryService Integration Tests', () {
    late InventoryService service;
    late MemoryFileRepository memoryRepo;

    setUp(() {
      memoryRepo = MemoryFileRepository();
      service = InventoryService(memoryRepo);
    });

    test('should populate list correctly using MemoryFileRepository', () async {
      await service.loadInventory();
      
      // MemoryFileRepository initializes with 8 items
      expect(service.list.size, 8);
      expect(service.list.head?.item.nome, 'Ração K');
    });

    test('should return -1 for non-existent item search', () async {
      await service.loadInventory();
      
      final index = service.searchItem('Nuclear Bomb');
      expect(index, -1);
    });
  });
}
