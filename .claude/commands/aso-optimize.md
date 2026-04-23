Generate complete App Store and Play Store metadata for this Flutter app.

First, read the following to understand the app:
- `pubspec.yaml` — app name, description
- `lib/main.dart` — entry point and routing
- `lib/features/` — what features exist
- `docs/aso-strategy.md` if it exists (prior run of this command)

Then ask the developer (or infer from context) if not already clear:
- What is the core problem this app solves?
- Who is the target user?
- What market(s)? (US, Europe, global, specific region?)
- Any existing keywords or competitor apps to reference?

Generate the full metadata package:

---
APP STORE METADATA
Title (max 30 chars):
Subtitle (max 30 chars):
Keywords (max 100 chars, comma-separated, no spaces after commas):
Promotional text (max 170 chars, can change without release):

Description:
[First 3 lines are critical — shown before "more". Lead with the core benefit.]
[Full description: benefit-led, not feature-led. Max 4000 chars.]

---
PLAY STORE METADATA
Title (max 50 chars):
Short description (max 80 chars):

Full description:
[Keyword-rich. Play Store indexes this. First 167 chars shown without expansion.]
[Max 4000 chars. Include primary keywords naturally 3-5 times.]

---
KEYWORD ANALYSIS
Primary keywords (highest volume):
Long-tail keywords (lower competition):
Keywords NOT to use (too competitive or irrelevant):
Localization note (if targeting non-English markets):

---
A/B TEST SUGGESTION
Alternative title:
Alternative subtitle:
Why to test this:

Delegate to the ASO Copywriter agent for the actual writing.
