import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/model/event_counter_model.dart';
import 'package:groovkin/payment/payment_models.dart';
import 'package:intl/intl.dart';

class EventStatusChip extends StatelessWidget {
  const EventStatusChip({super.key, required this.status});

  final String? status;

  @override
  Widget build(BuildContext context) {
    final label = _lifecycleLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: DynamicColor.yellowClr.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DynamicColor.yellowClr.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: poppinsMediumStyle(
          context: context,
          fontSize: 11,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  String _lifecycleLabel(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'pending':
      case 'requested':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'scheduled':
        return 'Scheduled';
      case 'ongoing':
        return 'Ongoing';
      case 'completed':
        return 'Completed';
      case 'acknowledged':
        return 'Acknowledged';
      case 'declined':
        return 'Declined';
      case 'cancelled':
        return 'Cancelled';
      case 'countered':
        return 'Pending';
      default:
        return (status ?? 'Event').capitalizeFirst ?? 'Event';
    }
  }
}

class EventPriceSummaryCard extends StatelessWidget {
  const EventPriceSummaryCard({
    super.key,
    required this.counter,
    this.fallbackTotal,
  });

  final EventCounterState counter;
  final String? fallbackTotal;

  @override
  Widget build(BuildContext context) {
    final money = MoneyFormatter();
    final currency = counter.currency;
    final agreed = counter.currentAgreedAmountMinor;
    return _sectionCard(
      context: context,
      title: counter.isCompletionStage
          ? 'Final Price Summary'
          : 'Price Summary',
      child: Column(
        children: [
          _row(
            context,
            counter.isCompletionStage
                ? 'Final Agreed Event Price'
                : 'Agreed Event Price',
            agreed != null
                ? money.formatMinor(agreed, currency: currency)
                : (fallbackTotal ?? '--'),
            emphasize: true,
          ),
          if (counter.hasActiveCounter)
            _row(
              context,
              'Proposed Price',
              money.formatMinor(
                counter.activeCounterAmountMinor ??
                    counter.activeCounter?.proposedPrincipalMinor,
                currency: currency,
              ),
            ),
          if (counter.paidAmountMinor != null)
            _row(
              context,
              'Paid So Far',
              money.formatMinor(counter.paidAmountMinor, currency: currency),
            ),
          if (counter.paidAmountMinor != null ||
              counter.remainingAmountMinor != null)
            _row(
              context,
              'Remaining Balance',
              money.formatMinor(
                counter.visibleRemainingMinor,
                currency: currency,
              ),
            ),
          if (counter.settlementAdjustmentRequired) ...[
            const SizedBox(height: 10),
            Text(
              'Settlement adjustment required. The agreed event total is lower than the amount already paid.',
              style: poppinsRegularStyle(
                context: context,
                fontSize: 13,
                color: DynamicColor.lightRedClr,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    bool emphasize = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
              fontSize: emphasize ? 16 : 14,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveCounterCard extends StatelessWidget {
  const ActiveCounterCard({super.key, required this.counter});

  final EventCounterState counter;

  @override
  Widget build(BuildContext context) {
    if (!counter.hasActiveCounter) return const SizedBox.shrink();
    final offer = counter.activeCounter;
    final money = MoneyFormatter();
    final title = counter.isCompletionStage
        ? 'Final Price Negotiation'
        : 'Price Negotiation Active';
    return _sectionCard(
      context: context,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _senderLine(offer),
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            money.formatMinor(
              counter.activeCounterAmountMinor ??
                  offer?.proposedPrincipalMinor,
              currency: counter.currency,
            ),
            style: poppinsMediumStyle(
              context: context,
              fontSize: 22,
              color: Theme.of(context).primaryColor,
            ),
          ),
          if (offer?.message != null && offer!.message!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              offer.message!,
              style: poppinsRegularStyle(
                context: context,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
          if (offer?.createdAt != null) ...[
            const SizedBox(height: 6),
            Text(
              DateFormat.yMMMd().add_jm().format(offer!.createdAt!.toLocal()),
              style: poppinsRegularStyle(
                context: context,
                fontSize: 12,
                color: DynamicColor.grayClr,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _senderLine(EventCounterOffer? offer) {
    final role = (offer?.senderRole ?? '').replaceAll('_', ' ');
    if (role.toLowerCase().contains('venue')) {
      return 'Venue Manager proposed';
    }
    if (role.toLowerCase().contains('owner') ||
        role.toLowerCase().contains('organizer')) {
      return 'Event Organizer proposed';
    }
    return offer?.senderName ?? 'Price counter';
  }
}

class CounterHistorySection extends StatelessWidget {
  const CounterHistorySection({super.key, required this.counter});

  final EventCounterState counter;

  @override
  Widget build(BuildContext context) {
    if (counter.history.isEmpty) return const SizedBox.shrink();
    final money = MoneyFormatter();
    return _sectionCard(
      context: context,
      title: 'Negotiation History',
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(
          '${counter.history.length} proposals',
          style: poppinsRegularStyle(
            context: context,
            fontSize: 13,
            color: DynamicColor.grayClr,
          ),
        ),
        children: counter.history
            .map(
              (item) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  money.formatMinor(
                    item.proposedPrincipalMinor,
                    currency: counter.currency,
                  ),
                  style: poppinsMediumStyle(
                    context: context,
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                subtitle: Text(
                  [
                    item.senderRole ?? '',
                    item.status ?? '',
                    if (item.message != null && item.message!.isNotEmpty)
                      item.message!,
                  ].where((part) => part.toString().isNotEmpty).join(' · '),
                  style: poppinsRegularStyle(
                    context: context,
                    fontSize: 12,
                    color: DynamicColor.grayClr,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class EventHeroHeader extends StatelessWidget {
  const EventHeroHeader({super.key, required this.event});

  final EventDetails event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = event.bannerImage?.mediaPath ??
        (event.profilePicture?.isNotEmpty == true
            ? event.profilePicture!.first.mediaPath
            : null);
    final url = image == null
        ? null
        : (image.startsWith('http') ? image : '${Url().imageUrl}$image');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: url == null
                ? Container(color: DynamicColor.darkGrayClr)
                : Image.network(url, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                event.eventTitle ?? 'Event',
                style: poppinsMediumStyle(
                  context: context,
                  fontSize: 22,
                  color: theme.primaryColor,
                ),
              ),
            ),
            EventStatusChip(status: event.status),
          ],
        ),
        if (event.counter.hasActiveCounter) ...[
          const SizedBox(height: 8),
          Text(
            event.counter.isCompletionStage
                ? 'Final Price Negotiation'
                : 'Price Negotiation Active',
            style: poppinsMediumStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.yellowClr,
            ),
          ),
        ],
        if (event.startDateTime != null) ...[
          const SizedBox(height: 8),
          Text(
            '${DateFormat.yMMMMEEEEd().format(event.startDateTime!)} · ${DateFormat('HH:mm').format(event.startDateTime!)} – ${event.endDateTime != null ? DateFormat('HH:mm').format(event.endDateTime!) : ''}',
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
        ],
        if (event.location != null && event.location!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            event.location!,
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
        ],
      ],
    );
  }
}

class EventInfoSection extends StatelessWidget {
  const EventInfoSection({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final Map<String, String> rows;

  @override
  Widget build(BuildContext context) {
    final visible = rows.entries
        .where((entry) =>
            entry.value.isNotEmpty &&
            entry.value != 'null' &&
            entry.value != '--')
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    return _sectionCard(
      context: context,
      title: title,
      child: Column(
        children: visible
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        entry.key,
                        style: poppinsRegularStyle(
                          context: context,
                          fontSize: 13,
                          color: DynamicColor.grayClr,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
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
            )
            .toList(),
      ),
    );
  }
}

class EventPreferencesSection extends StatelessWidget {
  const EventPreferencesSection({super.key, required this.event});

  final EventDetails event;

  @override
  Widget build(BuildContext context) {
    return EventInfoSection(
      title: 'Event Preferences',
      rows: {
        'Services': _csv(
          (event.services ?? []).map((item) => item.eventItem?.name),
        ),
        'Music': _musicLabels(event),
        'Activities': _activityLabels(event),
      },
    );
  }
}

class EventTagsSection extends StatelessWidget {
  const EventTagsSection({super.key, required this.event});

  final EventDetails event;

  @override
  Widget build(BuildContext context) {
    final collections = (event.hashtagCollections ?? [])
        .map((item) => item.title)
        .whereType<String>();
    final manuals = (event.manualHashtags ?? []).map((item) => item.name);
    final privateTags = (event.hashtags ?? []).map((item) => item.name);
    return EventInfoSection(
      title: 'Tags',
      rows: {
        'Collections': _csv(collections),
        'Manual hashtags': _csv(manuals),
        'Private hashtags': _csv(privateTags),
      },
    );
  }
}

String _csv(Iterable<String?> values) {
  return values
      .map((value) => value?.trim() ?? '')
      .where((value) => value.isNotEmpty)
      .join(', ');
}

String _musicLabels(EventDetails event) {
  final labels = <String>[];
  for (final genre in event.musicGenre ?? const []) {
    for (final item in genre.musicGenreItems ?? const []) {
      if (item.selected == true) {
        labels.add(item.name ?? '');
      }
    }
  }
  for (final tag in event.eventMusicChoiceTags ?? const []) {
    for (final item in tag.musicChoiceItems?.categoryItems ?? const []) {
      if (item.userSelection == true) {
        labels.add(item.name ?? '');
      }
    }
  }
  return _csv(labels);
}

String _activityLabels(EventDetails event) {
  final labels = <String>[];
  for (final tag in event.eventActivityChoiceTags ?? const []) {
    for (final item in tag.activityChoiceItems?.categoryItems ?? const []) {
      if (item.userSelection == true) {
        labels.add(item.name ?? '');
      }
    }
  }
  return _csv(labels);
}

Widget _sectionCard({
  required BuildContext context,
  required String title,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: DynamicColor.darkGrayClr.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: DynamicColor.grayClr.withValues(alpha: 0.22),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: poppinsMediumStyle(
            context: context,
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}
