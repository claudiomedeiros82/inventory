Run a performance audit on the current file or feature.

If $ARGUMENTS is provided, audit that specific file or feature folder.
Otherwise, audit the currently open file.

Delegate to the Performance Analyst agent.

Check for:

**Rebuild issues**
- `ref.watch` on entire state object when only a field is needed (suggest `select()`)
- `Consumer` wrapping too large a subtree
- Non-const constructors where const is possible
- Missing `const` keyword on widget instantiation

**Rendering**
- Missing `RepaintBoundary` around independently animating widgets
- `Opacity` widget used for animation (use `FadeTransition` instead)
- `ClipRRect` or `ClipPath` used repeatedly without `RepaintBoundary`
- `CustomPainter.shouldRepaint` always returns true

**Lists**
- `ListView` or `Column` with many children instead of `ListView.builder`
- Images loaded without `cacheWidth`/`cacheHeight` constraints
- Nested scrollables without proper scroll physics

**Memory**
- `AnimationController`, `TextEditingController`, `FocusNode`, `ScrollController`, `StreamSubscription` without `dispose()`
- `GlobalKey` references keeping widget subtrees alive unexpectedly

**Async**
- Heavy computation synchronously in `build()`
- `FutureProvider` without `autoDispose` (rebuilds on every listen if not cached)

**Output format:**
1. **Critical** — will cause jank or memory leaks, fix before release
2. **Recommended** — noticeable improvement, worth fixing this sprint
3. **Minor** — small improvement, fix when touching this code again
4. **Looks good** — what's already well-optimized

For each issue: file:line reference, explanation, and concrete fix.
