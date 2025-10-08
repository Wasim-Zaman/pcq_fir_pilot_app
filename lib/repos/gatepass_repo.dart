import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';

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
}

// ==================== Gatepass Repository Provider ====================
final gatepassRepoProvider = Provider<GatepassRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GatepassRepo(apiClient);
});
