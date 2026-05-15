# Lumina
A multi-tenant goal management platform for alignment, check-ins, and performance visibility.

## Current Phase

UI-only Flutter foundation.

- No Firebase connection yet.
- No Microsoft Entra ID authentication yet.
- No backend writes yet.
- All data is mocked in code for fast UI iteration.

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Verify

```bash
flutter analyze
flutter test
flutter build web --release
```

## Workflow

1. Build and polish the UI with mock data.
2. Add Firebase configuration.
3. Add Firestore repositories and security rules.
4. Add Microsoft Entra ID sign-in through Firebase Auth.
5. Add tenant isolation and role mapping.
6. Add reports, audit logging, and deployment automation.
