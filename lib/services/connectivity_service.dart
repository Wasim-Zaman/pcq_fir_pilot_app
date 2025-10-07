import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pcq_fir_pilot_app/presentation/features/no_internet/providers/connectivity_provider.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityStatus> get connectivityStream async* {
    // Check initial connectivity with internet reachability
    final initialResult = await _connectivity.checkConnectivity();
    final initialStatus = await _checkConnectivityWithInternet(initialResult);
    yield initialStatus;

    // Listen to connectivity changes
    await for (final result in _connectivity.onConnectivityChanged) {
      // When connectivity changes, verify actual internet connectivity
      final status = await _checkConnectivityWithInternet(result);
      if (kDebugMode) {
        print('🌐 Connectivity changed: $result -> $status');
      }
      yield status;
    }
  }

  /// Check if device has actual internet connectivity, not just network connection
  Future<ConnectivityStatus> _checkConnectivityWithInternet(
    List<ConnectivityResult> results,
  ) async {
    // First check if we have any network connection
    final hasNetworkConnection = _hasNetworkConnection(results);

    if (!hasNetworkConnection) {
      return ConnectivityStatus.disconnected;
    }

    // If we have network connection, verify actual internet access
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('✅ Internet connection verified');
        }
        return ConnectivityStatus.connected;
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print('❌ No internet access (Socket Exception)');
      }
      return ConnectivityStatus.disconnected;
    } on TimeoutException catch (_) {
      if (kDebugMode) {
        print('❌ No internet access (Timeout)');
      }
      return ConnectivityStatus.disconnected;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking internet: $e');
      }
      return ConnectivityStatus.disconnected;
    }

    return ConnectivityStatus.disconnected;
  }

  /// Check if device has network connection (WiFi, Mobile, or Ethernet)
  bool _hasNetworkConnection(List<ConnectivityResult> results) {
    for (final result in results) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet) {
        return true;
      }
    }
    return false;
  }
}
