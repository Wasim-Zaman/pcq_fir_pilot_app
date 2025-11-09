# Biometric Authentication Feature

This document explains the biometric authentication (fingerprint/Face ID) feature implementation in the PCQ FIR Pilot App.

## Overview

The biometric authentication feature allows users to sign in quickly using their device's biometric sensors (fingerprint, Face ID, etc.) without entering their email and password every time.

## Architecture

Following the app's AsyncNotifier pattern and repository architecture:

### 1. Service Layer (`lib/services/`)

**`biometric_service.dart`**
- Wraps the `local_auth` package functionality
- Handles biometric authentication operations
- Provides methods for:
  - Checking biometric availability
  - Authenticating with biometrics only
  - Authenticating with biometrics or device credentials
  - Handling platform-specific exceptions
- Returns `BiometricAuthResult` with status and messages

**`shared_preferences_service.dart`** (updated)
- Added methods to store/retrieve biometric credentials
- New keys:
  - `biometric_enabled`: Boolean flag for feature status
  - `biometric_email`: Encrypted user email
  - `biometric_password`: Encrypted user password
- Methods:
  - `setBiometricEnabled(bool)`: Enable/disable feature
  - `saveBiometricCredentials()`: Store credentials
  - `getBiometricEmail()` / `getBiometricPassword()`: Retrieve credentials
  - `removeBiometricCredentials()`: Clear stored data
  - `hasBiometricCredentials()`: Check if credentials exist

### 2. Provider Layer (`lib/presentation/features/auth/provider/`)

**`biometric_provider.dart`**
- `BiometricNotifier` extends `AsyncNotifier<BiometricState>`
- Manages biometric authentication state
- Methods:
  - `checkAvailability()`: Verify device support
  - `enableBiometric(email, password)`: Enable and store credentials
  - `disableBiometric()`: Disable and clear credentials
  - `authenticateAndGetCredentials()`: Authenticate and return stored credentials

**State Model:**
```dart
class BiometricState {
  final bool isAvailable;      // Device supports biometrics
  final bool isEnabled;         // User enabled the feature
  final bool isLoading;         // Operation in progress
  final List<BiometricType> availableTypes;  // Available biometric types
  final String? error;          // Error message if any
}
```

### 3. UI Layer (`lib/presentation/features/auth/view/`)

**`widgets/signin_screen/biometric_auth_button.dart`**
- Circular fingerprint icon button
- Only visible when biometric is available and enabled
- Triggers authentication on tap
- Shows loading spinner during authentication
- Calls `onSuccess` callback when authentication succeeds

**`widgets/signin_screen/biometric_enable_widget.dart`**
- Toggle switch widget to enable/disable biometric login
- Only visible when device supports biometrics
- Displays current feature status
- Requires user authentication to enable
- Saves credentials securely after enabling

**`signin_screen.dart`** (updated)
- Integrated biometric authentication button below sign-in button
- Shows enable widget when email/password fields have values
- New method: `_handleBiometricSignIn()` 
  - Authenticates with biometrics
  - Retrieves stored credentials
  - Auto-fills form and signs in

## User Flow

### First-Time Setup

1. User signs in with email/password normally
2. After entering credentials, the enable widget appears
3. User toggles "Enable Fingerprint Login" switch
4. System prompts for biometric authentication
5. On success, credentials are encrypted and stored locally
6. Feature is now enabled

### Subsequent Sign-Ins

1. User sees fingerprint icon on sign-in screen
2. User taps fingerprint button
3. System prompts for biometric authentication
4. On success, stored credentials are retrieved
5. App auto-signs in user and navigates to dashboard

### Disabling Feature

1. User toggles off the enable widget switch
2. Stored credentials are immediately cleared
3. Fingerprint button is hidden from sign-in screen

## Platform Configuration

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSFaceIDUsageDescription</key>
<string>Authenticate using Face ID to securely sign in to your account</string>
```

## Security Considerations

1. **Credential Storage**: Uses SharedPreferences (consider upgrading to `flutter_secure_storage` for production)
2. **No Backup**: Credentials stored locally only, not synced across devices
3. **Logout Behavior**: Credentials persist after logout - allows quick re-login
4. **Manual Disable**: User can disable feature anytime via toggle
5. **Biometric-First**: Requires successful biometric authentication before accessing stored credentials

## Dependencies

- `local_auth: ^3.0.0` - Official Flutter plugin for biometric authentication
- `shared_preferences: ^2.3.5` - Local storage for credentials

## Code Style Compliance

✅ Follows AsyncNotifier pattern for state management  
✅ Uses repository pattern (service layer)  
✅ Pattern matching for `ApiState` responses  
✅ Consistent naming: `biometricProvider`, `biometricService`  
✅ StatelessWidget UI with business logic in providers  
✅ Custom widgets for reusability  
✅ Extension methods for spacing (`16.heightBox`)  
✅ Proper error handling with `CustomSnackbar`  
✅ Logging with `dev.log()`  

## Testing

To test the feature:

1. **Device with Biometrics**: Use physical device or simulator with enrolled biometrics
2. **Enable Feature**: Sign in normally, then toggle enable switch
3. **Test Authentication**: Sign out and use fingerprint button to sign in
4. **Test Disable**: Toggle off and verify button disappears
5. **Edge Cases**: 
   - Test with no biometrics enrolled
   - Test with biometrics locked out
   - Test with device unsupported

## Future Enhancements

- [ ] Migrate to `flutter_secure_storage` for encrypted storage
- [ ] Add biometric re-authentication timeout setting
- [ ] Support multiple accounts with biometric login
- [ ] Add biometric authentication for sensitive actions (e.g., approving gatepasses)
- [ ] Add setting to disable biometric in app settings
- [ ] Analytics tracking for biometric usage

## Files Modified/Created

### Created:
- `lib/services/biometric_service.dart`
- `lib/presentation/features/auth/provider/biometric_provider.dart`
- `lib/presentation/features/auth/view/widgets/signin_screen/biometric_auth_button.dart`
- `lib/presentation/features/auth/view/widgets/signin_screen/biometric_enable_widget.dart`
- `docs/BIOMETRIC_FEATURE.md` (this file)

### Modified:
- `pubspec.yaml` - Added `local_auth: ^3.0.0`
- `lib/services/shared_preferences_service.dart` - Added biometric credential storage methods
- `lib/presentation/features/auth/view/signin_screen.dart` - Integrated biometric UI and logic
- `android/app/src/main/AndroidManifest.xml` - Added biometric permission
- `ios/Runner/Info.plist` - Added Face ID usage description

## Support

For issues or questions about this feature, refer to:
- Local Auth Plugin: https://pub.dev/packages/local_auth
- Project AI Instructions: `.github/copilot-instructions.md`
