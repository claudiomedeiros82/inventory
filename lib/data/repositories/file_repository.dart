import 'dart:io';
import '../../core/repositories/file_interface.dart';

class FileRepository implements IFileRepository {
  @override
  Future<List<String>> readLines() async {
    final file = File('items.txt');
    if (!await file.exists()) {
      return [];
    }
    return await file.readAsLines();
  }

  @override
  Future<void> writeLines(List<String> lines) async {
    final file = File('items.txt');
    await file.writeAsString(lines.join('\n'));
  }
}
