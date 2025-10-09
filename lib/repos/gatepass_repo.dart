import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_analytics.dart';

// ==================== Gatepass Repository ====================
class GatepassRepo {
  final ApiClient _apiClient;

  GatepassRepo(this._apiClient);

  // Scan pass method
  Future<ApiState<Map<String, dynamic>>> scanPass({
    required String passNumber,
  }) async {
    final scanData = {"passNumber": passNumber};

    return _apiClient.post<Map<String, dynamic>>(
      '/gate-passes/scan/pass-number',
      data: scanData,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // Get dashboard analytics method
  Future<ApiState<DashboardAnalytics>> getDashboardAnalytics() async {
    return _apiClient.get<DashboardAnalytics>(
      '/gate-passes/analytics/dashboard',
      parser: (data) {
        final responseData = data as Map<String, dynamic>;
        final analyticsData = responseData['data'] as Map<String, dynamic>;
        return DashboardAnalytics.fromJson(analyticsData);
      },
    );
  }

  // ==================== Scan APIs ====================

  // Check-Out scan
  Future<ApiState<Map<String, dynamic>>> scanCheckOut({
    required String gatePassId,
    required String scannedById,
    String? notes,
  }) async {
    final scanData = {
      "scannedById": scannedById,
      if (notes != null) "notes": notes,
    };

    return _apiClient.post<Map<String, dynamic>>(
      '/gate-passes/$gatePassId/scan/check-out',
      data: scanData,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // Check-In scan
  Future<ApiState<Map<String, dynamic>>> scanCheckIn({
    required String gatePassId,
    required String scannedById,
    String? notes,
  }) async {
    final scanData = {
      "scannedById": scannedById,
      if (notes != null) "notes": notes,
    };

    return _apiClient.post<Map<String, dynamic>>(
      '/gate-passes/$gatePassId/scan/check-in',
      data: scanData,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // Return-Out scan
  Future<ApiState<Map<String, dynamic>>> scanReturnOut({
    required String gatePassId,
    required String scannedById,
    String? notes,
  }) async {
    final scanData = {
      "scannedById": scannedById,
      if (notes != null) "notes": notes,
    };

    return _apiClient.post<Map<String, dynamic>>(
      '/gate-passes/$gatePassId/scan/return-out',
      data: scanData,
      parser: (data) => data as Map<String, dynamic>,
    );
  }

  // Return-In scan
  Future<ApiState<Map<String, dynamic>>> scanReturnIn({
    required String gatePassId,
    required String scannedById,
    String? notes,
  }) async {
    final scanData = {
      "scannedById": scannedById,
      if (notes != null) "notes": notes,
    };

    return _apiClient.post<Map<String, dynamic>>(
      '/gate-passes/$gatePassId/scan/return-in',
      data: scanData,
      parser: (data) => data as Map<String, dynamic>,
    );
  }
}

// ==================== Gatepass Repository Provider ====================
final gatepassRepoProvider = Provider<GatepassRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GatepassRepo(apiClient);
});
