Review the app's onboarding flow for conversion and retention impact.

Read:
- Any onboarding screens in `lib/features/onboarding/` or similar
- The first screen a new user sees after install (check `lib/main.dart` initialLocation)
- Any permission request flows

If no onboarding folder exists: do NOT stop. Instead, evaluate the first screen the
user sees as the de facto onboarding experience. Note that for utility apps, no
dedicated onboarding is often the right call — zero friction beats education.

Delegate to the UX/UI Lead and Mobile Director agents for this review.

Evaluate against these principles:

**Length**
- [ ] Max 3 onboarding screens — each additional screen loses ~20% of users
- [ ] Skip button present from screen 1 (unless genuinely required setup)
- [ ] No account creation before showing core value

**Value demonstration**
- [ ] User sees the core benefit before being asked for anything
- [ ] No permission requests before demonstrating why the permission is needed
- [ ] "Show don't tell" — interactive preview beats static description

**Permission requests**
- [ ] Notification permission requested at value moment (not on launch)
- [ ] Camera/microphone requested when user triggers the feature needing it
- [ ] Location requested with clear explanation of why
- [ ] Each permission has a pre-prompt screen explaining the value

**Friction**
- [ ] No mandatory account creation for v1 (if local-first is viable)
- [ ] If sign-in required: sign in with Apple/Google available
- [ ] Form fields minimized — ask only what's needed now

**Market-specific** (if applicable)
- [ ] Auth method matches market expectations (phone/OTP vs email/password varies by region)
- [ ] Onboarding copy localised if targeting non-English markets
- [ ] Low-bandwidth consideration — onboarding animations should be lightweight

**Output:**
1. Issues ranked by conversion impact
2. Specific screen-by-screen recommendations
3. One change that would have the highest impact on day-1 retention
