Review the currently open Flutter widget file for best practices.

Check for and report on every issue found:

**Performance**
- [ ] Missing `const` constructor or `const` instantiation where possible
- [ ] `setState` called higher than necessary (could be narrowed)
- [ ] Heavy computation in `build()` — should be cached or moved to controller
- [ ] Missing `RepaintBoundary` around independently animating children
- [ ] Large widget with no extraction — `build()` over 50 lines

**Correctness**
- [ ] `!` null assertion without justifying comment
- [ ] `setState()` that could be called after `dispose()` (async callbacks)
- [ ] `GlobalKey` usage — flag any that seem unnecessary
- [ ] Missing `dispose()` for controllers, focus nodes, animations

**Architecture**
- [ ] Business logic inside the widget — should be in a controller
- [ ] Direct service/repository calls — should go through a provider
- [ ] Cross-feature imports from `lib/features/other_feature/`
- [ ] `StatefulWidget` where state could live in a controller

**Accessibility**
- [ ] Interactive elements without `Semantics` label
- [ ] Touch targets smaller than 44×44pt
- [ ] Hardcoded colors instead of `Theme.of(context)`
- [ ] Text that won't scale with system font size

**Code quality**
- [ ] Hardcoded strings (should be in l10n ARB file)
- [ ] Hardcoded colors, sizes, or spacing (should be in theme or constants)
- [ ] `print()` statements

Format your response as:
1. **Issues found** — list each with file:line reference and fix
2. **Looks good** — things done well (at least acknowledge what's correct)
3. **Priority fix** — the single most important thing to fix first
