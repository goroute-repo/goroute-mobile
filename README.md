# GoRoute: Plano de Carreira

**Subtítulo (ASO):** Trilha, skills e vagas com match

Cliente Flutter GoRoute: auth (login/MFA), shell Material 3, roadmap, weekly, jobs, mentor, notifications e settings.

## Setup

```bash
flutter pub get
flutter test
flutter analyze
```

## Flavors (`APP_FLAVOR`)

| Flavor | Cleartext HTTP | Defaults |
|--------|----------------|----------|
| `dev` (default) | Sim (debug/profile Android) | Emulator `10.0.2.2:3010` / `:3000/api` |
| `prod` | Não (release manifest) | Exige `https://` em `AUTH_BASE_URL` e `API_BASE_URL` |

```bash
# Dev / LAN em aparelho físico (NÃO use o APK prod release)
# Release bloqueia HTTP; use debug (cleartext) + IP do PC na mesma subnet:
flutter build apk --debug \
  --dart-define=APP_FLAVOR=dev \
  --dart-define=AUTH_BASE_URL=http://192.168.x.x:3010 \
  --dart-define=API_BASE_URL=http://192.168.x.x:3000/api
# APK: build/app/outputs/flutter-apk/app-debug.apk
# Default 10.0.2.2 só funciona no emulador Android.

# Release prod (HTTPS only)
flutter build apk --release \
  --dart-define=APP_FLAVOR=prod \
  --dart-define=AUTH_BASE_URL=https://auth.example.com \
  --dart-define=API_BASE_URL=https://api.example.com/api
```

APK release: `build/app/outputs/flutter-apk/app-release.apk`

### adb (Windows)

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install -r build/app/outputs/flutter-apk/app-release.apk
```

## URLs de teste

| Ambiente | Auth | BFF |
|----------|------|-----|
| Emulator (`AppConfig.local` / resolve dev) | `http://10.0.2.2:3010` | `http://10.0.2.2:3000/api` |
| Desktop / unit tests | `http://127.0.0.1:3010` | `http://127.0.0.1:3000/api` |

Headers: `X-Application-From: goroute-mobile`, `x-session-id`, `x-mapper-api` (após login/MFA com `sessionId` + `mapApiHash`).

## Cache / UX

- Última resposta de **roadmap** e **weekly-plan** em `SharedPreferences` (fallback offline leve)
- Skeletons em listas; busca de vagas com debounce 300ms
- Cleartext só em **debug/profile**; release = HTTPS

## MFA

Login com `mfaRequired` + `tempToken` → tela TOTP → `POST /users/mfa/verify`.

## Drift SPEC — mobileAppKey (CA-150)

Deprecated / unused. UI AppKey fora de escopo.

## Fora de escopo

- Push (CA-151), deep links, Stripe in-app, biometria (opcional futuro), offline-first completo
