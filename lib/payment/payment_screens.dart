import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'event_acceptance_coordinator.dart';
import 'journey/completion_review_widgets.dart';
import 'journey/payment_journey_controller.dart';
import 'payment_controller.dart';
import 'payment_models.dart';
import 'payment_widgets.dart';
import 'stripe_connect_controller.dart';
import 'stripe_connect_models.dart';
import 'stripe_connect_widgets.dart';

PaymentController _paymentController() {
  if (Get.isRegistered<PaymentController>()) {
    return Get.find<PaymentController>();
  }
  return Get.put(PaymentController());
}

class ConnectOnboardingScreen extends StatefulWidget {
  const ConnectOnboardingScreen({super.key});

  @override
  State<ConnectOnboardingScreen> createState() =>
      _ConnectOnboardingScreenState();
}

class _ConnectOnboardingScreenState extends State<ConnectOnboardingScreen> {
  final StripeConnectController controller = stripeConnectController();
  final bool refreshAfterReturn = Get.arguments?['refreshAfterReturn'] == true;
  final bool linkExpired = Get.arguments?['linkExpired'] == true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (refreshAfterReturn) {
        await controller.handleDeepLinkReturn(linkExpired: linkExpired);
      } else {
        await controller.refreshConnectStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final role = controller.role;
    final isVenueManager = role == StripeConnectRole.venueManager;
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: StripeConnectCopy.screenTitle(role),
      ),
      body: GetBuilder<StripeConnectController>(
        builder: (controller) {
          if (controller.checkingVerificationAfterReturn) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: DynamicColor.yellowClr),
                  const SizedBox(height: 14),
                  Text(
                    'Checking Stripe setup...',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: controller.refreshConnectStatus,
            child: RefreshIndicator(
              onRefresh: controller.refreshConnectStatus,
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  if (controller.onboardingLinkExpired &&
                      !controller.isOnboardingComplete) ...[
                    _InfoNote(
                      icon: Icons.timer_off_outlined,
                      text:
                          'Your Stripe setup session expired. Start setup again to continue.',
                    ),
                    const SizedBox(height: 12),
                  ],
                  StripeConnectStatusCard(
                    status: controller.status,
                    role: role,
                    onPrimaryAction: controller.isOnboardingComplete
                        ? null
                        : controller.launchConnectOnboarding,
                    onRefresh: controller.refreshConnectStatus,
                  ),
                  const SizedBox(height: 12),
                  if (isVenueManager) ...[
                    CustomButton(
                      borderClr: Colors.transparent,
                      onTap: () async {
                        await _paymentController().addPaymentMethod();
                      },
                      text: 'Add Secure Card',
                    ),
                    const SizedBox(height: 8),
                    CustomButton(
                      borderClr: DynamicColor.yellowClr,
                      backgroundClr: false,
                      onTap: () =>
                          Get.toNamed(Routes.securePaymentMethodsScreen),
                      text: 'View Payment Methods',
                    ),
                    const SizedBox(height: 12),
                  ],
                  // _InfoNote(
                  //   icon: Icons.receipt_long_outlined,
                  //   text:
                  //       'Transaction history will appear here after payments are processed.',
                  // ),
                  // if (controller.status != null &&
                  //     !controller.isOnboardingComplete) ...[
                  //   const SizedBox(height: 12),
                  //   Text(
                  //     'Groovkin confirms setup only after Stripe verification finishes. Returning from the browser does not finish setup by itself.',
                  //     style: poppinsRegularStyle(
                  //       context: context,
                  //       fontSize: 12,
                  //       color: DynamicColor.grayClr,
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: GetBuilder<StripeConnectController>(
        builder: (controller) {
          if (controller.isOnboardingComplete) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CustomButton(
                borderClr: Colors.transparent,
                onTap: controller.launchConnectOnboarding,
                text: controller.hasRequirementsDue ||
                        controller.onboardingLinkExpired
                    ? 'Continue Stripe Setup'
                    : 'Complete Stripe Setup',
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DynamicColor.darkGrayClr,
      ),
      child: Row(
        children: [
          Icon(icon, color: DynamicColor.yellowClr, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: DynamicColor.whiteClr,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecurePaymentMethodScreen extends StatelessWidget {
  SecurePaymentMethodScreen({super.key});

  final PaymentController controller = _paymentController();

  /// Optional explanation shown when another flow (e.g. event acceptance)
  /// routed the user here to add a card first.
  final String? contextMessage = Get.arguments?['contextMessage']?.toString();

  Future<void> _addCard() async {
    final saved = await controller.addPaymentMethod();
    // If an acceptance flow is waiting on this screen, hand control back.
    if (saved && Get.arguments?['returnAfterAdd'] == true) {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Payment Methods'),
      body: GetBuilder<PaymentController>(
        initState: (_) => controller.refreshPaymentMethods(),
        builder: (controller) {
          final isEmpty = controller.state == PaymentWorkflowState.empty;
          return PaymentStateView(
            state: controller.state,
            message: isEmpty ? contextMessage : controller.errorMessage,
            onRetry: isEmpty ? _addCard : controller.refreshPaymentMethods,
            child: RefreshIndicator(
              onRefresh: controller.refreshPaymentMethods,
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  if (contextMessage != null) ...[
                    _InfoNote(
                      icon: Icons.credit_card_outlined,
                      text: contextMessage!,
                    ),
                    const SizedBox(height: 10),
                  ],
                  const StripeConnectBanner(),
                  const SizedBox(height: 8),
                  Text(
                    'Saved cards',
                    style: poppinsMediumStyle(
                      context: context,
                      fontSize: 20,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...controller.paymentMethods.map(
                    (card) => PaymentMethodCardTile(
                      card: card,
                      onSetDefault: () =>
                          controller.setDefaultPaymentMethod(card),
                      onDelete: () => _confirmDelete(context, controller, card),
                    ),
                  ),
                  if (controller.paymentMethods.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Text(
                        'No payment method added.\nAdd a secure card before accepting event requests. Your card details are handled securely by Stripe.',
                        textAlign: TextAlign.center,
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 14,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: _addCard,
            text: 'Add Secure Card',
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    PaymentController controller,
    PaymentMethodCard card,
  ) {
    Get.defaultDialog(
      title: 'Remove card?',
      middleText: 'Remove ${card.brand.toUpperCase()} ending in ${card.last4}?',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: DynamicColor.whiteClr,
      onConfirm: () {
        Get.back();
        controller.deletePaymentMethod(card);
      },
    );
  }
}

class EventAcceptPaymentScreen extends StatefulWidget {
  const EventAcceptPaymentScreen({super.key});

  @override
  State<EventAcceptPaymentScreen> createState() =>
      _EventAcceptPaymentScreenState();
}

class _EventAcceptPaymentScreenState extends State<EventAcceptPaymentScreen> {
  final int eventId = Get.arguments?['eventId'];
  final PaymentController paymentController = _paymentController();
  final StripeConnectController connectController = stripeConnectController();
  EventAcceptanceBlocker blocker = EventAcceptanceBlocker.none;
  bool accepting = false;

  // Whether the current failure came from an attempted accept/payment
  // submission (vs. readiness/summary loading). Drives whether "Retry"
  // resubmits the accept attempt or just reloads readiness data.
  bool _lastFailureFromAcceptAttempt = false;

  static const _acceptAttemptFailureBlockers = {
    EventAcceptanceBlocker.networkError,
    EventAcceptanceBlocker.unauthorized,
    EventAcceptanceBlocker.validationError,
    EventAcceptanceBlocker.retryableFailure,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadReadiness());
  }

  Future<void> _loadReadiness() async {
    await connectController.refreshConnectStatus(silent: true);
    await paymentController.loadPaymentSummary(eventId);
    await paymentController.refreshPaymentMethods();
    final readiness = await EventAcceptanceCoordinator.evaluateVmReadiness(
      vmStatus: connectController.status,
      paymentMethods: paymentController.paymentMethods,
    );
    setState(() {
      blocker = readiness;
      _lastFailureFromAcceptAttempt = false;
    });
  }

  Future<void> _acceptEvent() async {
    setState(() => accepting = true);
    final result = await EventAcceptanceCoordinator.acceptEventWithGuard(
      paymentController,
      connectController,
      eventId,
    );
    if (!mounted) return;
    setState(() {
      accepting = false;
      blocker = result;
      _lastFailureFromAcceptAttempt =
          _acceptAttemptFailureBlockers.contains(result);
    });

    if (result == EventAcceptanceBlocker.none &&
        (paymentController.state == PaymentWorkflowState.success ||
            paymentController.state == PaymentWorkflowState.processing)) {
      Get.back(result: true);
    }
  }

  Future<void> _handleGenericRetry() {
    // A failure from the accept/payment attempt itself must resubmit the
    // attempt (with a freshly-minted idempotency key) rather than just
    // reloading readiness, otherwise the user is stuck with no way to
    // actually retry the payment.
    return _lastFailureFromAcceptAttempt ? _acceptEvent() : _loadReadiness();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (blocker == EventAcceptanceBlocker.eoConnectIncomplete) {
      return Scaffold(
        appBar: customAppBar(theme: theme, text: 'Accept Event'),
        body: OrganizerConnectIncompleteView(
          onTryAgain: _loadReadiness,
          onBack: Get.back,
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Accept Event'),
      body: GetBuilder<PaymentController>(
        builder: (controller) {
          if (blocker == EventAcceptanceBlocker.vmConnectIncomplete) {
            return RefreshIndicator(
              onRefresh: _loadReadiness,
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  StripeConnectStatusCard(
                    status: connectController.status,
                    role: connectController.role,
                    onPrimaryAction: () =>
                        Get.toNamed(Routes.connectOnboardingScreen),
                    onRefresh: _loadReadiness,
                  ),
                ],
              ),
            );
          }

          if (blocker == EventAcceptanceBlocker.paymentMethodRequired) {
            return PaymentStateView(
              state: PaymentWorkflowState.empty,
              message: 'Add a secure card to continue accepting this event.',
              onRetry: () async {
                await Get.toNamed(
                  Routes.securePaymentMethodsScreen,
                  arguments: {
                    'contextMessage':
                        'Add a secure card to continue accepting this event.',
                    'returnAfterAdd': true,
                  },
                );
                await _loadReadiness();
              },
              child: const SizedBox.shrink(),
            );
          }

          if (blocker == EventAcceptanceBlocker.stripeConfigurationMissing) {
            return PaymentStateView(
              state: PaymentWorkflowState.nonRetryableFailure,
              message: 'Payment setup is temporarily unavailable.',
              onRetry: _loadReadiness,
              child: const SizedBox.shrink(),
            );
          }

          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: _handleGenericRetry,
            child: RefreshIndicator(
              onRefresh: _loadReadiness,
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  StripeConnectStatusCard(
                    status: connectController.status,
                    role: connectController.role,
                    compact: true,
                    onPrimaryAction: connectController.isOnboardingComplete
                        ? null
                        : () => Get.toNamed(Routes.connectOnboardingScreen),
                  ),
                  const SizedBox(height: 12),
                  if (controller.paymentSummary != null)
                    PaymentBreakdownCard(summary: controller.paymentSummary!),
                  Text(
                    'Your payment is confirmed once processing finishes. You can safely leave this screen while it completes.',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 13,
                      color: DynamicColor.grayClr,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: blocker == EventAcceptanceBlocker.none
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  onTap: accepting ? null : _acceptEvent,
                  text: accepting ? 'Accepting...' : 'Accept and Continue',
                ),
              ),
            )
          : null,
    );
  }
}

class PaymentStatusScreen extends StatelessWidget {
  PaymentStatusScreen({super.key});

  final int paymentId = Get.arguments?['paymentId'];
  final PaymentController controller = _paymentController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Payment Status'),
      body: GetBuilder<PaymentController>(
        initState: (_) => controller.loadPayment(paymentId),
        builder: (controller) {
          final payment = controller.currentPayment;
          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: () => controller.loadPayment(paymentId),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusChip(label: payment?.status.name ?? 'unknown'),
                  const SizedBox(height: 12),
                  Text(
                    'Payment status updates automatically. Refunds, disputes, and reviews will appear here.',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 13,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () => controller.resumeAuthentication(paymentId),
            text: 'Resume Authentication',
          ),
        ),
      ),
    );
  }
}

/// Completion "Approve vs Counter" screen for VM + EO. Everything renders
/// from GET /api/events/{event}/payment-journey permissions — no role or
/// status heuristics.
class CompletionWorkflowScreen extends StatefulWidget {
  const CompletionWorkflowScreen({super.key});

  @override
  State<CompletionWorkflowScreen> createState() =>
      _CompletionWorkflowScreenState();
}

class _CompletionWorkflowScreenState extends State<CompletionWorkflowScreen> {
  final int eventId = Get.arguments?['eventId'];
  late final PaymentJourneyController controller;

  @override
  void initState() {
    super.initState();
    controller = paymentJourneyController(eventId);
    // Always re-sync when the screen opens (spec: refresh on open).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshJourney(silent: controller.journey != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Event Completion'),
      body: GetBuilder<PaymentJourneyController>(
        tag: 'payment_journey_$eventId',
        builder: (controller) {
          final journey = controller.journey;
          if (controller.state == PaymentWorkflowState.authorizationError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  controller.errorMessage ??
                      'You are not authorized to view this event\'s payments.',
                  textAlign: TextAlign.center,
                  style: poppinsRegularStyle(
                    context: context,
                    fontSize: 14,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            );
          }
          if (journey == null) {
            if (controller.state == PaymentWorkflowState.loading ||
                controller.state == PaymentWorkflowState.initial) {
              return Center(
                child: CircularProgressIndicator(
                  color: DynamicColor.yellowClr,
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage ?? 'Unable to load payment status.',
                    textAlign: TextAlign.center,
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: controller.refreshJourney,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            color: DynamicColor.yellowClr,
            onRefresh: () => controller.refreshJourney(silent: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14),
              children: [
                CounterReviewCard(controller: controller),
                CompletionReviewCard(controller: controller),
                FinalPaymentStatusCard(controller: controller),
                if (journey.permissions.canSubmitCompletion) ...[
                  CustomButton(
                    heights: 44,
                    borderClr: Colors.transparent,
                    onTap: controller.actionInFlight
                        ? null
                        : controller.submitCompletion,
                    text: 'Mark Event Complete',
                  ),
                  const SizedBox(height: 12),
                ],
                CompletionHistoryList(eventId: eventId),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CancellationWorkflowScreen extends StatefulWidget {
  const CancellationWorkflowScreen({super.key});

  @override
  State<CancellationWorkflowScreen> createState() =>
      _CancellationWorkflowScreenState();
}

class _CancellationWorkflowScreenState
    extends State<CancellationWorkflowScreen> {
  final int eventId = Get.arguments?['eventId'];
  final PaymentController controller = _paymentController();
  late final TextEditingController reasonController;
  bool forceMajeure = false;

  @override
  void initState() {
    super.initState();
    reasonController = TextEditingController(
      text: Get.arguments?['initialReason']?.toString(),
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Cancellation'),
      body: GetBuilder<PaymentController>(
        initState: (_) => controller.loadCancellationPolicy(eventId),
        builder: (controller) {
          final quote = controller.cancellationQuote;
          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: () => controller.loadCancellationPolicy(eventId),
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _textField(context, reasonController, 'Reason message'),
                SwitchListTile(
                  title: Text(
                    'Force majeure',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 14,
                      color: theme.primaryColor,
                    ),
                  ),
                  value: forceMajeure,
                  onChanged: (value) => setState(() => forceMajeure = value),
                ),
                CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () => controller.createCancellationQuote(
                    eventId,
                    reasonType: forceMajeure ? 'force_majeure' : 'normal',
                    reasonMessage: reasonController.text,
                    forceMajeure: forceMajeure,
                  ),
                  text: 'Review Quote',
                ),
                if (quote != null) ...[
                  const SizedBox(height: 14),
                  _QuoteCard(quote: quote),
                  CustomButton(
                    borderClr: Colors.transparent,
                    onTap: controller.confirmCancellation,
                    text: 'Confirm Cancellation',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote});

  final CancellationQuote quote;

  @override
  Widget build(BuildContext context) {
    final formatter = MoneyFormatter();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DynamicColor.darkGrayClr,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quote Review',
            style: poppinsMediumStyle(
              context: context,
              fontSize: 17,
              color: Theme.of(context).primaryColor,
            ),
          ),
          _statusLine('Policy', quote.policyVersion ?? '--'),
          _statusLine('Timezone', quote.eventTimezoneSnapshot ?? '--'),
          _statusLine(
              'Days before event', quote.daysBeforeEvent?.toString() ?? '--'),
          _statusLine('Tier', quote.tier ?? '--'),
          _statusLine('Cancellation liability',
              formatter.formatMinor(quote.cancellationLiabilityMinor)),
          _statusLine('Additional due',
              formatter.formatMinor(quote.additionalPrincipalDueMinor)),
          _statusLine('Refund due',
              formatter.formatMinor(quote.principalRefundDueMinor)),
          if (quote.manualReviewReasons.isNotEmpty)
            _statusLine('Manual review', quote.manualReviewReasons.join(', ')),
        ],
      ),
    );
  }
}

Widget _textField(
  BuildContext context,
  TextEditingController controller,
  String hint,
) {
  return TextField(
    controller: controller,
    maxLines: 3,
    style: poppinsRegularStyle(
      context: context,
      fontSize: 14,
      color: Theme.of(context).primaryColor,
    ),
    decoration: InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(),
    ),
  );
}

Widget _statusLine(String label, String value) {
  return Builder(
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: DynamicColor.grayClr,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}