import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:intl/intl.dart';
import '../payment_models.dart';
import '../stripe_connect_widgets.dart';
import 'wallet_controller.dart';
import 'wallet_models.dart';

class WalletHomeScreen extends StatelessWidget {
  WalletHomeScreen({super.key});

  final WalletController controller = walletController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<WalletController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: customAppBar(theme: theme, text: controller.screenTitle),
          body: RefreshIndicator(
            onRefresh: controller.refreshAll,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const StripeConnectBanner(),
                if (controller.state == PaymentWorkflowState.loading &&
                    controller.summary == null)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (controller.summary != null)
                  _SummarySection(summary: controller.summary!)
                else
                  _MessageBox(
                    message: controller.errorMessage ??
                        'Unable to load wallet summary.',
                    onRetry: controller.refreshSummary,
                  ),
                const SizedBox(height: 16),
                _PayoutsSection(payouts: controller.payouts),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Transactions',
                        style: poppinsMediumStyle(
                          context: context,
                          fontSize: 17,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Get.toNamed(Routes.walletTransactionsScreen),
                      child: const Text('View all'),
                    ),
                  ],
                ),
                if (controller.transactions.isEmpty)
                  _MessageBox(
                    message:
                        'Transaction history will appear here after payments are processed.',
                  )
                else
                  ...controller.transactions.take(8).map(
                        (tx) => WalletTransactionTile(
                          transaction: tx,
                          role: controller.summary?.role ?? WalletRole.unknown,
                          onTap: () => Get.toNamed(
                            Routes.walletTransactionDetailScreen,
                            arguments: {'transactionId': tx.id},
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
                CustomButton(
                  borderClr: DynamicColor.yellowClr,
                  backgroundClr: false,
                  onTap: () => Get.toNamed(Routes.securePaymentMethodsScreen),
                  text: 'Payment Methods',
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WalletTransactionsScreen extends StatelessWidget {
  WalletTransactionsScreen({super.key});

  final WalletController controller = walletController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Transactions'),
      body: GetBuilder<WalletController>(
        builder: (controller) {
          return Column(
            children: [
              _FilterBar(
                filters: controller.filters,
                onChanged: controller.applyFilters,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.refreshTransactions(reset: true),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 120 &&
                          controller.hasMore &&
                          !controller.loadingMore) {
                        controller.loadMore();
                      }
                      return false;
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        if (controller.listState ==
                                PaymentWorkflowState.loading &&
                            controller.transactions.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (controller.transactions.isEmpty)
                          _MessageBox(
                            message:
                                'Transaction history will appear here after payments are processed.',
                            onRetry: () =>
                                controller.refreshTransactions(reset: true),
                          )
                        else
                          ...controller.transactions.map(
                            (tx) => WalletTransactionTile(
                              transaction: tx,
                              role: controller.summary?.role ??
                                  WalletRole.unknown,
                              onTap: () => Get.toNamed(
                                Routes.walletTransactionDetailScreen,
                                arguments: {'transactionId': tx.id},
                              ),
                            ),
                          ),
                        if (controller.loadingMore)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WalletTransactionDetailScreen extends StatefulWidget {
  const WalletTransactionDetailScreen({super.key});

  @override
  State<WalletTransactionDetailScreen> createState() =>
      _WalletTransactionDetailScreenState();
}

class _WalletTransactionDetailScreenState
    extends State<WalletTransactionDetailScreen> {
  final WalletController controller = walletController();
  late final String transactionId;

  @override
  void initState() {
    super.initState();
    transactionId = Get.arguments?['transactionId']?.toString() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (transactionId.isNotEmpty) {
        controller.loadTransactionDetail(transactionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Transaction Detail'),
      body: GetBuilder<WalletController>(
        builder: (controller) {
          final detail = controller.selectedDetail;
          if (controller.state == PaymentWorkflowState.loading &&
              detail == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (detail == null) {
            return _MessageBox(
              message: controller.errorMessage ??
                  'This transaction could not be found.',
              onRetry: () => controller.loadTransactionDetail(transactionId),
            );
          }
          final money = MoneyFormatter();
          return RefreshIndicator(
            onRefresh: () => controller.loadTransactionDetail(transactionId),
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _DetailRow('Reference', detail.reference ?? detail.id),
                _DetailRow('Event', detail.event?.title ?? '--'),
                _DetailRow(
                  'Category',
                  walletCategoryLabel(
                    detail.category,
                    role: controller.summary?.role ?? WalletRole.unknown,
                  ),
                ),
                _DetailRow('Direction', detail.direction.name),
                _DetailRow('Status', detail.status ?? '--'),
                _DetailRow(
                  'Principal',
                  money.formatMinor(detail.principalMinor,
                      currency: detail.currency),
                ),
                _DetailRow(
                  'Stripe processing fee',
                  money.formatMinor(detail.stripeFeeMinor,
                      currency: detail.currency),
                ),
                _DetailRow(
                  'Net',
                  money.formatMinor(detail.netMinor, currency: detail.currency),
                ),
                if (detail.occurredAt != null)
                  _DetailRow(
                    'Date',
                    DateFormat.yMMMd().add_jm().format(
                          detail.occurredAt!.toLocal(),
                        ),
                  ),
                if (detail.transferStatus != null)
                  _DetailRow('Transfer status', detail.transferStatus!),
                if (detail.refundStatus != null)
                  _DetailRow('Refund status', detail.refundStatus!),
                if (detail.disputeStatus != null)
                  _DetailRow('Dispute status', detail.disputeStatus!),
                if (detail.supportReference != null)
                  _DetailRow('Support reference', detail.supportReference!),
                if (detail.manualReviewReason != null)
                  _DetailRow('Manual review', detail.manualReviewReason!),
                if (detail.safeErrorMessage != null)
                  _DetailRow('Note', detail.safeErrorMessage!),
                if (detail.timeline.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Timeline',
                    style: poppinsMediumStyle(
                      context: context,
                      fontSize: 16,
                      color: theme.primaryColor,
                    ),
                  ),
                  ...detail.timeline.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        item['title']?.toString() ??
                            item['code']?.toString() ??
                            item.toString(),
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 13,
                          color: DynamicColor.grayClr,
                        ),
                      ),
                    ),
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

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.summary});

  final WalletSummary summary;

  @override
  Widget build(BuildContext context) {
    final money = MoneyFormatter();
    final cards = <_SummaryCardData>[];
    if (summary.isEventOwner) {
      cards.addAll([
        _SummaryCardData(
            'Net earnings',
            money.formatMinor(summary.netEarningsMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Transferred to Stripe',
            money.formatMinor(summary.transferredToConnectMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Pending transfer',
            money.formatMinor(summary.pendingTransferMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Refunded / reversed',
            money.formatMinor(summary.refundedOrReversedMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Manual review',
            money.formatMinor(summary.manualReviewMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Completed events', '${summary.completedEventsCount ?? 0}'),
        _SummaryCardData(
            'Pending events', '${summary.pendingEventsCount ?? 0}'),
      ]);
    } else {
      cards.addAll([
        _SummaryCardData(
            'Event principal paid',
            money.formatMinor(summary.eventPrincipalPaidMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Stripe fees paid',
            money.formatMinor(summary.stripeFeesPaidMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Total charged',
            money.formatMinor(summary.totalChargedMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Refunds received',
            money.formatMinor(summary.refundsReceivedMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Pending refunds',
            money.formatMinor(summary.pendingRefundsMinor,
                currency: summary.currency)),
        _SummaryCardData(
            'Active commitments',
            money.formatMinor(summary.activeEventCommitmentsMinor,
                currency: summary.currency)),
        _SummaryCardData('Events paid', '${summary.eventsPaidCount ?? 0}'),
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          summary.currency,
          style: poppinsMediumStyle(
            context: context,
            fontSize: 14,
            color: DynamicColor.yellowClr,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cards
              .map(
                (card) => SizedBox(
                  width: (Get.width - 40) / 2,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DynamicColor.darkGrayClr,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.label,
                          style: poppinsRegularStyle(
                            context: context,
                            fontSize: 12,
                            color: DynamicColor.grayClr,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.value,
                          style: poppinsMediumStyle(
                            context: context,
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (summary.currencies.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Other currencies',
            style: poppinsMediumStyle(
              context: context,
              fontSize: 14,
              color: Theme.of(context).primaryColor,
            ),
          ),
          ...summary.currencies.map(
            (bucket) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${bucket.currency}: ${money.formatMinor(bucket.netEarningsMinor ?? bucket.totalChargedMinor, currency: bucket.currency)}',
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 13,
                  color: DynamicColor.grayClr,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PayoutsSection extends StatelessWidget {
  const _PayoutsSection({required this.payouts});

  final WalletPayoutsResponse? payouts;

  @override
  Widget build(BuildContext context) {
    final money = MoneyFormatter();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfers',
          style: poppinsMediumStyle(
            context: context,
            fontSize: 17,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DynamicColor.darkGrayClr,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            payouts?.actualBankPayoutTrackingEnabled == true
                ? (payouts?.message ?? 'Payout status from Stripe.')
                : 'Groovkin has transferred these proceeds to your Stripe account. Bank payout timing is managed by Stripe.',
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.whiteClr,
            ),
          ),
        ),
        if (payouts != null && payouts!.transfers.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'No transfers yet.',
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: DynamicColor.grayClr,
              ),
            ),
          ),
        ...?(payouts?.transfers.map(
          (transfer) => Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DynamicColor.darkGrayClr,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transfer.label ?? 'Transferred to Stripe account',
                        style: poppinsMediumStyle(
                          context: context,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        transfer.status ?? '--',
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 12,
                          color: DynamicColor.grayClr,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  money.formatMinor(
                    transfer.amountMinor,
                    currency: transfer.currency,
                  ),
                  style: poppinsMediumStyle(
                    context: context,
                    fontSize: 14,
                    color: DynamicColor.yellowClr,
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({
    super.key,
    required this.transaction,
    required this.role,
    this.onTap,
  });

  final WalletTransaction transaction;
  final WalletRole role;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final money = MoneyFormatter();
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DynamicColor.darkGrayClr,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.event?.title ??
                        walletCategoryLabel(transaction.category, role: role),
                    style: poppinsMediumStyle(
                      context: context,
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    '${walletCategoryLabel(transaction.category, role: role)} • ${transaction.status ?? '--'}',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 12,
                      color: DynamicColor.grayClr,
                    ),
                  ),
                  if (transaction.occurredAt != null)
                    Text(
                      DateFormat.yMMMd().format(
                        transaction.occurredAt!.toLocal(),
                      ),
                      style: poppinsRegularStyle(
                        context: context,
                        fontSize: 11,
                        color: DynamicColor.grayClr,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              money.formatMinor(
                transaction.netMinor ?? transaction.principalMinor,
                currency: transaction.currency,
              ),
              style: poppinsMediumStyle(
                context: context,
                fontSize: 14,
                color: DynamicColor.yellowClr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.filters, required this.onChanged});

  final WalletTransactionFilters filters;
  final ValueChanged<WalletTransactionFilters> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        children: [
          _Chip(
            label: 'All',
            selected: filters.status == null && filters.type == null,
            onTap: () => onChanged(WalletTransactionFilters()),
          ),
          _Chip(
            label: 'Succeeded',
            selected: filters.status == 'succeeded',
            onTap: () => onChanged(
              WalletTransactionFilters(status: 'succeeded'),
            ),
          ),
          _Chip(
            label: 'Pending',
            selected:
                filters.status == 'pending' || filters.status == 'processing',
            onTap: () => onChanged(
              WalletTransactionFilters(status: 'processing'),
            ),
          ),
          _Chip(
            label: 'Failed',
            selected: filters.status == 'failed',
            onTap: () => onChanged(WalletTransactionFilters(status: 'failed')),
          ),
          _Chip(
            label: 'Refunds',
            selected: filters.type == 'refund',
            onTap: () => onChanged(WalletTransactionFilters(type: 'refund')),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: DynamicColor.yellowClr,
      ),
    );
  }
}

class _SummaryCardData {
  _SummaryCardData(this.label, this.value);
  final String label;
  final String value;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: poppinsMediumStyle(
                context: context,
                fontSize: 13,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBox extends StatelessWidget {
  const _MessageBox({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DynamicColor.darkGrayClr,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.whiteClr,
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
