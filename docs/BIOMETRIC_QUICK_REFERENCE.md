# Biometric Authentication - Quick Reference

## 🚀 Quick Start

### For Users

1. **Enable Biometric Login**
   - Sign in with email/password
   - Toggle "Enable Fingerprint Login" switch
   - Authenticate with fingerprint/Face ID
   - Done! You can now use biometric to sign in

2. **Use Biometric Login**
   - Open app
   - Tap fingerprint icon button
   - Authenticate with fingerprint/Face ID
   - Automatically signed in

3. **Disable Biometric Login**
   - Sign in to your account
   - Toggle OFF "Enable Fingerprint Login"
   - Biometric login disabled

### For Developers

#### Check Biometric Availability
```dart
final biometricState = ref.watch(biometricProvider);
if (biometricState.value?.isAvailable ?? false) {
  // Biometric is available
}
```

#### Enable Biometric
```dart
final success = await ref.read(biometricProvider.notifier).enableBiometric(
  email: 'user@example.com',
  password: 'password123',
);
```

#### Authenticate and Get Credentials
```dart
final credentials = await ref
    .read(biometricProvider.notifier)
    .authenticateAndGetCredentials();

if (credentials != null) {
  print('Email: ${credentials.email}');
  // Use credentials for sign-in
}
```

#### Disable Biometric
```dart
await ref.read(biometricProvider.notifier).disableBiometric();
```

## 📋 API Reference

### BiometricService

```dart
// Check if biometric is available
Future<bool> isBiometricsAvailable()

// Get available biometric types
Future<List<BiometricType>> getAvailableBiometrics()

// Authenticate with biometrics only
Future<BiometricAuthResult> authenticateWithBiometrics({
  required String localizedReason,
})

// Authenticate with fallback to device credentials
Future<BiometricAuthResult> authenticateWithBiometricsOrCredentials({
  required String localizedReason,
})
```

### BiometricProvider

```dart
// Check biometric availability
Future<void> checkAvailability()

// Enable biometric authentication
Future<bool> enableBiometric({
  required String email,
  required String password,
})

// Disable biometric authentication
Future<void> disableBiometric()

// Authenticate and get stored credentials
Future<BiometricAuthCredentials?> authenticateAndGetCredentials()
```

### SharedPreferencesService (Biometric Methods)

```dart
// Enable/disable biometric
Future<bool> setBiometricEnabled(bool value)
bool isBiometricEnabled()

// Save/retrieve credentials
Future<bool> saveBiometricCredentials({required String email, required String password})
String? getBiometricEmail()
String? getBiometricPassword()

// Remove credentials
Future<bool> removeBiometricCredentials()

// Check if credentials exist
bool hasBiometricCredentials()
```

## 🎨 UI Components

### BiometricAuthButton
```dart
BiometricAuthButton(
  onSuccess: () {
    // Called when biometric authentication succeeds
  },
)
```

### BiometricEnableWidget
```dart
BiometricEnableWidget(
  email: 'user@example.com',
  password: 'password123',
)
```

## 🔐 Security Notes

- Credentials stored in SharedPreferences (consider flutter_secure_storage for production)
- Biometric authentication required before accessing credentials
- Credentials persist after logout (for quick re-login)
- User can disable feature anytime
- Local storage only (not synced across devices)

## 📱 Platform Support

| Platform | Support | Requirements |
|----------|---------|-------------|
| Android | ✅ Yes | Android 6.0+ with fingerprint sensor |
| iOS | ✅ Yes | iOS 11.0+ with Touch ID or Face ID |
| Web | ❌ No | Not supported by local_auth |
| macOS | ✅ Yes | macOS 10.12.2+ with Touch ID |
| Windows | ⚠️ Limited | Basic support only |
| Linux | ❌ No | Not supported |

## 🐛 Common Issues & Solutions

### Issue: Biometric button not showing
**Solution**: 
- Check device has biometric hardware
- Verify biometrics are enrolled in device settings
- Ensure feature is enabled via toggle switch

### Issue: Authentication fails
**Solution**:
- Check biometric permissions are granted
- Verify biometric is enrolled
- Check device isn't locked out from too many attempts

### Issue: Credentials not saved
**Solution**:
- Verify SharedPreferences is initialized in main.dart
- Ensure successful biometric authentication during enable

### Issue: Feature not available on emulator
**Solution**:
- **iOS**: Enable Face ID in Simulator → Features → Face ID
- **Android**: Set up fingerprint in emulator settings
- **Best**: Test on physical device

## 📊 State Flow

```
Initial State
↓
Check Availability (BiometricProvider.build)
↓
isAvailable = true/false
↓
User Enables → Authenticate → Save Credentials → isEnabled = true
↓
User Taps Button → Authenticate → Get Credentials → Auto Sign In
↓
User Disables → Clear Credentials → isEnabled = false
```

## 🧪 Testing Checklist

- [ ] Enable biometric on first login
- [ ] Use biometric button on subsequent login
- [ ] Disable biometric feature
- [ ] Test with no biometrics enrolled
- [ ] Test with biometrics locked out
- [ ] Test with device unsupported
- [ ] Test on physical device
- [ ] Test on iOS simulator
- [ ] Test on Android emulator

## 📚 Related Files

- Service: `lib/services/biometric_service.dart`
- Provider: `lib/presentation/features/auth/provider/biometric_provider.dart`
- UI Button: `lib/presentation/features/auth/view/widgets/signin_screen/biometric_auth_button.dart`
- UI Toggle: `lib/presentation/features/auth/view/widgets/signin_screen/biometric_enable_widget.dart`
- Documentation: `docs/BIOMETRIC_FEATURE.md`
- Examples: `lib/presentation/features/auth/examples/biometric_usage_examples.dart`

## 🔗 External Resources

- Local Auth Plugin: https://pub.dev/packages/local_auth
- Flutter Security Best Practices: https://flutter.dev/docs/development/data-and-backend/security
- Flutter Secure Storage: https://pub.dev/packages/flutter_secure_storage

---

**Quick Tip**: Always test biometric features on physical devices for the most accurate results!
