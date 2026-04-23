Convert all hardcoded user-facing strings in the specified file to localization ARB entries and apply the changes immediately.

Target file: $ARGUMENTS (if not provided, use the currently open file)

Delegate to the Localization Agent.

---

## Step 1 — Check l10n setup

Before touching any strings, verify localization is configured:

Check `pubspec.yaml` for:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true
```

Check that `l10n.yaml` exists at the project root:
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

Check that `main.dart` has:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ...
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
)
```

If any of the above is missing, set it up first before proceeding. Apply all setup changes immediately.

---

## Step 2 — Find all hardcoded strings

Read the target file. Identify every string a user would see:
- Button labels, screen titles, hints, placeholders
- Error messages, empty state messages
- Snackbar / toast / dialog text
- Tooltip text
- Any string passed to `Text()`, `hint:`, `labelText:`, `tooltip:`, etc.

Skip: route names, asset paths, log messages, test strings, API endpoints, Hive box keys.

---

## Step 3 — Generate ARB entries

For each string, create an ARB key (camelCase, screen-prefixed):

```json
{
  "homeRateButton": "Rate It",
  "@homeRateButton": {
    "description": "Main CTA button on home screen"
  },
  "homeRatingsRemaining": "{count} free {count, plural, =1{rating} other{ratings}} left today",
  "@homeRatingsRemaining": {
    "placeholders": {
      "count": { "type": "int" }
    }
  }
}
```

Naming convention:
- `[screen][Element]` — e.g. `homeTitle`, `resultShareButton`, `historyEmptyMessage`
- Error messages: `errorNetwork`, `errorRateLimit`
- Generic reused strings: `buttonCancel`, `buttonDone`

---

## Step 4 — Apply all changes immediately

Do not ask for confirmation. Apply both changes now:

1. **Update `lib/l10n/app_en.arb`** — merge the new entries (preserve existing keys, add new ones)
2. **Update the target file** — replace every hardcoded string with `AppLocalizations.of(context)!.keyName`

For strings requiring `context` outside of `build()`:
- Pass the localized string as a parameter instead of computing it in the service/controller

---

## Step 5 — Report

After applying, output:
```
LOCALIZE COMPLETE
-----------------
File: [filename]
Strings converted: [N]
ARB keys added: [list of new keys]
Setup changes: [any l10n setup that was added]
Remaining hardcoded strings: [any that couldn't be converted and why]
```

If the file has no hardcoded strings, say so and stop.
