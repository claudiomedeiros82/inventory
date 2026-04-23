Review the backend integration in this Flutter project, or recommend a backend if none exists yet.

First, auto-detect what backend the project uses by reading `pubspec.yaml` and scanning `lib/`:

| Package / pattern found | Backend |
|------------------------|---------|
| `firebase_core` | Firebase |
| `supabase_flutter` | Supabase |
| `appwrite` | Appwrite |
| `pocketbase` | PocketBase |
| `http` or `dio` only, no BaaS | Custom REST (Railway, custom server, etc.) |
| Multiple of the above | Hybrid — review each |

---

## If no backend is detected — greenfield mode

Do NOT stop. Instead, help the developer choose the right backend by asking (or inferring from context):

1. **Does the app need a backend at all?**
   - Local-only apps (Hive/Isar, no sync) need zero backend — say so clearly
   - If the app stores data only on-device and doesn't share between users, recommend staying local

2. **If a backend is needed, gather requirements:**
   - Real-time data? (chat, live scores, collaborative)
   - Auth required? (social login, email/password, phone OTP)
   - File storage? (images, documents, audio)
   - Server-side logic? (payments, webhooks, scheduled jobs)
   - Team size and backend experience?
   - Budget constraints?
   - Target market? (consider regional latency and pricing)

3. **Recommend based on answers:**

| Use case | Recommendation | Why |
|----------|---------------|-----|
| Solo dev, fast shipping, no custom logic | Supabase | Postgres, auth, storage, realtime — generous free tier, great Flutter SDK |
| Heavy real-time (chat, live updates) | Supabase or Firebase | Both work; Supabase is cheaper at scale |
| Google ecosystem / existing GCP | Firebase | Native integration, Crashlytics, Remote Config |
| Need full control, custom logic, already know Node/Python | Railway + custom API | Deploy any backend, predictable pricing |
| Offline-first, sync later | PocketBase | Embeddable, can self-host cheaply, good Flutter SDK |
| No backend at all (local data only) | Hive + Isar | Zero cost, zero latency, no account needed |
| Cost-sensitive / high volume | Supabase (free tier) or Railway (~$5/mo) | Firebase costs spike fast at scale — Supabase is more predictable |

4. **Output a concrete recommendation:**
   - Which backend and why
   - Which Flutter package to add
   - Starter code: repository interface + impl skeleton for their use case
   - What NOT to build themselves (auth, storage — use the platform)

---

Delegate to the Backend Integration Agent for deep expertise.

---

## Checks that apply to ALL backends

**Secrets and config**
- [ ] No API keys, base URLs, or secrets hardcoded in Dart files
- [ ] Credentials loaded via `String.fromEnvironment()` or a `.env` approach
- [ ] No sensitive values committed to git (check for `.env` in `.gitignore`)

**Auth token storage**
- [ ] Auth tokens stored in `flutter_secure_storage` — NOT `SharedPreferences`
- [ ] Token refresh handled — app doesn't silently fail after expiry
- [ ] Sign-out clears all local state and cached data

**Repository layer**
- [ ] Data layer is behind an abstract repository interface
- [ ] UI never calls backend SDKs directly — always through a repository
- [ ] DTOs mapped to domain models before reaching the UI

**Network calls**
- [ ] Every HTTP call has an explicit timeout set
- [ ] All three states handled in UI: loading, success, error
- [ ] Errors distinguish between network failure and server error

---

## Firebase-specific checks

*(Skip if Firebase not detected)*

**Security rules**
- [ ] Firestore rules don't default to `allow read, write: if true`
- [ ] Rules validate authentication before writes
- [ ] Storage rules restrict file types and sizes

**Firestore queries**
- [ ] No unbounded queries (always use `.limit()`)
- [ ] No full collection reads filtered client-side
- [ ] Realtime listeners disposed when screen exits

**Cost**
- [ ] `get()` for one-time reads, not `snapshots()`
- [ ] Images in Storage, not base64 in Firestore documents
- [ ] No unnecessary subcollection nesting

**Crashlytics**
- [ ] `FirebaseCrashlytics.instance.recordError()` in global error handler
- [ ] Custom keys set for context — no PII stored

---

## Supabase-specific checks

*(Skip if Supabase not detected)*

**Security**
- [ ] Row Level Security enabled on all tables used by the app
- [ ] RLS policies tested — not just enabled
- [ ] Anon key used client-side (expected), service key never in app

**Realtime**
- [ ] Supabase channel subscriptions cancelled on screen dispose
- [ ] No subscriptions created in `build()` — use `initState` or provider

**Storage**
- [ ] Bucket policies restrict access to authenticated users where needed
- [ ] Signed URLs used for private files (not public bucket URLs)

**Auth**
- [ ] `Supabase.instance.client.auth.onAuthStateChange` used for auth state
- [ ] Deep link handling configured for OAuth and magic links

---

## Custom REST / Railway / self-hosted checks

*(Apply when only `http` or `dio` detected, or alongside a BaaS)*

**Configuration**
- [ ] Base URL not hardcoded — loaded from environment
- [ ] Different base URLs for dev/staging/prod (build flavors or `--dart-define`)

**Dio setup (if using Dio)**
- [ ] Interceptor handles 401 → token refresh → retry
- [ ] Timeout set on both connection and receive
- [ ] Error interceptor maps HTTP errors to typed exceptions

**API design**
- [ ] Sensitive params in request body (POST/PUT), not URL query params
- [ ] Pagination uses cursor-based approach, not offset

---

## PocketBase / Appwrite-specific checks

*(Skip if not detected)*

- [ ] Admin credentials never present in the Flutter app
- [ ] Collection/bucket permissions set to minimum required
- [ ] SDK version up to date (check pub.dev)
- [ ] Auth token persisted securely, not in SharedPreferences

---

## Output format

1. **Backend detected:** [list what was found]
2. **Security issues** — fix before shipping (any backend)
3. **Correctness bugs** — will cause crashes or data loss
4. **Cost / performance risks** — may cause unexpected bills or slowness at scale
5. **Optimization suggestions** — nice to have
6. **Overall verdict:** GO / NEEDS WORK / BLOCKED
