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

## Gerar / atualizar o APK (aparelho físico)

Use **debug** para testar no celular contra o PC na mesma Wi‑Fi. Release bloqueia HTTP.

### 1. Descobrir o IP do PC (Windows)

```powershell
ipconfig
```

Procure o IPv4 da placa em uso (ex.: `192.168.100.3`). Não use `10.0.2.2` (só emulador) nem `127.0.0.1` (só o próprio PC).

### 2. Subir auth + API no PC

- Auth na porta **3010**
- BFF na porta **3000**
- Celular e PC na **mesma rede**

### 3. Build do APK debug

No diretório `goroute-mobile`, troque o IP pelo do passo 1 (ex.: `192.168.100.3`).

**PowerShell** — uma linha só (`\` do Bash **não** funciona no PowerShell):

```powershell
flutter pub get
flutter build apk --debug --dart-define=APP_FLAVOR=dev --dart-define=AUTH_BASE_URL=http://192.168.100.3:3010 --dart-define=API_BASE_URL=http://192.168.100.3:3000/api
```

**Git Bash / macOS / Linux** (quebra de linha com `\`):

```bash
flutter pub get
flutter build apk --debug \
  --dart-define=APP_FLAVOR=dev \
  --dart-define=AUTH_BASE_URL=http://192.168.100.3:3010 \
  --dart-define=API_BASE_URL=http://192.168.100.3:3000/api
```

Saída: `build/app/outputs/flutter-apk/app-debug.apk`

### 4. Instalar / atualizar no celular

**USB (adb)** — sobrescreve a instalação anterior (`-r`):

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install -r build\app\outputs\flutter-apk\app-debug.apk
```

**Sem cabo:** copie o `app-debug.apk` para o celular e abra o arquivo (permitir instalar de fontes desconhecidas).

### 5. Quando rebuildar de novo

Refaça os passos **3** e **4** sempre que:

- mudar código do app;
- o IP do PC mudar (rede/DHCP);
- quiser apontar para outro backend.

O APK embute as URLs no build — mudar só o backend no PC **não** atualiza um APK antigo.

### Release prod (HTTPS only)

```powershell
flutter build apk --release --dart-define=APP_FLAVOR=prod --dart-define=AUTH_BASE_URL=https://auth.example.com --dart-define=API_BASE_URL=https://api.example.com/api
```

Saída: `build/app/outputs/flutter-apk/app-release.apk`

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install -r build\app\outputs\flutter-apk\app-release.apk
```

## URLs de teste

| Ambiente | Auth | BFF |
|----------|------|-----|
| Aparelho físico (LAN) | `http://<IP-do-PC>:3010` | `http://<IP-do-PC>:3000/api` |
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
