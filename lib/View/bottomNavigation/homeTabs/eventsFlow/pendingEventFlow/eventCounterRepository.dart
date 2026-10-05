import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/backend_error.dart';
import 'package:groovkin/model/event_counter_model.dart';
import 'package:groovkin/utils/backend_contract.dart';
import 'package:groovkin/utils/json_parsers.dart';
import 'package:groovkin/utils/money.dart';

class EventCounterRepository {
  EventCounterRepository({API? api}) : _api = api ?? API();

  final API _api;

  Future<EventCounterState> fetchCounters(int eventId) async {
    final response = await _api.getApi(
      url: EventCounterEndpoints.list(eventId),
      isLoader: false,
    );
    if (!isBackendSuccess(response)) {
      throw EventCounterException(backendErrorMessage(response));
    }
    final body = parseMap(response.data) ?? {};
    return EventCounterState.fromJson(body['data'] ?? body);
  }

  Future<void> createCounter({
    required int eventId,
    required int proposedPrincipalMinor,
    String? message,
  }) async {
    final body = <String, dynamic>{
      'proposed_principal_minor': proposedPrincipalMinor,
      if (message != null && message.trim().isNotEmpty) 'message': message.trim(),
    };
    final response = await _api.jsonPostApi(
      EventCounterEndpoints.create(eventId),
      body: body,
    );
    _throwIfFailed(response);
  }

  Future<void> acceptCounter(int counterId) async {
    final response =
        await _api.jsonPostApi(EventCounterEndpoints.accept(counterId));
    _throwIfFailed(response);
  }

  Future<void> rejectCounter(int counterId) async {
    final response =
        await _api.jsonPostApi(EventCounterEndpoints.reject(counterId));
    _throwIfFailed(response);
  }

  Future<void> counterAgain({
    required int counterId,
    required int proposedPrincipalMinor,
    String? message,
  }) async {
    final body = <String, dynamic>{
      'proposed_principal_minor': proposedPrincipalMinor,
      if (message != null && message.trim().isNotEmpty) 'message': message.trim(),
    };
    final response = await _api.jsonPostApi(
      EventCounterEndpoints.counterAgain(counterId),
      body: body,
    );
    _throwIfFailed(response);
  }

  Future<void> approveFinalPayment(int eventId) async {
    final response = await _api.jsonPostApi(
      EventCounterEndpoints.approveCompletion(eventId),
    );
    _throwIfFailed(response);
  }

  void _throwIfFailed(dynamic response) {
    if (isBackendSuccess(response)) return;
    throw EventCounterException(
      backendErrorMessage(response),
      errorCode: backendErrorCode(response),
    );
  }
}

class EventCounterException implements Exception {
  EventCounterException(this.message, {this.errorCode});

  final String message;
  final String? errorCode;

  @override
  String toString() => message;
}
