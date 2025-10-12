import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';
import 'package:pcq_fir_pilot_app/presentation/features/dashboard/models/dashboard_analytics.dart';
import 'package:pcq_fir_pilot_app/presentation/features/gatepass/models/item_model.dart';

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

  // Get item verification details
  Future<ApiState<ItemVerificationResponse>> getItemVerification({
    required String itemCode,
    required String gatePassId,
  }) async {
    return _apiClient.get<ItemVerificationResponse>(
      '/gate-passes/gatepassitems/items',
      queryParameters: {'itemCode': itemCode, 'gatePassId': gatePassId},
      parser: (data) =>
          ItemVerificationResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  // Verify item
  Future<ApiState<VerifyItemResponse>> verifyItem({
    required String gatePassId,
    required String itemId,
    required String scannedById,
    required String verificationStatus,
    required int verifiedQuantity,
    required String verificationRemarks,
  }) async {
    final verifyData = {
      "scannedById": scannedById,
      "verificationStatus": verificationStatus,
      "verifiedQuantity": verifiedQuantity,
      "verificationRemarks": verificationRemarks,
    };

    return _apiClient.post<VerifyItemResponse>(
      '/gate-passes/$gatePassId/items/$itemId/verify',
      data: verifyData,
      parser: (data) =>
          VerifyItemResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}

// ==================== Gatepass Repository Provider ====================
final gatepassRepoProvider = Provider<GatepassRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GatepassRepo(apiClient);
});
