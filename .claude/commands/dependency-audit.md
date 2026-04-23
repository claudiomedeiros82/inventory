Audit the project's pubspec.yaml for dependency health.

Read `pubspec.yaml` and evaluate every dependency.

For each package, check:
- **Is it still maintained?** (last publish date, open issues, pub.dev score)
- **Is the version pinned too tightly?** (using `0.1.2` instead of `^0.1.2`)
- **Is the version too loose?** (using `any` or `>=1.0.0`)
- **Is it actually used?** (check imports across `lib/`)
- **Is there a better alternative?** (outdated packages with modern replacements)
- **Does it support null safety?**
- **Does it work on all target platforms?** (iOS + Android minimum)

Flag:
🔴 **Unused** — imported in pubspec but not in any Dart file
🔴 **Unmaintained** — no publish in 2+ years, pub.dev score below 60
🔴 **Platform-limited** — doesn't support a required target platform
🟡 **Outdated** — major version behind current, migration effort needed
🟡 **Overpinned** — will block transitive dependency resolution
🟢 **Up to date** — current version, well maintained

Also check:
- Are dev_dependencies correctly in dev_dependencies (not in dependencies)?
- Is `flutter_lints` or `very_good_analysis` present?
- Is there a `analysis_options.yaml`?

Output:
1. Flagged packages with recommended action
2. Packages to add (if obvious gaps: linting, testing tools)
3. Overall health score
4. One-line upgrade commands for the most important updates
