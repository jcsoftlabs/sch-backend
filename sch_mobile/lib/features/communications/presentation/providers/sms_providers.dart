import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../data/repositories/sms_repository.dart';
import '../data/models/sms_request_model.dart';

final smsRepositoryProvider = Provider<SmsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SmsRepository(apiClient);
});

final sendSmsProvider =
    StateNotifierProvider<SendSmsNotifier, AsyncValue<void>>((ref) {
  return SendSmsNotifier(ref.watch(smsRepositoryProvider));
});

class SendSmsNotifier extends StateNotifier<AsyncValue<void>> {
  final SmsRepository _repository;

  SendSmsNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> sendSms(SmsRequestModel request) async {
    state = const AsyncValue.loading();
    try {
      await _repository.sendSms(request);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}
