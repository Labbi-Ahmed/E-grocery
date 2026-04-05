# E-Grocery - Labbi African Market E-Commerce App

## Project Overview
African grocery/food marketplace Flutter app supporting retail and wholesale customers.
REST API-based with Clean Architecture.

## Tech Stack
- **Flutter** 3.41.x / Dart 3.11.x
- **State Management:** flutter_bloc (Cubit pattern)
- **API Client:** Dio + Retrofit
- **Navigation:** GoRouter
- **DI:** GetIt + Injectable
- **Local Storage:** Hive + SharedPreferences
- **Architecture:** Clean Architecture (Data → Domain → Presentation)

## Architecture

```
lib/
├── core/
│   ├── api/            # Dio client, interceptors, API error handling
│   ├── constants/      # Colors, strings, assets, endpoints
│   ├── theme/          # AppTheme, text styles
│   ├── router/         # GoRouter config
│   ├── di/             # GetIt setup
│   ├── utils/          # Helpers, extensions, validators
│   └── widgets/        # Shared widgets (AppButton, ProductCard, etc.)
├── features/
│   ├── <feature>/
│   │   ├── data/
│   │   │   ├── datasources/   # Remote & local data sources
│   │   │   ├── models/        # JSON serializable models
│   │   │   └── repositories/  # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/      # Business entities
│   │   │   ├── repositories/  # Repository interfaces
│   │   │   └── usecases/      # Business logic
│   │   └── presentation/
│   │       ├── cubit/         # Cubit + State
│   │       ├── screens/       # Full page widgets
│   │       └── widgets/       # Feature-specific widgets
│   ├── auth/
│   ├── home/
│   ├── categories/
│   ├── product_detail/
│   ├── cart/
│   ├── checkout/
│   ├── store/
│   ├── orders/
│   ├── profile/
│   ├── wholesale/
│   └── wishlist/
└── main.dart
```

## Git Workflow
- **Default branch:** `develop`
- **Feature branches:** `feature/<issue-name>` from `develop`
- **PRs:** Feature → develop
- **Naming:** kebab-case for branches, snake_case for Dart files

## Design
- **Figma:** https://www.figma.com/design/Hgy1KzRcXcppVJU28ctAh3/Labbi-African-Market-Ecommarce-App
- **Primary Green:** `#4CAF50` / `#2E7D32`
- **Accent Yellow:** `#FFC107`
- **Background:** `#FFFFFF`
- **Surface:** `#F5F5F5`
- **Text Primary:** `#212121`
- **Text Secondary:** `#757575`

## Commands
```bash
# Run app
flutter run

# Build
flutter build apk --release
flutter build ios --release

# Generate code (freezed, json_serializable, retrofit, injectable)
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Analyze
flutter analyze
```

## Conventions
- Use Cubit (not full Bloc) unless event-driven logic is needed
- All API calls go through repository pattern
- Use `Either<Failure, T>` for error handling (dartz)
- Models use `freezed` + `json_serializable`
- Screens suffixed with `Screen`, widgets with `Widget` or descriptive name
- One cubit per feature screen, shared cubits in core if cross-feature
- Mock data in `data/datasources/` for frontend-first development
- Prefer `const` constructors where possible
