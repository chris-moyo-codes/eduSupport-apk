# EduSupport Mobile

EduSupport Mobile is the Android-first Flutter application for the EduSupport product ecosystem. This repository is intentionally separate from the existing web codebase and is designed to mirror the same product identity, architecture, and navigation conventions while adapting the experience for mobile.

## Flutter and Dart versions

- Flutter: 3.44.8
- Dart: 3.12.2

## Prerequisites

- Flutter SDK installed and on the PATH
- Android SDK with command-line tools
- A configured Android emulator or physical device
- VS Code with the Flutter and Dart extensions
- Java 21 or compatible JDK for Android build tooling

## VS Code setup

1. Install the Flutter and Dart extensions.
2. Open the workspace root.
3. Ensure the Flutter SDK path is configured in your VS Code environment.
4. Open the Android emulator or attach a device.

## Android setup

1. Install Android Studio.
2. Install the Android SDK and command-line tools.
3. Accept Android licenses with `flutter doctor --android-licenses`.
4. Create or start an emulator in Android Studio.

## Run the app

```sh
flutter pub get
flutter run
```

## Run tests

```sh
flutter test
```

## Run analysis

```sh
flutter analyze
```

## Architecture

The mobile app foundation is organized into:

- `lib/app` for high-level application composition
- `lib/app/router` for centralized navigation
- `lib/config` for environment configuration
- `lib/core` for shared constants and exception types
- `lib/features` for feature-level presentation and state
- `lib/network` for HTTP/API abstraction
- `lib/storage` for secure persistence
- `lib/theme` for design-system tokens

## Environment configuration

The app environment is centralized in `lib/config/app_config.dart`.

## Authentication handling

Authentication bootstrap and route gating are handled through `lib/features/auth/application/auth_controller.dart` and the router redirect layer in `lib/app/router/app_router.dart`.

## Theme and design tokens

Colors, typography, and foundation theming live in `lib/theme/app_theme.dart`.

## Future feature organization

New features should be added under `lib/features/<feature-name>/` with a clear division between presentation, application logic, and data concerns.
