Create a development sprint plan for the goal provided.

Goal: $ARGUMENTS

If no goal is provided, ask: "What's the goal for this sprint? (e.g., 'Ship onboarding flow' or 'Get to App Store submission')"

Read the current project state:
- `lib/features/` — what's already built
- `pubspec.yaml` — current version
- `docs/sprint-plan.md` — previous sprint if exists

Delegate to the Mobile Director agent for scope decisions and Technical Lead for task breakdown.

Produce a sprint plan:

```
SPRINT GOAL
[One sentence — what done looks like]

DURATION
[Recommended: X days based on scope]

DAILY BREAKDOWN

Day 1: [Theme]
- [ ] Task 1 (est: Xh)
- [ ] Task 2 (est: Xh)

Day 2: [Theme]
- [ ] Task 3 (est: Xh)
...

OUT OF SCOPE (save for next sprint)
- [Things that could creep in but shouldn't]

DONE CRITERIA
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]

RISKS
- [What could block this sprint]
```

Rules for the plan:
- Each day has a clear theme (not a random task list)
- Tasks are concrete and completable in a session
- Out of scope section is as important as in scope — protect the sprint
- Done criteria are observable (not "feels good", but "screen X works on physical device")

Save the plan to `docs/sprint-plan.md` after generating.
Ask the developer to confirm before saving.
