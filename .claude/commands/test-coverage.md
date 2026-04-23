Generate missing tests for the specified feature or file.

Target: $ARGUMENTS (feature name or file path)

Delegate to the Widget Test Specialist agent.

Steps:
1. Read the target feature folder or file
2. Check `test/` for existing tests covering this code
3. Identify what's missing

Generate tests for every gap found:

**For screens** — widget tests covering:
- Loading state (CircularProgressIndicator or skeleton visible)
- Data state (correct content rendered, key elements findable)
- Error state (error message visible, retry button if applicable)
- User interactions (taps, form input, navigation triggers)
- Edge cases (empty list, single item, max content length)

**For repositories** — unit tests covering:
- Successful response parsing
- Error/exception handling
- Edge cases in data mapping

**For utility/calculator classes** — unit tests covering:
- Normal inputs
- Edge cases (zero, negative, empty)
- Error cases

**Format for each test file:**
- Full file with all imports
- `setUp()` with mock initialization
- Riverpod `ProviderScope` overrides where needed
- `group()` blocks organized by state/scenario
- Clear test names that read as documentation

After generating, list:
- Files created
- Files that need manual updates (routes, mock registrations)
- Any coverage gaps that are hard to test automatically
