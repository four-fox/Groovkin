import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import '../payment_models.dart';
import '../payment_repository.dart';
import 'wallet_models.dart';

class WalletController extends GetxController with WidgetsBindingObserver {
  WalletController({PaymentRepository? repository})
      : repository = repository ?? PaymentRepository();

  final PaymentRepository repository;

  WalletSummary? summary;
  WalletPayoutsResponse? payouts;
  List<WalletTransaction> transactions = [];
  WalletTransactionDetail? selectedDetail;
  WalletTransactionFilters filters = WalletTransactionFilters();

  PaymentWorkflowState state = PaymentWorkflowState.initial;
  PaymentWorkflowState listState = PaymentWorkflowState.initial;
  String? errorMessage;
  String? errorCode;

  int _page = 1;
  bool hasMore = true;
  bool loadingMore = false;

  String get screenTitle {
    final role = summary?.role;
    if (role == WalletRole.eventOwner) return 'Earnings & Payouts';
    if (role == WalletRole.venueManager) return 'Payments & Refunds';
    final stored = API().sp.read('role')?.toString();
    if (stored == 'eventOrganizer') return 'Earnings & Payouts';
    if (stored == 'eventManager') return 'Payments & Refunds';
    return 'Wallet';
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    refreshAll();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      refreshAll(silent: true);
    }
  }

  Future<void> refreshAll({bool silent = false}) async {
    await Future.wait([
      refreshSummary(silent: silent),
      refreshTransactions(reset: true, silent: silent),
      refreshPayouts(silent: silent),
    ]);
  }

  Future<void> refreshSummary({bool silent = false}) async {
    try {
      if (!silent) {
        state = PaymentWorkflowState.loading;
        update();
      }
      summary = await repository.getWalletSummary();
      state = PaymentWorkflowState.ready;
      errorMessage = null;
      errorCode = null;
    } on PaymentApiException catch (error) {
      errorCode = error.code;
      errorMessage = _messageForError(error);
      state = PaymentWorkflowState.retryableFailure;
      if (!silent) BotToast.showText(text: errorMessage!);
    } catch (_) {
      errorMessage = 'Unable to connect. Check your internet and try again.';
      state = PaymentWorkflowState.networkError;
      if (!silent) BotToast.showText(text: errorMessage!);
    }
    update();
  }

  Future<void> refreshPayouts({bool silent = false}) async {
    try {
      payouts = await repository.getWalletPayouts();
    } on PaymentApiException catch (error) {
      if (error.code == 'payout_tracking_unavailable') {
        payouts = WalletPayoutsResponse(
          actualBankPayoutTrackingEnabled: false,
          message:
              'Groovkin has transferred these proceeds to your Stripe account. Bank payout timing is managed by Stripe.',
        );
      } else if (!silent) {
        // Non-blocking for wallet home.
        BotToast.showText(text: _messageForError(error));
      }
    } catch (_) {
      // Non-blocking.
    }
    update();
  }

  Future<void> refreshTransactions({
    bool reset = false,
    bool silent = false,
  }) async {
    if (loadingMore) return;
    try {
      if (reset) {
        _page = 1;
        hasMore = true;
        if (!silent) listState = PaymentWorkflowState.loading;
        update();
      } else {
        if (!hasMore) return;
        loadingMore = true;
        update();
      }

      final page = await repository.getWalletTransactions(
        page: _page,
        filters: filters,
      );
      if (reset) {
        transactions = page.items;
      } else {
        transactions = [...transactions, ...page.items];
      }
      hasMore = page.hasMore;
      _page = page.currentPage + 1;
      listState = transactions.isEmpty
          ? PaymentWorkflowState.empty
          : PaymentWorkflowState.ready;
    } on PaymentApiException catch (error) {
      errorCode = error.code;
      errorMessage = _messageForError(error);
      listState = PaymentWorkflowState.retryableFailure;
      if (!silent) BotToast.showText(text: errorMessage!);
    } catch (_) {
      errorMessage = 'Unable to connect. Check your internet and try again.';
      listState = PaymentWorkflowState.networkError;
      if (!silent) BotToast.showText(text: errorMessage!);
    } finally {
      loadingMore = false;
      update();
    }
  }

  Future<void> loadMore() => refreshTransactions(reset: false);

  Future<void> applyFilters(WalletTransactionFilters next) async {
    filters = next;
    await refreshTransactions(reset: true);
  }

  Future<void> loadTransactionDetail(String id) async {
    try {
      state = PaymentWorkflowState.loading;
      update();
      selectedDetail = await repository.getWalletTransaction(id);
      state = PaymentWorkflowState.ready;
    } on PaymentApiException catch (error) {
      errorCode = error.code;
      errorMessage = _messageForError(error);
      state = PaymentWorkflowState.retryableFailure;
      BotToast.showText(text: errorMessage!);
    } catch (_) {
      errorMessage = 'Unable to connect. Check your internet and try again.';
      state = PaymentWorkflowState.networkError;
      BotToast.showText(text: errorMessage!);
    }
    update();
  }

  String _messageForError(PaymentApiException error) {
    switch (error.code) {
      case 'unauthorized_wallet_access':
        return 'You are not authorized to view wallet information.';
      case 'transaction_not_found':
        return 'This transaction could not be found.';
      case 'payout_tracking_unavailable':
        return 'Bank payout tracking is not available. Transfers to Stripe are shown instead.';
      default:
        if (error.httpStatus == 401) return 'Please log in again.';
        if (error.httpStatus == 0) {
          return 'Unable to connect. Check your internet and try again.';
        }
        return error.message;
    }
  }
}

WalletController walletController() {
  if (Get.isRegistered<WalletController>()) {
    return Get.find<WalletController>();
  }
  return Get.put(WalletController());
}
