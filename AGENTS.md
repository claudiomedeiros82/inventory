# Especificação Técnica Consolidada: Bunker OS (Flutter Windows)

## 1. Visão Geral do Projeto

Aplicação Desktop nativa para Windows que gerencia o inventário de um abrigo subterrâneo. Versão atual: **1.6.0**. O sistema é construído com separação total entre lógica de negócio e interface, permitindo que o núcleo do inventário funcione de forma autônoma.

---

## 2. Arquitetura de Software (Clean Architecture & DI)

### 2.1. Camada de Domínio (Core)

Esta camada não possui dependências externas e contém a inteligência do sistema.

- **ItemEntity**: Classe contendo apenas `nome` (String). Não possui campo `id`.
- **Node**: Classe para a estrutura de dados, contendo um `ItemEntity` e um ponteiro `Node? next`.
- **CustomLinkedList**: Implementação manual de uma Lista Simplesmente Encadeada.
  - **Métodos**: `add(ItemEntity)`, `remove(String nome)`, `search(String nome) -> int (índice)`, `clear()`, `toList() -> List<ItemEntity>`.
  - **Normalização de diacríticos**: `search` e `remove` utilizam o pacote `diacritic` para comparação sem acento e case-insensitive.
  - **Busca parcial**: `search` usa `contains` — retorna o índice do primeiro item cujo nome contém a query.
  - **Independência**: A lista é percorrida via ponteiros para todas as operações.

### 2.2. Camada de Dados e Abstração (Services)

O sistema usa **Injeção de Dependência** via o pacote `provider` (`MultiProvider` / `ProxyProvider` / `ChangeNotifierProvider` em `app.dart`).

- **IFileRepository (Interface)**: Define dois contratos:
  - `Future<List<String>> readLines()`
  - `Future<void> writeLines(List<String> lines)`
- **FileRepository**: Implementação real que usa `dart:io` para ler/gravar o arquivo `items.txt` do disco (diretório de trabalho do executável).
- **MemoryFileRepository**: Implementação para testes. Mantém uma lista mutável em memória (inicia com 8 itens pré-definidos). Suporta `writeLines`, que atualiza a lista interna.
- **InventoryService**: O orquestrador. Recebe `IFileRepository` via construtor. Expõe:
  - `loadInventory()` — limpa a lista e recarrega do repositório.
  - `getItems() -> List<ItemEntity>` — retorna snapshot da lista encadeada.
  - `addItem(String nome)` — adiciona item e persiste via `writeLines`.
  - `removeItem(String nome) -> Future<bool>` — remove item e persiste.
  - `searchItem(String nome) -> int` — delega para `CustomLinkedList.search`.

### 2.3. Camada de Apresentação

- **InventoryController** (`ChangeNotifier`): Gerencia o estado da UI. Interage apenas com `InventoryService`. Recursos:
  - `items` — lista de itens filtrada por `searchQuery` (com cache invalidado em mutações).
  - `loadItems()`, `addItem(String)`, `removeItem(String) -> Future<bool>`.
  - `setSearchQuery(String)` — filtro reativo por nome (diacritic-insensitive, via `diacritic`).
  - `searchItem(String) -> int` — busca na lista completa (ignora filtro) e atualiza `statusMessage`.
  - `statusMessage` / `clearStatus()` — mensagem de feedback exibida na tela.
- **UI (Screens/Widgets)**: Camada "burra" que renderiza o estado e repassa inputs para o controller via `Consumer` / `context.read`.

---

## 3. Especificações da Interface (UI/UX Retrô)

### 3.1. Janela Windows

- **Janela Frameless**: A janela nativa não possui barra de título nem moldura (`window_manager.setAsFrameless()`). Toda a decoração é feita pelo `BezelFrame`.
- **Padding externo**: `Scaffold` com `Padding(all: 18)` ao redor do `BezelFrame`, deixando espaço para a sombra do monitor.

### 3.2. Bezel do Monitor (`BezelFrame`)

Simula o plástico de um monitor CRT military olive-gray. Estrutura multi-parte:

- **Gradiente 3D**: `LinearGradient` topLeft→bottomRight com três stops:
  - `bezelHighlight`: `#3C3C2A` (canto superior-esquerdo, brilho de luz)
  - `bezelColor`: `#242418` (base)
  - `bezelShadow`: `#0C0C09` (canto inferior-direito, sombra)
- **Faixa Superior** (22px): área de drag (`DragToMoveArea`) + botão fechar (`×`) que aparece ao hover no lado direito.
- **Laterais** (28px cada): gradientes laterais simulando profundidade 3D.
- **Recesso da Tela**: moldura interna recuada com `RadialGradient` escuro + brilho verde fósforo nas bordas.
- **Chin Inferior** (38px): gradiente escuro com LED circular verde (`#00FF41`) pulsante e label `BUNKER OS v1.5`.
- **Sombras externas**: drop shadow pesado (`blurRadius: 50`) + ambient green glow sutil do fósforo.

### 3.3. O Terminal CRT (`CRTScreen`)

- **Cores**: Fundo preto absoluto (`Colors.black`) e Texto Verde Fósforo (`#00FF41`).
- **Efeitos Visuais** (todos em `IgnorePointer`):
  - **Scanlines**: `CustomPaint` com linhas horizontais a cada 3px, `alpha: 35`.
  - **Vignette de lente**: `RadialGradient` central com escurecimento progressivo nas bordas (`radius: 1.1`).
  - **Phosphor glow**: `RadialGradient` verde central muito sutil (`alpha: 8`).
  - **Corner vignette**: `CustomPaint` escurecendo os 4 cantos com gradientes radiais independentes.
- **Tipografia**: `Roboto Mono` (Google Fonts), `fontSize: 18`, `fontWeight: bold`, com `Shadow` de glow verde.

### 3.4. Elementos de Interação

- **`TerminalHeader`**: Cabeçalho fixo com título do sistema.
- **`InventoryListView`**: Lista dinâmica de itens, `itemExtent: 32px`. Formato: `[001]> NOME DO ITEM`. Item selecionado: `> ` à esquerda + fundo `primaryColor.withAlpha(30)` + texto branco.
- **`TerminalMenu`**: Linha de menu com os comandos disponíveis, abaixo da lista.
- **`CommandLineInput`**: Prompt `> _` no rodapé. Foco padrão. Qualquer tecla alfanumérica pressionada com foco na lista redireciona automaticamente o foco para o input.
- **`TerminalAlertDialog`**: Diálogo de alerta simples (erros, avisos).
- **`ASCIIDialog`**: Diálogo de confirmação com bordas em ASCII art, usado para confirmar remoção de item.

### 3.5. Comandos do Terminal

| Comando | Uso | Descrição |
|---------|-----|-----------|
| `add` | `add <nome>` | Adiciona item ao inventário e persiste |
| `filter` | `filter <nome>` | Filtra a lista visualmente (não navega) |
| `search` | `search <nome>` | Limpa filtro, navega e destaca o item na lista completa |
| `remove` / `del` | `remove <índice>` | Abre confirmação de remoção pelo índice exibido |
| `clear` | `clear` | Limpa o filtro e a seleção |

**Navegação por teclado**: `↑`/`↓` navegam na lista; `Delete` remove o item selecionado; qualquer tecla alfanumérica com lista focada transfere foco para o input com o caractere já inserido.

---

## 4. Plano de Testes Automatizados (Pasta /test)

O sistema é validado via `flutter test`:

1. **Unitário (`CustomLinkedList`)**: Inserção, busca de índice, religamento de ponteiros após remoção (início, meio e fim), normalização de diacríticos em busca e remoção, retorno -1 para item inexistente, `clear`.
2. **Integração (`InventoryService` + `MemoryFileRepository`)**: Injeção do `MemoryFileRepository`, verificação de população correta da lista (8 itens), busca por item inexistente retorna -1.

---

## 5. Estrutura de Pastas

```text
lib/
  ├── core/
  │     ├── domain/          (item_entity.dart, node.dart, custom_linked_list.dart)
  │     └── repositories/    (file_interface.dart)
  ├── data/
  │     └── repositories/    (file_repository.dart, memory_file_repository.dart)
  ├── services/              (inventory_service.dart)
  ├── ui/
  │     ├── controllers/     (inventory_controller.dart)
  │     ├── theme/           (app_theme.dart)
  │     ├── widgets/         (bezel_frame.dart, crt_screen.dart, terminal_header.dart,
  │     │                     inventory_list_view.dart, terminal_menu.dart,
  │     │                     command_line_input.dart, ascii_dialog.dart,
  │     │                     terminal_alert_dialog.dart)
  │     └── main_screen.dart
  ├── app.dart               (DI Setup com Provider)
  └── main.dart              (window_manager frameless setup)

test/
  ├── core/                  (custom_linked_list_test.dart)
  └── services/              (inventory_service_test.dart)
```
