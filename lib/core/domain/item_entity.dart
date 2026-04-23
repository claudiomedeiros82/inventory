import 'package:uuid/uuid.dart';

class ItemEntity {
  final String id;
  final String nome;

  ItemEntity({
    String? id,
    required this.nome,
  }) : id = id ?? const Uuid().v4();

  @override
  String toString() => 'ItemEntity(id: $id, nome: $nome)';
}
