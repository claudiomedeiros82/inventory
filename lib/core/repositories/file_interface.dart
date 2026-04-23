abstract class IFileRepository {
  Future<List<String>> readLines();
  Future<void> writeLines(List<String> lines);
}
