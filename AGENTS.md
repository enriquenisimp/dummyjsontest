# AGENTS.md

This is a small Flutter client for the public [DummyJSON](https://dummyjson.com) API. It is a senior-level sample: login, a paginated product list, and product detail. Decisions below are locked. Change them only when the user asks.

## SDK

Flutter **3.47.1**, Dart **3.13.1** (revision `6655482ec06e547f90abf8ae7590466f4415978d`).

`.fvmrc` pins that version. Every command uses FVM:

```bash
fvm flutter analyze
fvm flutter test
fvm flutter run
fvm dart run build_runner build --delete-conflicting-outputs
```

The `flutter` binary on `PATH` is 3.35.5 / Dart 3.9.2. Do not use it.

## Read before editing

1. `.cursor/rules/` — always-on constraints.
2. `.cursor/skills/flutter-dummyjson-app/SKILL.md` — workflow for a screen or data change.

## Architecture

Flutter's UI + data split. No domain layer and no use cases. Two features do not need them.

| Piece | Responsibility |
| --- | --- |
| View | Renders state. `StatelessWidget`. |
| View model | One Cubit per screen. |
| Repository | I/O boundary the cubit is allowed to call. |
| Service | HTTP for one feature. Only the repository calls it. |

```
lib/
  main.dart
  app/
  core/error/
  core/network/
  core/storage/
  features/auth/data/dto/
  features/auth/data/repositories/
  features/auth/presentation/session/
  features/auth/presentation/login/
  features/products/data/dto/
  features/products/data/repositories/
  features/products/presentation/product_list/
  features/products/presentation/product_detail/
```

API response models live in `data/dto/` and are named `*Dto`. Repositories live in `data/repositories/`. Feature API services stay in `data/`. Each screen lives in its own `presentation/<screen>/` folder with cubit, state, page, and view.

Direction is view → cubit → repository → service → shared `Dio`. Presentation does not import `dio` or dummyjson URLs.

## State and navigation

- `flutter_bloc` Cubits. Sealed state. No Bloc event classes, Riverpod, `provider`, or `setState` for feature state.
- `go_router` routes come from the `AppRoute` enum (`path` + `name`) in `lib/app/app_route.dart`. Do not hardcode path strings.
- A session cubit above `MaterialApp.router` owns whether a token is loaded. Startup is `unknown` until `flutter_secure_storage` returns; the router stays on splash during that window. `GoRouter.refreshListenable` listens to that cubit.
- Redirect: unauthenticated users to login; authenticated users away from login and splash to products.

## Data

- One `Dio` client, base URL `https://dummyjson.com`, timeouts, bearer interceptor.
- `POST /auth/login` with the test user `emilys` / `emilyspass`. Store only the access token in `flutter_secure_storage`.
- `GET /products?limit=20&skip=` and `GET /products/:id`.
- Repositories return `Result<T>` (`Success` or `Failure`). `Failure` is sealed.
- API responses are `*Dto` classes in `data/dto/` using `json_serializable`. Repositories live in `data/repositories/`. Commit generated `*.g.dart` files.
- List states the UI must render: initial loading, error with retry, empty, populated, refresh (list stays visible), load-more (footer indicator). Stop paging when `items.length >= total` or a page is empty.

## Adding a screen

1. Create `presentation/<screen>/` with sealed state, Cubit, page, and view.
2. Page widget that creates the cubit with `BlocProvider` and injects the repository.
3. View widget that uses `BlocBuilder` for UI and `BlocListener` for one-off effects.
4. Repository method that calls a service and returns `Result`.
5. Register the route in `app/router.dart`.

## Out of scope unless the user asks

Use cases, a domain folder, Bloc events, Riverpod, `provider`, GetIt, `SharedPreferences` for the token, handwritten `fromJson`, a second HTTP client, and changing the Flutter pin.
