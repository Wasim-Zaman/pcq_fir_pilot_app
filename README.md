# PCQ FIR Pilot App

A Flutter application with real-time connectivity monitoring and intelligent overlay-based offline handling.

## 🌟 Features

- **Real-time Connectivity Monitoring** - Instant detection of network changes
- **Intelligent Overlay System** - Non-intrusive no-internet screen
- **State Preservation** - App maintains state during connectivity changes
- **Clean Architecture** - Separation of concerns with proper layering
- **Material 3 Design** - Modern UI with Material Design 3

## 🏗️ Architecture

### Connectivity Wrapper Architecture

The app uses a sophisticated wrapper-based approach for handling connectivity:

```text
┌─────────────────────────────────────┐
│     MaterialApp.router              │
│                                     │
│  ┌───────────────────────────────┐ │
│  │  builder: ConnectivityWrapper │ │
│  │                               │ │
│  │  ┌─────────────────────────┐ │ │
│  │  │   GoRouter (child)      │ │ │  ← Your app runs normally
│  │  │   - SignInScreen        │ │ │
│  │  │   - Other screens       │ │ │
│  │  └─────────────────────────┘ │ │
│  │                               │ │
│  │  When disconnected:           │ │
│  │  ┌─────────────────────────┐ │ │
│  │  │   Stack                 │ │ │
│  │  │   ├─ App (background)   │ │ │  ← App stays in memory
│  │  │   └─ NoInternetScreen   │ │ │  ← Overlay appears
│  │  └─────────────────────────┘ │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘
```

### How It Works

1. **Connectivity Wrapper** wraps the entire app using MaterialApp's `builder` parameter
2. **Stream-based Monitoring** continuously watches network status via `connectivity_plus`
3. **Stack Overlay** displays no-internet screen on top when disconnected
4. **Instant Response** - No navigation needed, overlay appears/disappears immediately
5. **State Preservation** - Underlying app remains in memory with preserved state

### Project Structure

```text
lib/
├── main.dart                           # App entry point with ConnectivityWrapper
├── core/
│   ├── constants/
│   │   └── app_colors.dart            # App-wide color definitions
│   ├── router/
│   │   ├── app_router.dart            # GoRouter configuration
│   │   └── app_routes.dart            # Route constants
│   └── utils/                          # Utility functions
├── presentation/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── provider/
│   │   │   │   └── signin_provider.dart
│   │   │   └── view/
│   │   │       └── signin_screen.dart
│   │   └── no_internet/
│   │       ├── providers/
│   │       │   └── connectivity_provider.dart  # Riverpod connectivity state
│   │       └── view/
│   │           └── no_internet_screen.dart     # Overlay screen
│   └── widgets/                        # Reusable widgets
│       ├── custom_button_widget.dart
│       ├── custom_scaffold.dart
│       └── custom_text_field.dart
├── repos/                              # Repository layer
└── services/
    └── connectivity_service.dart       # Connectivity monitoring service
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `>=3.9.0`
- Dart SDK: `>=3.9.0`

### Dependencies

```yaml
dependencies:
  flutter_riverpod: ^3.0.1 # State management
  go_router: ^16.2.4 # Declarative routing
  connectivity_plus: ^7.0.0 # Network connectivity monitoring
```

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd pcq_fir_pilot_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

## 🔑 Key Components

### 1. ConnectivityWrapper (`main.dart`)

The heart of the connectivity monitoring system:

```dart
class ConnectivityWrapper extends ConsumerWidget {
  final Widget? child;

  const ConnectivityWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    return connectivityStatus.when(
      data: (status) {
        if (status == ConnectivityStatus.disconnected) {
          return Stack(
            children: [
              if (child != null) child!,
              const Positioned.fill(child: NoInternetScreen()),
            ],
          );
        }
        return child ?? const SizedBox.shrink();
      },
      loading: () => /* Loading State */,
      error: (error, stackTrace) => /* Error State */,
    );
  }
}
```

### 2. ConnectivityService (`services/connectivity_service.dart`)

Monitors network status in real-time:

```dart
class ConnectivityService {
  Stream<ConnectivityStatus> get connectivityStream async* {
    // Check initial connectivity
    final initialResult = await _connectivity.checkConnectivity();
    yield _mapConnectivityResult(initialResult);

    // Listen to connectivity changes
    await for (final result in _connectivity.onConnectivityChanged) {
      yield _mapConnectivityResult(result);
    }
  }
}
```

### 3. Connectivity Provider (`providers/connectivity_provider.dart`)

Riverpod provider for state management:

```dart
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectivityStream;
});
```

## 🎯 Benefits of This Architecture

| Benefit                   | Description                                                |
| ------------------------- | ---------------------------------------------------------- |
| ⚡ **Immediate Response** | No navigation delays, overlay appears/disappears instantly |
| 🎯 **State Preservation** | App doesn't lose its place during connectivity changes     |
| 🔄 **True Overlay**       | Modal-like behavior based on real-time connectivity        |
| 🌐 **Works Everywhere**   | Wraps entire router, so works on all screens               |
| 🧩 **Clean Separation**   | Router focuses on navigation, wrapper handles connectivity |
| 📱 **Native Feel**        | Seamless user experience with instant feedback             |

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 📦 Build

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Connectivity Plus Documentation](https://pub.dev/packages/connectivity_plus)

## 📧 Contact

For questions or support, please open an issue in the repository.

---

Made with ❤️ using Flutter
