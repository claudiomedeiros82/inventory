Review the app's monetization implementation for correctness, compliance, and conversion.

Read the relevant files:
- Any paywall or subscription screen in `lib/features/`
- IAP-related services or repositories
- `pubspec.yaml` for IAP packages in use (in_app_purchase, purchases_flutter/RevenueCat)

Delegate to the Monetization Agent.

Review for:

**App Store / Play Store compliance**
- [ ] Price displayed clearly before purchase (with currency and billing period)
- [ ] Subscription terms (duration, price, renewal) visible before payment
- [ ] Free trial start and end date shown explicitly if offered
- [ ] Restore purchases button present and accessible
- [ ] No external payment links or mentions in app (App Store rule 3.1.1)
- [ ] Paywall not shown on first launch (unless it IS the core product)

**Implementation correctness**
- [ ] Loading state while purchase is processing
- [ ] Error state for: cancelled, pending, failed, network error
- [ ] Purchase receipt validation (RevenueCat or server-side)
- [ ] `restorePurchases()` correctly restores entitlements
- [ ] App state updates immediately after successful purchase (no re-launch needed)
- [ ] Consumable vs non-consumable correctly typed

**Conversion**
- [ ] Paywall shown at the value moment (after user experiences the core benefit)
- [ ] Clear value proposition above the price
- [ ] No dark patterns (hidden cancel, countdown timers, guilt trip copy)
- [ ] Price localized to user's currency/region

**Output format:**
1. **Compliance issues** — must fix before submission
2. **Implementation bugs** — will cause crashes or incorrect behavior
3. **Conversion improvements** — nice to have, higher revenue
4. **Looks good** — what's correctly implemented
