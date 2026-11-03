---
name: flutter-dummyjson-app
description: Builds and changes the DummyJSON Flutter app (login, paginated products, product detail) with Flutter 3.47.1, Cubit view models, go_router, dio, and json_serializable. Use when editing Dart or Flutter files, screens, auth, products, pagination, navigation, the API client, or project structure in this repo.
---

# DummyJSON Flutter app

Follow [AGENTS.md](../../../AGENTS.md) and `.cursor/rules/`. Those files are the source of truth for layout, SDK, and dependencies.

## Workflow

1. Confirm the command uses `fvm flutter` or `fvm dart`. The global SDK is 3.35.5 and must not compile or analyze this app.
2. Place files in `presentation/<screen>/` from AGENTS.md. A screen folder has four files: sealed state, Cubit, page (`BlocProvider`), view (`BlocBuilder`).
3. Cubits depend on a repository. Repositories depend on a service. Services use the shared `Dio` in `core/network`.
4. Return `Result<T>` from repositories. Map `DioException` to a sealed `Failure` there.
5. Add or update the `GoRoute` in `app/router.dart`. Auth redirects read the session cubit, which starts as `unknown` until secure storage loads.
6. After a `@JsonSerializable` change, run `fvm dart run build_runner build --delete-conflicting-outputs` and keep the `.g.dart` file.
7. Run `fvm flutter analyze`. Fix new issues before finishing.

## Screen checklist

- Initial loading, failure with retry, and empty are distinct widgets.
- Product list: page size 20, `skip` is the loaded count, pull-to-refresh replaces items, load-more appends, list stays visible during refresh and load-more.
- Tapping a product opens `/products/:id`.
- Login writes the access token only through `flutter_secure_storage`.

## Commands

```bash
fvm flutter analyze
fvm flutter test
fvm dart run build_runner build --delete-conflicting-outputs
```
