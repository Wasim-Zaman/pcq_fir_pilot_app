import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pcq_fir_pilot_app/core/network/api_client.dart';

// ==================== Member Repository ====================
class MemberRepo {
  final ApiClient _apiClient;

  MemberRepo(this._apiClient);

  // Login method
  Future<ApiState<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    final loginData = {"email": email, "password": password};

    return _apiClient.post<Map<String, dynamic>>(
      '/members/login',
      data: loginData,
      parser: (data) => data as Map<String, dynamic>,
    );
  }
}

// ==================== Member Repository Provider ====================
final memberRepoProvider = Provider<MemberRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MemberRepo(apiClient);
});
