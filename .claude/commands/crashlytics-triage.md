Triage the crash log provided by the developer.

The developer will paste a crash log, stack trace, or ANR report.
If no log is provided yet, ask: "Paste the crash log or stack trace and I'll diagnose it."

Delegate to the Crashlytics Triage Agent.

The agent will:
1. Identify the crash type and find the relevant Dart frame
2. Explain the root cause in plain language
3. Write the exact code fix
4. Write a regression test that would have caught this
5. Flag any similar patterns elsewhere in the codebase

After the triage, ask:
- "Do you want me to apply the fix now?"
- "Do you want me to write the regression test?"

If yes to either, do it immediately.
