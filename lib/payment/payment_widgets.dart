import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'payment_models.dart';

class PaymentStateView extends StatelessWidget {
  const PaymentStateView({
    super.key,
    required this.state,
    this.message,
    this.onRetry,
    required this.child,
  });

  final PaymentWorkflowState state;
  final String? message;
  final VoidCallback? onRetry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case PaymentWorkflowState.initial:
      case PaymentWorkflowState.ready:
      case PaymentWorkflowState.refreshing:
      // Success renders the real screen content; the screen itself decides
      // how to present the confirmed backend state.
      case PaymentWorkflowState.success:
        return child;
      case PaymentWorkflowState.loading:
      case PaymentWorkflowState.submitting:
      case PaymentWorkflowState.processing:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: DynamicColor.yellowClr),
              const SizedBox(height: 14),
              state == PaymentWorkflowState.processing
                  ? _MessageState(
                      title: 'Processing',
                      message: message ?? 'Confirming payment status...',
                      action: onRetry,
                      actionText: 'Refresh',
                    )
                  : Text(
                      'Loading...',
                      textAlign: TextAlign.center,
                      style: poppinsRegularStyle(
                        context: context,
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
            ],
          ),
        );
      case PaymentWorkflowState.empty:
        return _MessageState(
          title: 'No payment method added',
          message: message ??
              'Add a secure card before accepting event requests. Your card details are handled securely by Stripe.',
          action: onRetry,
          actionText: 'Add Secure Card',
        );
      case PaymentWorkflowState.requiresAction:
        return _MessageState(
          title: 'Authentication Required',
          message: message ??
              'This payment requires additional authentication before it can finish.',
          action: onRetry,
          actionText: 'Continue',
        );
      case PaymentWorkflowState.supportReview:
      case PaymentWorkflowState.manualReview:
        return _MessageState(
          title: state == PaymentWorkflowState.supportReview
              ? 'Support Review'
              : 'Manual Review',
          message: message ??
              'Groovkin support is reviewing this. The status here will update automatically.',
          action: onRetry,
          actionText: 'Refresh',
        );
      case PaymentWorkflowState.disputed:
      case PaymentWorkflowState.refunded:
      case PaymentWorkflowState.partiallyRefunded:
        return _MessageState(
          title: state.name,
          message: message ??
              'This status reflects your latest payment and refund activity.',
          action: onRetry,
          actionText: 'Refresh',
        );
      case PaymentWorkflowState.validationError:
      case PaymentWorkflowState.networkError:
      case PaymentWorkflowState.authorizationError:
      case PaymentWorkflowState.retryableFailure:
      case PaymentWorkflowState.nonRetryableFailure:
        return _MessageState(
          title: 'Action Needed',
          message: message ?? 'The request could not be completed.',
          action: onRetry,
          actionText: 'Retry',
        );
    }
  }
}

class PaymentBreakdownCard extends StatelessWidget {
  const PaymentBreakdownCard({
    super.key,
    required this.summary,
    this.title = 'Payment Summary',
  });

  final PaymentSummary summary;
  final String title;

  @override
  Widget build(BuildContext context) {
    final formatter = MoneyFormatter();
    return _GroovkinCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title),
          _MoneyRow(
            label: 'Event value',
            value: formatter.formatMinor(
              summary.eventPrincipalMinor,
              currency: summary.currency,
            ),
          ),
          _MoneyRow(
            label: 'Down payment',
            value:
                '${summary.downPaymentPercentage ?? '--'}% • ${formatter.formatMinor(summary.downPaymentPrincipalMinor, currency: summary.currency)}',
          ),
          _MoneyRow(
            label: 'Stripe processing fee',
            value: formatter.formatMinor(
              summary.estimatedDownPaymentStripeFeeMinor,
              currency: summary.currency,
            ),
          ),
          _MoneyRow(
            label: 'Charged now',
            value: formatter.formatMinor(
              summary.chargeAmountMinor ?? summary.downPaymentPrincipalMinor,
              currency: summary.currency,
            ),
            emphasized: true,
          ),
          _MoneyRow(
            label: 'Remaining balance',
            value: formatter.formatMinor(
              summary.remainingPrincipalMinor,
              currency: summary.currency,
            ),
          ),
          if (summary.targetTotalGroovkinCommissionMinor != null)
            _MoneyRow(
              label: 'Groovkin commission target',
              value: formatter.formatMinor(
                summary.targetTotalGroovkinCommissionMinor,
                currency: summary.currency,
              ),
            ),
        ],
      ),
    );
  }
}

class PaymentMethodCardTile extends StatelessWidget {
  const PaymentMethodCardTile({
    super.key,
    required this.card,
    this.onSetDefault,
    this.onDelete,
  });

  final PaymentMethodCard card;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _GroovkinCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: DynamicColor.yellowClr,
            child:
                Icon(Icons.credit_card, color: theme.scaffoldBackgroundColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card.brand.toUpperCase()} •••• ${card.last4}',
                  style: poppinsMediumStyle(
                    context: context,
                    fontSize: 15,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  'Expires ${card.expMonth.toString().padLeft(2, '0')}/${card.expYear}${card.isExpired ? ' • expired' : ''}',
                  style: poppinsRegularStyle(
                    context: context,
                    fontSize: 12,
                    color: card.isExpired
                        ? DynamicColor.lightRedClr
                        : DynamicColor.grayClr,
                  ),
                ),
              ],
            ),
          ),
          if (card.isDefault)
            Chip(
              label: const Text('Default'),
              backgroundColor: DynamicColor.yellowClr,
            )
          else
            TextButton(
              onPressed: onSetDefault,
              child: const Text('Set default'),
            ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: DynamicColor.lightRedClr),
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: DynamicColor.darkGrayClr,
      labelStyle: poppinsRegularStyle(
        context: context,
        fontSize: 12,
        color: DynamicColor.whiteClr,
      ),
    );
  }
}

class _GroovkinCard extends StatelessWidget {
  const _GroovkinCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DynamicColor.darkGrayClr,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: poppinsMediumStyle(
          context: context,
          fontSize: 17,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _MoneyRow extends StatelessWidget {
  const _MoneyRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
          Text(
            value,
            style: poppinsMediumStyle(
              context: context,
              fontSize: emphasized ? 15 : 13,
              color: emphasized
                  ? DynamicColor.yellowClr
                  : Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.title,
    required this.message,
    this.action,
    this.actionText,
  });

  final String title;
  final String message;
  final VoidCallback? action;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: poppinsMediumStyle(
                context: context,
                fontSize: 20,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: DynamicColor.grayClr,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              CustomButton(
                widths: Get.width / 2,
                borderClr: Colors.transparent,
                onTap: action,
                text: actionText ?? 'Retry',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
