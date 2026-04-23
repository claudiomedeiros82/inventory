Run a full architecture review of the Flutter project.

Read the project structure:
- `lib/` folder tree
- `pubspec.yaml`
- Key files: `main.dart`, router setup, any barrel files

Delegate to the Technical Lead agent.

Review for:

**Layer separation**
- [ ] Features in `lib/features/` with correct subfolders (screens/, controllers/, repositories/, models/)
- [ ] No UI imports in `lib/services/`
- [ ] No business logic in widget `build()` methods
- [ ] No cross-feature imports (feature A importing directly from feature B)
- [ ] Repository interfaces are abstract — no concrete impl details in controllers

**Dependency direction**
- [ ] Dependencies flow inward (UI → controller → repository → service)
- [ ] No circular dependencies
- [ ] `lib/core/` contains no feature-specific code

**State management**
- [ ] Consistent state solution — not mixing Riverpod + Bloc + setState randomly
- [ ] `AsyncValue` used for all async data
- [ ] Providers scoped correctly (global vs feature-scoped)

**Navigation**
- [ ] go_router configured correctly
- [ ] Deep links handled if app requires them
- [ ] Navigation logic not in widgets — use router callbacks

**Naming**
- [ ] Consistent naming: `*Screen`, `*Controller`, `*Repository`, `*Model`
- [ ] File names match class names (snake_case file, PascalCase class)

**Output format:**
1. **Critical violations** — breaks the architecture, must fix
2. **Structural improvements** — would make the codebase significantly more maintainable
3. **Minor issues** — clean up when touching this area
4. **Overall grade** — A/B/C/D with one sentence summary
5. **Recommended next refactor** — the single highest-value architectural change
