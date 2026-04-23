# Especificação Técnica Consolidada: Bunker OS (Flutter Windows)

## 1. Visão Geral do Projeto

Desenvolver uma aplicação Desktop nativa para Windows que gerencia o inventário de um abrigo subterrâneo. O sistema deve ser construído com separação total entre lógica de negócio e interface, permitindo que o núcleo do inventário funcione de forma autônoma.

---

## 2. Arquitetura de Software (Clean Architecture & DI)

### 2.1. Camada de Domínio (Core)

Esta camada não possui dependências externas e contém a inteligência do sistema.

- **ItemEntity**: Classe contendo `id` (gerado automaticamente) e `nome`.
- **Node**: Classe para a estrutura de dados, contendo um `ItemEntity` e um ponteiro `Node? next`.
- **CustomLinkedList**: Implementação manual de uma Lista Simplesmente Encadeada.
  - **Métodos Obrigatórios**: `add(ItemEntity)`, `remove(String nome)`, `search(String nome) -> int (índice)`, e `clear()`.
  - **Independência**: A lista deve ser percorrida via ponteiros para todas as operações.

### 2.2. Camada de Dados e Abstração (Services)

O sistema deve utilizar o padrão de **Injeção de Dependência** via `get_it`.

- **IFileRepository (Interface)**: Define o contrato `Future<List<String>> readLines()`.
- **FileRepositoryImpl**: Implementação real que utiliza `dart:io` para ler o arquivo `itens.txt` do disco.
- **MockFileRepository**: Implementação para testes que retorna uma lista estática de Strings em memória, permitindo testes sem I/O de disco.
- **InventoryService**: O orquestrador. Recebe `IFileRepository` via construtor. Carrega os dados para a `CustomLinkedList` e expõe métodos de negócio para o Controller.

### 2.3. Camada de Apresentação

- **InventoryController**: Gerencia o estado da UI. Ele interage apenas com o `InventoryService`.
- **UI (Screens/Widgets)**: Camada "burra" que apenas renderiza o estado e repassa inputs para o controller.

---

## 3. Especificações da Interface (UI/UX Retrô)

### 3.1. Visual da Janela Windows

- **Frame Externo**: Janela padrão do Windows com botões de controle nativos.
- **Bezel do Monitor (O invólucro)**: Um container interno que simula o plástico de um monitor CRT (Cor: Chumbo/Antracite `#2A2A2A`). Deve ter cantos arredondados e sombras internas para profundidade.

### 3.2. O Terminal CRT (Área de Exibição)

- **Cores**: Fundo Preto Absoluto (`#000000`) e Texto Verde Fósforo (`#00FF41`).
- **Efeitos Visuais**:
  - Overlay de **Scanlines** (linhas horizontais sutis).
  - Leve brilho externo (Glow) nos textos verdes.
  - Curvatura de lente sutil nos cantos da tela.
- **Tipografia**: Fonte monoespaçada obrigatória (ex: 'Courier Prime' ou 'Roboto Mono').

### 3.3. Elementos de Interação

- **Lista Central**: Exibição dos 100 itens carregados, formatados como `[001]> NOME DO ITEM`.
- **Prompts de Comando**: Janelas flutuantes (Overlays) com bordas em ASCII art para as funções de busca e confirmação de remoção.
- **Input**: Campo de texto no rodapé simulando um prompt de comando real: `> _`.

---

## 4. Plano de Testes Automatizados (Pasta /test)

O sistema deve ser validado via `flutter test` garantindo que a lógica funcione sem a UI:

1.  **Unitário (CustomLinkedList)**: Testar inserção, busca de índice por nome e religamento de ponteiros após remoção (início, meio e fim da lista).
2.  **Integração (Service + Mock)**: Injetar o `MockFileRepository` no `InventoryService` e verificar se a lista encadeada é populada corretamente com os dados em memória.
3.  **Funcional**: Validar que a busca por um item inexistente retorna `-1` e não quebra o sistema.

---

## 5. Estrutura de Pastas Sugerida

```text
lib/
  ├── core/
  │     ├── domain/ (entities, linked_list)
  │     └── repositories/ (interfaces)
  ├── data/
  │     └── repositories/ (file_impl, mock_impl)
  ├── services/ (inventory_service)
  ├── ui/
  │     ├── controllers/
  │     ├── widgets/ (bezel_frame, crt_screen)
  │     └── main_screen.dart
  └── main.dart (DI Setup com GetIt)
```
