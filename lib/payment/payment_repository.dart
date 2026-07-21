import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'journey/payment_journey_models.dart';
import 'payment_models.dart';
import 'wallet/wallet_models.dart';

class PaymentRepository {
  final _storage = GetStorage();

  Future<PaymentJourney> getPaymentJourney(int eventId) async {
    final response = await API().getApi(
      url: 'events/$eventId/payment-journey',
      isLoader: false,
    );
    return PaymentJourney.fromJson(_unwrap(response));
  }

  Future<WalletSummary> getWalletSummary() async {
    final response = await API().getApi(
      url: 'wallet/summary',
      isLoader: false,
    );
    return WalletSummary.fromJson(_unwrap(response));
  }

  Future<WalletTransactionPage> getWalletTransactions({
    required int page,
    int perPage = 20,
    WalletTransactionFilters? filters,
  }) async {
    final response = await API().getApi(
      url: 'wallet/transactions',
      isLoader: false,
      queryParameters: (filters ?? WalletTransactionFilters()).toQuery(
        page: page,
        perPage: perPage,
      ),
    );
    // Paginated Laravel responses may put the page envelope in `data`
    // or return the list directly under `data`.
    final raw = _unwrapRaw(response);
    return WalletTransactionPage.fromJson(raw);
  }

  Future<WalletTransactionDetail> getWalletTransaction(String id) async {
    final encoded = Uri.encodeComponent(id);
    final response = await API().getApi(
      url: 'wallet/transactions/$encoded',
      isLoader: false,
    );
    return WalletTransactionDetail.fromJson(_unwrap(response));
  }

  Future<WalletPayoutsResponse> getWalletPayouts() async {
    final response = await API().getApi(
      url: 'wallet/payouts',
      isLoader: false,
    );
    return WalletPayoutsResponse.fromJson(_unwrap(response));
  }

  Future<StripeOnboardingLink> createConnectOnboardingLink() async {
    final response = await API().jsonPostApi('stripe/connect/onboarding-link');
    final data = _unwrap(response);
    return StripeOnboardingLink.fromJson(data);
  }

  Future<StripeConnectStatus> getConnectStatus() async {
    final response = await API().getApi(
      url: 'stripe/connect/status',
      isLoader: false,
    );
    final data = _unwrap(response);
    return StripeConnectStatus.fromJson(data);
  }

  Future<SetupIntentResponse> createSetupIntent() async {
    final response = await API().jsonPostApi('payment-methods/setup-intent');
    return SetupIntentResponse.fromJson(_unwrap(response));
  }

  Future<List<PaymentMethodCard>> getPaymentMethods() async {
    final response = await API().getApi(
      url: 'payment-methods',
      isLoader: false,
    );
    final rawData = _unwrapRaw(response);
    final data = rawData is List ? rawData : const [];
    return data
        .whereType<Map>()
        .map((card) =>
            PaymentMethodCard.fromJson(Map<String, dynamic>.from(card)))
        .toList();
  }

  Future<void> setDefaultPaymentMethod(String paymentMethodId) async {
    final response = await API().jsonPostApi(
      'payment-methods/default',
      body: {'payment_method_id': paymentMethodId},
    );
    _unwrapRaw(response);
  }

  Future<void> deletePaymentMethod(int cardId) async {
    final response = await API().jsonDeleteApi('payment-methods/$cardId');
    _unwrapRaw(response);
  }

  Future<PaymentSummary> getPaymentSummary(int eventId) async {
    final response = await API().getApi(
      url: 'events/$eventId/payment-summary',
      isLoader: false,
    );
    return PaymentSummary.fromJson(_unwrap(response));
  }

  Future<EventAcceptanceResult> acceptEvent(
    int eventId, {
    String? paymentMethodId,
    String? idempotencyKey,
  }) async {
    final response = await API().jsonPostApi(
      'events/$eventId/accept',
      body: {
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      },
      headers: {
        if (idempotencyKey != null) 'Idempotency-Key': idempotencyKey,
      },
    );
    return EventAcceptanceResult.fromJson(_unwrap(response));
  }

  Future<PaymentRecord> getPayment(int paymentId) async {
    final response = await API().getApi(
      url: 'payments/$paymentId',
      isLoader: false,
    );
    return PaymentRecord.fromJson(_unwrap(response));
  }

  Future<ResumeAuthenticationResult> resumeAuthentication(int paymentId) async {
    final response = await API().jsonPostApi(
      'payments/$paymentId/resume-authentication',
    );
    return ResumeAuthenticationResult.fromJson(_unwrap(response));
  }

  Future<PaymentRecord> retryPayment(
      int paymentId, String idempotencyKey) async {
    final response = await API().jsonPostApi(
      'payments/$paymentId/retry',
      headers: {'Idempotency-Key': idempotencyKey},
    );
    return PaymentRecord.fromJson(_unwrap(response));
  }

  Future<void> submitCompletion(int eventId) async {
    final response = await API().jsonPostApi('events/$eventId/completion');
    _unwrapRaw(response);
  }

  Future<void> approveCompletion(int eventId) async {
    final response =
        await API().jsonPostApi('events/$eventId/completion/approve');
    _unwrapRaw(response);
  }

  Future<CompletionStatusResponse> getCompletionStatus(int eventId) async {
    final response = await API().getApi(
      url: 'events/$eventId/completion/status',
      isLoader: false,
    );
    return CompletionStatusResponse.fromJson(_unwrap(response));
  }

  Future<List<dynamic>> getCompletionHistory(int eventId) async {
    final response = await API().getApi(
      url: 'events/$eventId/completion/history',
      isLoader: false,
    );
    final raw = _unwrapRaw(response);
    return raw is List ? raw : [raw];
  }

  Future<void> escalateCompletion(int eventId) async {
    final response =
        await API().jsonPostApi('events/$eventId/completion/escalate');
    _unwrapRaw(response);
  }

  Future<CompletionCounter> createCounter(
    int eventId, {
    required int proposedPrincipalMinor,
    required String message,
  }) async {
    final response = await API().jsonPostApi(
      'events/$eventId/completion/counters',
      body: {
        'proposed_principal_minor': proposedPrincipalMinor,
        'message': message,
      },
    );
    return CompletionCounter.fromJson(_unwrap(response));
  }

  Future<CompletionCounter> reviseCounter(
    int counterId, {
    required int proposedPrincipalMinor,
    required String message,
  }) async {
    final response = await API().jsonPostApi(
      'completion-counters/$counterId/revise',
      body: {
        'proposed_principal_minor': proposedPrincipalMinor,
        'message': message,
      },
    );
    return CompletionCounter.fromJson(_unwrap(response));
  }

  Future<void> acceptCounter(int counterId) async {
    final response =
        await API().jsonPostApi('completion-counters/$counterId/accept');
    _unwrapRaw(response);
  }

  Future<void> rejectCounter(int counterId) async {
    final response =
        await API().jsonPostApi('completion-counters/$counterId/reject');
    _unwrapRaw(response);
  }

  Future<CancellationPolicy> getCancellationPolicy(int eventId) async {
    final response = await API().getApi(
      url: 'events/$eventId/cancellation-policy',
      isLoader: false,
    );
    return CancellationPolicy.fromJson(_unwrap(response));
  }

  Future<CancellationQuote> createCancellationQuote(
    int eventId, {
    required String reasonType,
    required String reasonMessage,
    required bool forceMajeure,
  }) async {
    final response = await API().jsonPostApi(
      'events/$eventId/cancellations/quote',
      body: {
        'reason_type': reasonType,
        'reason_message': reasonMessage,
        'force_majeure': forceMajeure,
      },
    );
    return CancellationQuote.fromJson(_unwrap(response));
  }

  Future<CancellationDetail> confirmCancellation(
    int cancellationId,
    String idempotencyKey,
  ) async {
    final response = await API().jsonPostApi(
      'cancellations/$cancellationId/confirm',
      headers: {'Idempotency-Key': idempotencyKey},
    );
    return CancellationDetail.fromJson(_unwrap(response));
  }

  Future<CancellationDetail?> getCurrentCancellation(int eventId) async {
    final response = await API().getApi(
      url: 'events/$eventId/cancellations/current',
      isLoader: false,
    );
    if (response.statusCode == 404) return null;
    return CancellationDetail.fromJson(_unwrap(response));
  }

  Future<CancellationDetail> getCancellation(int cancellationId) async {
    final response = await API().getApi(
      url: 'cancellations/$cancellationId',
      isLoader: false,
    );
    return CancellationDetail.fromJson(_unwrap(response));
  }

  Future<List<dynamic>> getCancellationHistory(int cancellationId) async {
    final response = await API().getApi(
      url: 'cancellations/$cancellationId/history',
      isLoader: false,
    );
    final raw = _unwrapRaw(response);
    return raw is List ? raw : [raw];
  }

  Future<ResumeAuthenticationResult> resumeCancellationPayment(
    int cancellationId,
  ) async {
    final response = await API().jsonPostApi(
      'cancellations/$cancellationId/resume-payment',
    );
    return ResumeAuthenticationResult.fromJson(_unwrap(response));
  }

  Future<CancellationDetail> retryCancellationPayment(
    int cancellationId,
    String idempotencyKey,
  ) async {
    final response = await API().jsonPostApi(
      'cancellations/$cancellationId/retry-payment',
      headers: {'Idempotency-Key': idempotencyKey},
    );
    return CancellationDetail.fromJson(_unwrap(response));
  }

  Future<CancellationDetail> respondForceMajeure(
    int cancellationId, {
    required String responseValue,
    required String message,
  }) async {
    final response = await API().jsonPostApi(
      'cancellations/$cancellationId/force-majeure/respond',
      body: {
        'response': responseValue,
        'message': message,
      },
    );
    return CancellationDetail.fromJson(_unwrap(response));
  }

  String idempotencyKey(String workflow, int id) {
    final key = 'payment_idempotency_${workflow}_$id';
    final existing = _storage.read<String>(key);
    if (existing != null) return existing;
    final value = '$workflow-$id-${DateTime.now().microsecondsSinceEpoch}';
    _storage.write(key, value);
    return value;
  }

  void clearIdempotencyKey(String workflow, int id) {
    _storage.remove('payment_idempotency_${workflow}_$id');
  }

  Map<String, dynamic> _unwrap(Response response) {
    final raw = _unwrapRaw(response);
    return raw is Map<String, dynamic>
        ? raw
        : raw is Map
            ? Map<String, dynamic>.from(raw)
            : <String, dynamic>{};
  }

  dynamic _unwrapRaw(Response response) {
    if (response.statusCode == 200) {
      final data = response.data;
      if (data is Map && data['status'] == false) {
        throw PaymentApiException.fromResponse(response);
      }
      if (data is Map && data.containsKey('data')) return data['data'];
      return data;
    }
    throw PaymentApiException.fromResponse(response);
  }
}
