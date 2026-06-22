# Cosmic Wallpaper Studio

## Build Commands

```bash
# Get dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build APK release
flutter build apk --release

# Build AppBundle release
flutter build appbundle --release

# Clean build
flutter clean && flutter pub get

# Analyze code
flutter analyze
```

## Android Requirements
- Android SDK 33+
- minSdk: 21 (Android 5+)
- Gradle: 8.3
- Kotlin: 1.9.22

## Dependencies
- provider: State management
- sensors_plus: Gyroscope/accelerometer
- uuid: Unique IDs for projects/layers
- path_provider: File export paths
- permission_handler: Storage permissions
- path: Path utilities
