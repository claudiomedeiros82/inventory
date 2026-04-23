Scaffold a complete Flutter feature folder for the feature named: $ARGUMENTS

First, check `pubspec.yaml` to detect which Riverpod pattern the project uses:
- If `riverpod_generator` is in dev_dependencies AND `build_runner` is present → use **codegen pattern** (`@riverpod` annotations)
- Otherwise → use **manual pattern** (`StateNotifierProvider` / `AsyncNotifierProvider`)

Create the following structure under `lib/features/[feature_name]/`:
```
lib/features/[feature_name]/
├── screens/
│   └── [feature_name]_screen.dart
├── controllers/
│   └── [feature_name]_controller.dart
├── repositories/
│   ├── [feature_name]_repository.dart  (abstract interface)
│   └── [feature_name]_repository_impl.dart
└── models/
    └── [feature_name]_model.dart
```

Also create:
- `test/features/[feature_name]/[feature_name]_screen_test.dart` — widget test skeleton

---

## MANUAL PATTERN (default — no build_runner required)

**Controller** (`StateNotifierProvider`):
```dart
// Sealed state
sealed class [Feature]State { const [Feature]State(); }
class [Feature]Idle extends [Feature]State { const [Feature]Idle(); }
class [Feature]Loading extends [Feature]State { const [Feature]Loading(); }
class [Feature]Success extends [Feature]State {
  final [Feature]Model data;
  const [Feature]Success(this.data);
}
class [Feature]Error extends [Feature]State {
  final String message;
  const [Feature]Error(this.message);
}

// Controller
class [Feature]Controller extends StateNotifier<[Feature]State> {
  final [Feature]Repository _repository;
  [Feature]Controller(this._repository) : super(const [Feature]Idle());

  Future<void> load() async {
    state = const [Feature]Loading();
    try {
      final result = await _repository.fetch();
      state = [Feature]Success(result);
    } catch (e) {
      state = [Feature]Error(e.toString());
    }
  }
}

// Provider
final [feature]ControllerProvider =
    StateNotifierProvider<[Feature]Controller, [Feature]State>((ref) {
  return [Feature]Controller(ref.watch([feature]RepositoryProvider));
});
```

**Screen** (`ConsumerWidget`):
```dart
class [Feature]Screen extends ConsumerWidget {
  const [Feature]Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch([feature]ControllerProvider);
    return switch (state) {
      [Feature]Loading() => const Center(child: CircularProgressIndicator()),
      [Feature]Success(:final data) => _SuccessView(data: data),
      [Feature]Error(:final message) => _ErrorView(message: message),
      [Feature]Idle() => _IdleView(),
    };
  }
}
```

---

## CODEGEN PATTERN (when riverpod_generator + build_runner present)

**Controller** (`@riverpod` annotation):
```dart
@riverpod
class [Feature]Controller extends _$[Feature]Controller {
  @override
  Future<[Feature]Model> build() async {
    return ref.watch([feature]RepositoryProvider).fetch();
  }
}
```

**Screen** (`ConsumerWidget` with `AsyncValue`):
```dart
final state = ref.watch([feature]ControllerProvider);
return state.when(
  loading: () => const CircularProgressIndicator(),
  data: (data) => _SuccessView(data: data),
  error: (e, _) => _ErrorView(message: e.toString()),
);
```

After scaffolding with codegen, remind the developer to run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Model
Plain Dart class with `copyWith` (no freezed required unless project already uses it):
```dart
class [Feature]Model {
  final String id;
  // add fields here

  const [Feature]Model({required this.id});

  [Feature]Model copyWith({String? id}) =>
      [Feature]Model(id: id ?? this.id);

  Map<String, dynamic> toJson() => {'id': id};

  factory [Feature]Model.fromJson(Map<String, dynamic> json) =>
      [Feature]Model(id: json['id'] as String);
}
```

If `freezed` is in dev_dependencies, use `@freezed` instead.

---

## Repository
```dart
// Abstract
abstract class [Feature]Repository {
  Future<[Feature]Model> fetch();
}

// Impl
class [Feature]RepositoryImpl implements [Feature]Repository {
  @override
  Future<[Feature]Model> fetch() async {
    // TODO: implement
    throw UnimplementedError();
  }
}

// Provider
final [feature]RepositoryProvider = Provider<[Feature]Repository>((ref) {
  return [Feature]RepositoryImpl();
});
```

---

## Test skeleton
```dart
void main() {
  group('[Feature]Screen', () {
    late Mock[Feature]Repository mockRepo;

    setUp(() {
      mockRepo = Mock[Feature]Repository();
    });

    testWidgets('shows loading state', (tester) async {
      // TODO: implement
    });

    testWidgets('shows data on success', (tester) async {
      // TODO: implement
    });

    testWidgets('shows error message on failure', (tester) async {
      // TODO: implement
    });
  });
}

class Mock[Feature]Repository extends Mock implements [Feature]Repository {}
```

---

Follow the path-scoped rules in CLAUDE.md exactly.
Use go_router for navigation — add a TODO comment for the route, don't wire it.
After scaffolding, list exactly what the developer needs to fill in to make it functional.
