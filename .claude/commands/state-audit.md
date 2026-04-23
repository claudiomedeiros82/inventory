Audit the state management implementation across the project or in a specific file.

Target: $ARGUMENTS (specific file/feature, or entire project if not specified)

Delegate to the State Management Specialist agent.

Scan for:

**Provider / Riverpod issues**
- `ref.read` used inside `build()` — should be `ref.watch`
- `ref.watch` used inside callbacks (tap handlers, etc.) — should be `ref.read`
- Provider missing `autoDispose` when it should have it (one-time data, screen-specific state)
- Provider has `autoDispose` but shouldn't (data that needs to persist across navigation)
- `WidgetRef` stored in a field — will cause stale ref bugs
- `ref.watch` on the entire state when only one field is needed (missing `select()`)

**State mutation**
- State objects mutated directly instead of using `copyWith` or `state =`
- Lists mutated in place (`list.add()`) instead of creating new list (`[...list, item]`)
- Maps mutated in place

**Memory leaks**
- `StreamSubscription` not cancelled
- `AnimationController` not disposed
- `TextEditingController` not disposed
- `FocusNode` not disposed
- `ScrollController` not disposed
- `PageController` not disposed

**Architecture**
- `setState` used in a screen that also uses Riverpod (mixing state solutions)
- Business logic in `initState` instead of controller
- Navigation triggered from inside a notifier (should use listener in the widget)

**Output format:**
- Group issues by file
- For each issue: line reference, what's wrong, the fix
- Severity: 🔴 Bug / 🟡 Code smell / 🟢 Optimization
