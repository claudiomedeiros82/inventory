Run an accessibility audit on the specified file or feature.

Target: $ARGUMENTS (file or feature, or current file if not specified)

Delegate to the UX/UI Lead agent.

Check for:

**Screen reader support**
- [ ] All interactive elements have meaningful `Semantics` labels
- [ ] Images have `Semantics(label: ...)` or `excludeSemantics: true` if decorative
- [ ] Custom widgets implement correct semantic roles (button, header, list item)
- [ ] `Semantics(button: true)` for non-Button interactive elements
- [ ] Logical reading order matches visual order

**Touch targets**
- [ ] All tappable elements are at least 44×44pt (iOS) / 48×48dp (Android)
- [ ] Tap targets have adequate spacing — no accidental taps

**Color and contrast**
- [ ] No information conveyed by color alone (always pair with text or icon)
- [ ] Text contrast ratio: 4.5:1 minimum for body text, 3:1 for large text
- [ ] No hardcoded colors — uses `Theme.of(context)` for dark mode support

**Text scaling**
- [ ] No `textScaleFactor: 1.0` overrides (blocks accessibility text sizing)
- [ ] Layout doesn't break at 1.5× or 2× text scale
- [ ] `maxLines` with `overflow: TextOverflow.ellipsis` where layout requires it

**Focus management**
- [ ] Modal dialogs trap focus correctly
- [ ] After navigation, focus lands on a meaningful element
- [ ] Custom focus order with `FocusTraversalGroup` where default order is wrong

**Motion**
- [ ] Respects `MediaQuery.of(context).disableAnimations`
- [ ] No animations that could trigger vestibular disorders (excessive movement)

**Output:**
1. Failures by severity (critical / moderate / minor)
2. Each failure: file:line, description, fix
3. Quick wins — highest impact, lowest effort fixes
