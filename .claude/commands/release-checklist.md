Run the pre-release checklist before submitting to the App Store or Play Store.

First, read:
- `pubspec.yaml` — version number and build number
- `CHANGELOG.md` or `docs/templates/release-notes.md` if present
- `ios/Runner/Info.plist` — permissions and usage descriptions
- `android/app/src/main/AndroidManifest.xml` — permissions

Then run through this checklist and report status for each item:

**BOTH PLATFORMS**
- [ ] Version number bumped in pubspec.yaml
- [ ] Build number incremented (always, even for same version)
- [ ] Release notes written (check docs/templates/release-notes.md)
- [ ] All `print()` statements removed from production code
- [ ] No TODO/FIXME comments in release-blocking code paths
- [ ] App tested on physical device (confirm with developer)
- [ ] Tested on oldest supported OS version (confirm with developer)
- [ ] Crashlytics initialized and reporting correctly

**iOS**
- [ ] Privacy manifest (`PrivacyInfo.xcprivacy`) present and accurate
- [ ] All NS*UsageDescription keys in Info.plist present for requested permissions
- [ ] No unused permissions in Info.plist
- [ ] Screenshots uploaded for required device sizes in App Store Connect
- [ ] Age rating correct
- [ ] Export compliance answered
- [ ] Restore purchases accessible if app has IAP
- [ ] Subscription terms visible before purchase if app has subscriptions

**ANDROID**
- [ ] AAB built (`flutter build appbundle --release`) — NOT APK
- [ ] Data safety section in Play Console matches actual data collection
- [ ] Target SDK meets current Play Store minimum
- [ ] Signing config correct for release build type
- [ ] Proguard/R8 rules don't strip needed classes (test the release build)

**OUTPUT**
List every item as ✅ PASS, ⚠️ NEEDS CONFIRMATION, or ❌ FAIL with explanation.
Give an overall GO / NO-GO recommendation.
Delegate to the Release Manager agent for any items requiring deeper expertise.
