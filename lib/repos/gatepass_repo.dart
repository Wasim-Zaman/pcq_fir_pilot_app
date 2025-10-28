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

  // ==================== Gatepass Verification APIs ====================

  // Verify Gatepass based on action type selected
  Future<ApiState<Map<String, dynamic>>> verifyGatepass({
    required String gatePassId,
    required String actionType,
    required String scannedById,
    String? notes,
  }) async {
    final scanData = {
      "scanType": actionType,
      "scannedById": scannedById,
      if (notes != null) "notes": notes,
    };

    return _apiClient.post<Map<String, dynamic>>(
      '/gate-passes/$gatePassId/scan',
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
    required String scanType,
  }) async {
    final verifyData = {
      "scanType": scanType,
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

  Future<ApiState<Map<String, dynamic>>> checkInOrOut({
    required String gatePassId,
    required String scannedById,
    required String notes,
  }) async {
    return _apiClient.post<Map<String, dynamic>>(
      '/gate-passes/$gatePassId/security-scan',
      data: {"notes": notes, "scannedById": scannedById},
      parser: (data) => data as Map<String, dynamic>,
    );
  }
}

// ==================== Gatepass Repository Provider ====================
final gatepassRepoProvider = Provider<GatepassRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GatepassRepo(apiClient);
});
