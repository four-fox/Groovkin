import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'payment_controller.dart';
import 'payment_models.dart';
import 'payment_widgets.dart';

PaymentController _paymentController() {
  if (Get.isRegistered<PaymentController>()) {
    return Get.find<PaymentController>();
  }
  return Get.put(PaymentController());
}

class ConnectOnboardingScreen extends StatelessWidget {
  ConnectOnboardingScreen({super.key});

  final PaymentController controller = _paymentController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Stripe Connect'),
      body: GetBuilder<PaymentController>(
        initState: (_) => controller.refreshConnectStatus(),
        builder: (controller) {
          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: controller.refreshConnectStatus,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect status',
                    style: poppinsMediumStyle(
                      context: context,
                      fontSize: 20,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _statusLine('Account',
                      controller.connectStatus?.accountId ?? 'Not started'),
                  _statusLine(
                      'Details submitted',
                      controller.connectStatus?.detailsSubmitted == true
                          ? 'Yes'
                          : 'No'),
                  _statusLine(
                      'Charges enabled',
                      controller.connectStatus?.chargesEnabled == true
                          ? 'Yes'
                          : 'No'),
                  _statusLine(
                      'Payouts enabled',
                      controller.connectStatus?.payoutsEnabled == true
                          ? 'Yes'
                          : 'No'),
                  const SizedBox(height: 12),
                  if ((controller.connectStatus?.requirementsDue ?? [])
                      .isNotEmpty)
                    Text(
                      'Requirements due: ${controller.connectStatus!.requirementsDue.join(', ')}',
                      style: poppinsRegularStyle(
                        context: context,
                        fontSize: 13,
                        color: DynamicColor.lightRedClr,
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
            onTap: controller.launchConnectOnboarding,
            text: 'Open Stripe Onboarding',
          ),
        ),
      ),
    );
  }
}

class SecurePaymentMethodScreen extends StatelessWidget {
  SecurePaymentMethodScreen({super.key});

  final PaymentController controller = _paymentController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Payment Methods'),
      body: GetBuilder<PaymentController>(
        initState: (_) => controller.refreshPaymentMethods(),
        builder: (controller) {
          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: controller.refreshPaymentMethods,
            child: RefreshIndicator(
              onRefresh: controller.refreshPaymentMethods,
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
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
                        'No reusable payment method is saved yet.',
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
            onTap: controller.addPaymentMethod,
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

class EventAcceptPaymentScreen extends StatelessWidget {
  EventAcceptPaymentScreen({super.key});

  final int eventId = Get.arguments?['eventId'];
  final PaymentController controller = _paymentController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Accept Event'),
      body: GetBuilder<PaymentController>(
        initState: (_) async {
          await controller.loadPaymentSummary(eventId);
          await controller.refreshPaymentMethods();
        },
        builder: (controller) {
          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: () => controller.loadPaymentSummary(eventId),
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                if (controller.paymentSummary != null)
                  PaymentBreakdownCard(summary: controller.paymentSummary!),
                Text(
                  'Payment completion is confirmed only after Laravel reports final status.',
                  style: poppinsRegularStyle(
                    context: context,
                    fontSize: 13,
                    color: DynamicColor.grayClr,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () => controller.acceptEvent(eventId),
            text: 'Accept and Continue',
          ),
        ),
      ),
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
                    'Backend status is the source of truth for payment, refund, dispute, and review states.',
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

class CompletionWorkflowScreen extends StatefulWidget {
  const CompletionWorkflowScreen({super.key});

  @override
  State<CompletionWorkflowScreen> createState() =>
      _CompletionWorkflowScreenState();
}

class _CompletionWorkflowScreenState extends State<CompletionWorkflowScreen> {
  final int eventId = Get.arguments?['eventId'];
  final PaymentController controller = _paymentController();
  final proposedPrincipalMinorController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void dispose() {
    proposedPrincipalMinorController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Completion'),
      body: GetBuilder<PaymentController>(
        initState: (_) {
          controller.loadCompletionStatus(eventId);
          controller.loadCompletionHistory(eventId);
        },
        builder: (controller) {
          final status = controller.completionStatus;
          return PaymentStateView(
            state: controller.state,
            message: controller.errorMessage,
            onRetry: () => controller.loadCompletionStatus(eventId),
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                StatusChip(label: status?.status.name ?? 'unknown'),
                const SizedBox(height: 10),
                _statusLine('Auto approval countdown',
                    _seconds(status?.autoApproveSecondsRemaining)),
                _statusLine('Counter countdown',
                    _seconds(status?.counterSecondsRemaining)),
                const SizedBox(height: 12),
                _numberField(
                  context,
                  proposedPrincipalMinorController,
                  'Counter proposed principal minor',
                ),
                const SizedBox(height: 8),
                _textField(context, messageController, 'Counter message'),
                const SizedBox(height: 12),
                CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () {
                    final proposedPrincipalMinor =
                        int.tryParse(proposedPrincipalMinorController.text);
                    if (proposedPrincipalMinor == null) return;
                    controller.createCounter(
                      eventId,
                      proposedPrincipalMinor: proposedPrincipalMinor,
                      message: messageController.text,
                    );
                  },
                  text: 'Create Counter',
                ),
                const SizedBox(height: 8),
                CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () => controller.submitCompletion(eventId),
                  text: 'Mark Event Complete',
                ),
                const SizedBox(height: 8),
                CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () => controller.approveCompletion(eventId),
                  text: 'Approve Completion',
                ),
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

Widget _numberField(
  BuildContext context,
  TextEditingController controller,
  String hint,
) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
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

String _seconds(int? value) {
  if (value == null) return '--';
  final duration = Duration(seconds: value);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  return '${hours}h ${minutes}m';
}
