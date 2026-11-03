# dummyjsontest

Flutter client for the public [DummyJSON](https://dummyjson.com) API: login, a paginated product list, and product detail.

## Decisions

The app follows the [Flutter architecture guide](https://docs.flutter.dev/app-architecture/guide): a UI layer and a data layer. A domain layer is omitted. Login and products have no logic that would justify use cases.

| Topic | Choice |
| --- | --- |
| SDK | Flutter 3.47.1, Dart 3.13.1, pinned in `.fvmrc` |
| Structure | Feature folders with `data/dto/`, `data/repositories/`, and `presentation/<screen>/` |
| API models | `*Dto` classes in `data/dto/` |
| View models | Cubits (`flutter_bloc`), one per screen, sealed state |
| Navigation | `go_router`, with a redirect from a session cubit (`/splash` while restoring the token) |
| HTTP | One `Dio` client, timeouts, bearer interceptor |
| JSON | `json_serializable` and committed `*.g.dart` files |
| Errors | Repositories return `Result<T>`; `Failure` is sealed |
| Token | `flutter_secure_storage` only |
| List | `limit=20` and `skip`, pull-to-refresh, infinite scroll |

Views render state. Cubits call repositories. Repositories call feature API services. Services are the only code that uses `Dio`.

Agent constraints for this layout live in `AGENTS.md` and `.cursor/rules/`.

## SDK

The Flutter on `PATH` may be older than 3.47.1. Use FVM:

```bash
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter analyze
fvm flutter test
fvm flutter run
```

## API

- `POST /auth/login` — test user `emilys` / `emilyspass`
- `GET /products?limit=&skip=`
- `GET /products/:id`

The login form starts empty. Use `emilys` / `emilyspass` to sign in.
