import '../../core/repositories/file_interface.dart';

class MemoryFileRepository implements IFileRepository {
  final List<String> _data = [
    'Ração K',
    'Lanterna LED',
    'Pilhas AA x4',
    'Máscara de Gás',
    'Filtro de Ar v2',
    'Kit Médico',
    'Água 5L',
    'Corda Nylon 10m',
  ];

  @override
  Future<List<String>> readLines() async {
    return List.from(_data);
  }

  @override
  Future<void> writeLines(List<String> lines) async {
    _data.clear();
    _data.addAll(lines);
  }
}
