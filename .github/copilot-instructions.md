# Inventory System - AI Coding Assistant Instructions

## Architecture Overview

This is a Flutter inventory management app using **Clean Architecture** with a .NET Web API backend. The app scans barcodes and stores them in a remote database.

### Project Structure
```
lib/
├── core/network/          # HTTP client (Dio configuration)
├── features/scan/         # Main feature module
│   ├── data/             # External layer (API, models)
│   ├── domain/           # Business logic (entities, repos, use cases)
│   └── presentation/     # UI layer (pages, bloc, states)
├── injection_container.dart  # Dependency injection (GetIt)
└── main.dart             # App entry point with MultiBlocProvider
```

## Key Patterns & Conventions

### Clean Architecture Layers
- **Domain**: Pure business logic with `Scan` entity and repository contracts
- **Data**: API integration with `ScanModel` (JSON serialization) and `ScanRemoteDataSource`
- **Presentation**: Flutter UI with `ScanCubit` state management

### State Management with BLoC
- Use `ScanCubit` with specific states: `ScanInitial`, `ScanLoading`, `ScanSuccess`, `ScanHistoryLoaded`, `ScanError`
- Load history with `context.read<ScanCubit>().getScans()` in `initState()`
- Always check `context.mounted` before using BuildContext after async operations

### API Configuration
- Base URL: `http://192.168.0.8:5214/api` (local development network)
- Uses Dio with 30-second timeouts
- Endpoints: `POST /Scans`, `GET /Scans`

### Dependency Injection
```dart
// Register dependencies in injection_container.dart
sl.registerLazySingleton<ApiClient>(() => ApiClient());
sl.registerFactory(() => ScanCubit(addScan: sl(), getScans: sl()));
```

## Critical Development Workflows

### Running the App
```bash
# Physical device (requires server on local network)
flutter run
# Clean rebuild if dependency issues
flutter clean && flutter pub get && flutter run
```

### Backend Integration
- .NET server must run with `applicationUrl: "http://0.0.0.0:5214"` in launchSettings.json
- Enable CORS for Flutter app communication
- Test server accessibility: `http://192.168.0.8:5214/swagger` from mobile browser

### Camera Permissions
- Android: Add `<uses-permission android:name="android.permission.CAMERA" />` to AndroidManifest.xml
- iOS: Add `NSCameraUsageDescription` to Info.plist
- Uses `mobile_scanner` package for barcode detection

## Code Patterns

### Error Handling
```dart
// Always emit loading state first
emit(ScanLoading());
try {
  // API call
  emit(ScanSuccess());
} catch (e) {
  emit(ScanError(message: e.toString()));
}
```

### Navigation Between Pages
- Bottom navigation with `ScanPage` (camera) and `ScanHistoryPage` (list)
- Trigger history reload when switching to history tab

### Audio Feedback
- Play `assets/beep.mp3` on successful barcode scan
- Dispose AudioPlayer in widget lifecycle

## Common Issues & Solutions

1. **BuildContext across async gaps**: Use `if (!context.mounted) return;`
2. **Provider not found**: Ensure BlocProvider is above widget tree
3. **Network connection**: Verify local IP and server configuration
4. **Hot reload issues**: Use hot restart for dependency injection changes

## File Templates

### New Feature Structure
```
features/[feature_name]/
├── data/
│   ├── datasources/[feature]_remote_data_source.dart
│   ├── models/[feature]_model.dart
│   └── repositories/[feature]_repo_impl.dart
├── domain/
│   ├── entities/[feature].dart
│   ├── repositories/[feature]_repository.dart
│   └── usecases/[action]_[feature].dart
└── presentation/
    ├── bloc/[feature]_cubit.dart
    └── pages/[feature]_page.dart
```

### State Management Boilerplate
- Extend `Equatable` for all states and entities
- Use `part of` directive for state files
- Implement proper `props` getter for state comparison
