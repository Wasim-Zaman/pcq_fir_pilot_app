# AI Instructions for PCQ FIR Pilot App

## 🎯 Project Overview

Flutter app for gate pass management with real-time connectivity monitoring and offline-first architecture. Uses Riverpod for state management, GoRouter for navigation, and a custom ApiClient wrapper around Dio.

**Critical**: The app wraps the entire MaterialApp with `ConnectivityWrapper` (in `lib/app.dart`) that overlays `NoInternetScreen` when offline while preserving widget state underneath using Stack layout.

## 🏗️ Architecture Patterns

### State Management (AsyncNotifier Pattern)

All business logic lives in **AsyncNotifier** classes, not UI widgets:

```dart
class FeatureNotifier extends AsyncNotifier<FeatureState> {
  @override
  Future<FeatureState> build() async => const FeatureState();
  
  Future<void> performAction() async {
    state = const AsyncValue.data(FeatureState(isLoading: true));
    final result = await ref.read(featureRepoProvider).fetchData();
    
    if (result is ApiSuccess<DataModel>) {
      state = AsyncValue.data(FeatureState(data: result.data));
    } else if (result is ApiError<DataModel>) {
      state = AsyncValue.data(FeatureState(error: result.message));
    }
  }
}
```

**Key conventions**:
- State classes must have `copyWith()` method
- Use `AsyncValue.data()` for state updates (not direct assignment)
- Handle `ApiSuccess` and `ApiError` explicitly with pattern matching
- Provider naming: `featureProvider`, `featureRepoProvider`

### Network Layer (ApiState Pattern)

All API calls return `ApiState<T>` sealed class (in `lib/core/network/api_client.dart`):

```dart
// Repository pattern - ALL API calls go through repos
class GatepassRepo {
  final ApiClient _apiClient;
  
  Future<ApiState<DataModel>> fetchData() async {
    return _apiClient.get<DataModel>(
      '/endpoint',
      parser: (data) => DataModel.fromJson(data),
    );
  }
}
```

**API response handling**:
- `ApiSuccess<T>` - contains `data` and `statusCode`
- `ApiError<T>` - contains `message`, `statusCode`, `type` (enum: noInternet, timeout, unauthorized, etc.)
- `ApiClient` automatically checks internet via `InternetAddress.lookup('google.com')` before requests
- Use pattern matching: `if (result is ApiSuccess<T>)` NOT `.when()` methods

### Navigation (GoRouter)

Routes defined in `lib/core/router/app_routes.dart` with `k` prefix constants:

```dart
const kDashboardRoute = '/dashboard';
const kDashboardRouteName = 'dashboard';
```

Navigate using: `context.push(kDashboardRoute, extra: data)` - never hardcode paths.

### Feature Module Structure

```
lib/presentation/features/feature_name/
├── models/              # Data models with fromJson/toJson/copyWith
├── providers/           # AsyncNotifier business logic
├── view/                # Screens (StatelessWidget/ConsumerWidget only)
│   ├── feature_screen.dart
│   └── widgets/         # Feature-specific widgets
│       └── screen_name/ # Widgets organized by screen
```

**Critical rules**:
- UI widgets should be **stateless** - no business logic in views
- Use `ConsumerWidget` to watch providers: `ref.watch(provider)`
- Listen for side effects: `ref.listen(provider, (prev, next) => {})` 
- Repositories live in `lib/repos/` not inside features

## 🔧 Key Utilities

### Extensions (lib/core/extensions/)

```dart
// SizedBox shortcuts
16.heightBox  // SizedBox(height: 16)
20.widthBox   // SizedBox(width: 20)

// DateTime formatting
DateTime.now().toFormattedDate()      // "17/10/2025"
DateTime.now().toFormattedDateTime()  // "17/10/2025 14:30"
```

### Custom Widgets (lib/presentation/widgets/)

- `CustomScaffold` - Standard scaffold with consistent AppBar, padding, safe areas
- `CustomButton` - Button with built-in loading state (`isLoading` prop)
- `CustomTextField` - Form field with validation support
- `CustomDropdown` - Dropdown with consistent styling

**Usage**: Always use these instead of raw Material widgets for consistency.

## 🌐 Connectivity Monitoring

The `ConnectivityWrapper` in `lib/app.dart` uses **Stack-based overlay** approach:

```dart
Stack(
  children: [
    if (child != null) child!,  // Always render app (preserves state)
    if (status == ConnectivityStatus.disconnected)
      Positioned.fill(child: const NoInternetScreen()),
  ],
)
```

**Why**: Prevents widget tree rebuilds that lose scroll position, form state, etc. The app remains mounted underneath the overlay.

`ConnectivityService` (in `lib/services/`) does two checks:
1. `Connectivity.checkConnectivity()` - checks network connection
2. `InternetAddress.lookup('google.com')` - verifies actual internet access

## 🚀 Development Commands

```bash
# Run app
flutter run                    # Debug mode on connected device
flutter run -d chrome          # Web browser
flutter run --release          # Release mode

# Testing
flutter test                   # Run all tests
flutter test --coverage        # With coverage report

# Building
flutter build apk --release    # Android APK
flutter build appbundle        # Android App Bundle (for Play Store)
flutter build ios --release    # iOS build
flutter build web --release    # Web build
```

**Note**: Project requires Flutter SDK ≥3.9.0, uses Material 3 design.

## 📝 Code Conventions

- Constants use `k` prefix: `kPrimaryColor`, `kDashboardRoute`
- Private members: `_apiClient`, `_handleError()`
- Provider naming: `dashboardProvider`, `gatepassRepoProvider`
- All API error messages extracted dynamically from response body (see `_getErrorMessage` in ApiClient)
- Use `dev.log()` for logging (not `print`), with `name: 'API Client'` parameter

## ⚠️ Common Pitfalls

1. **Never put business logic in widgets** - use AsyncNotifier instead
2. **Don't call repos directly from UI** - always through providers
3. **API responses need pattern matching** - check for `ApiSuccess`/`ApiError` explicitly
4. **State updates require AsyncValue.data()** - not direct assignment to `state`
5. **Routes must use constants** - import from `app_routes.dart`, never hardcode paths
6. **Connectivity checks are automatic** - ApiClient handles internet checks before requests

## 📦 Key Dependencies

- `flutter_riverpod: ^3.0.1` - State management (AsyncNotifier pattern)
- `go_router: ^16.2.4` - Declarative routing
- `dio: ^5.9.0` - HTTP client (wrapped by ApiClient)
- `connectivity_plus: ^7.0.0` - Network status monitoring
- `fl_chart: ^0.69.0` - Dashboard analytics charts

## 🔍 Finding Code

- **State logic**: `lib/presentation/features/*/providers/`
- **API calls**: `lib/repos/` (GatepassRepo, MemberRepo)
- **Models**: `lib/presentation/features/*/models/`
- **Routes**: `lib/core/router/app_routes.dart`
- **Theme/Colors**: `lib/core/constants/app_themes.dart`, `app_colors.dart`
- **Network setup**: `lib/core/network/api_client.dart` (base URL, interceptors)

---

**When in doubt**: Check existing implementations in `dashboard` or `gatepass` features - they follow all patterns consistently.
