import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/searchRadiusSelector.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';

import 'discovery_contract.dart';

class DiscoveryCardCopy {
  const DiscoveryCardCopy({this.badge, this.reasons, this.distance});

  final String? badge;
  final String? reasons;
  final String? distance;

  static DiscoveryCardCopy fromEvent(EventData event) {
    final discovery = event.discovery;
    final signal = discovery ?? event.searchSignal;
    String? badge;
    if (discovery?.isPersonalized == true) badge = 'For you';
    if (discovery?.isDiscovery == true) badge = 'Explore nearby';
    final labels = signal?.reasonLabels
            .map((reason) => reason.label.trim())
            .where((label) => label.isNotEmpty)
            .toList() ??
        const <String>[];
    final reasons = labels.isEmpty
        ? (signal == null ? event.recommendation?.displayReason : null)
        : labels.join(' · ');
    return DiscoveryCardCopy(
      badge: badge,
      reasons: reasons,
      distance: signal?.distanceLabel,
    );
  }
}

class DiscoveryMetaLines extends StatelessWidget {
  const DiscoveryMetaLines({
    super.key,
    this.badge,
    this.reasons,
    this.distance,
  });

  final String? badge;
  final String? reasons;
  final String? distance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = <Widget>[];
    if (badge != null && badge!.trim().isNotEmpty) {
      lines.add(Text(
        badge!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: poppinsRegularStyle(
          fontSize: 11,
          context: context,
          color: DynamicColor.yellowClr,
        ),
      ));
    }
    if (reasons != null && reasons!.trim().isNotEmpty) {
      lines.add(Text(
        reasons!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: poppinsRegularStyle(
          fontSize: 11,
          context: context,
          color: DynamicColor.yellowClr,
        ),
      ));
    }
    if (distance != null && distance!.trim().isNotEmpty) {
      lines.add(Text(
        distance!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: poppinsRegularStyle(
          fontSize: 11,
          context: context,
          color: theme.cardColor,
        ),
      ));
    }
    if (lines.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines,
      ),
    );
  }
}

class DiscoveryFeedNotice extends StatelessWidget {
  const DiscoveryFeedNotice({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: poppinsRegularStyle(
              fontSize: 13,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          if (actionLabel != null && onAction != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ),
        ],
      ),
    );
  }
}

class DiscoverySearchPanel extends StatelessWidget {
  const DiscoverySearchPanel({
    super.key,
    required this.draft,
    required this.activities,
    required this.music,
    required this.radiusOptions,
    required this.coordinatesAvailable,
    required this.onSort,
    required this.postalController,
    required this.onPostal,
    required this.activityController,
    required this.musicController,
    required this.onToggleRadius,
    required this.onRadius,
    required this.onToggleActivity,
    required this.onMusic,
    required this.onActivityText,
    required this.onMusicText,
    required this.onClear,
    this.postalError,
    this.activeSummary = const [],
  });

  final DiscoverySearchDraft draft;
  final List<DiscoveryCatalogOption> activities;
  final List<DiscoveryCatalogOption> music;
  final List<int> radiusOptions;
  final bool coordinatesAvailable;
  final ValueChanged<String> onSort;
  final TextEditingController postalController;
  final ValueChanged<String> onPostal;
  final TextEditingController activityController;
  final TextEditingController musicController;
  final ValueChanged<bool> onToggleRadius;
  final ValueChanged<int> onRadius;
  final ValueChanged<int> onToggleActivity;
  final ValueChanged<int?> onMusic;
  final ValueChanged<String> onActivityText;
  final ValueChanged<String> onMusicText;
  final VoidCallback onClear;
  final String? postalError;
  final List<String> activeSummary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (activeSummary.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...activeSummary.map(
                  (label) => Chip(
                    label: Text(label),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ),
                ActionChip(
                  label: const Text('Clear filters'),
                  onPressed: onClear,
                ),
              ],
            ),
          ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: Text(
            'Filters',
            style: poppinsRegularStyle(
              fontSize: 14,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          children: [
            _label(context, 'Sort'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DiscoverySearchDraft.sorts.map((sort) {
                final nearestBlocked = sort == 'nearest' && !coordinatesAvailable;
                return ChoiceChip(
                  label: Text(_sortLabel(sort)),
                  selected: draft.sort == sort,
                  onSelected: nearestBlocked
                      ? null
                      : (_) {
                          if (draft.sort != sort) onSort(sort);
                        },
                );
              }).toList(),
            ),
            if (!coordinatesAvailable)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Nearest needs a location.',
                  style: poppinsRegularStyle(
                    fontSize: 12,
                    context: context,
                    color: DynamicColor.grayClr,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            _label(context, 'ZIP code'),
            TextFormField(
              key: const Key('discovery-zip'),
              controller: postalController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 5,
              decoration: InputDecoration(
                counterText: '',
                hintText: '08861',
                errorText: postalError,
              ),
              onChanged: onPostal,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Limit to nearby radius'),
              subtitle: Text(
                coordinatesAvailable
                    ? 'Uses your location and the selected miles.'
                    : 'Needs a location before a radius can be applied.',
              ),
              value: draft.applyRadius && coordinatesAvailable,
              onChanged: coordinatesAvailable ? onToggleRadius : null,
            ),
            if (draft.applyRadius && coordinatesAvailable)
              SearchRadiusSelector(
                selected: draft.radius,
                options: radiusOptions,
                onSelected: onRadius,
              ),
            const SizedBox(height: 8),
            _label(context, 'Activities'),
            if (activities.isEmpty)
              TextFormField(
                key: const Key('discovery-activity-text'),
                controller: activityController,
                decoration: const InputDecoration(hintText: 'Activity name'),
                textInputAction: TextInputAction.done,
                onChanged: onActivityText,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: activities
                    .map(
                      (option) => FilterChip(
                        label: Text(option.name),
                        selected: draft.activityIds.contains(option.id),
                        onSelected: (_) => onToggleActivity(option.id),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 12),
            _label(context, 'Music'),
            if (music.isEmpty)
              TextFormField(
                key: const Key('discovery-music-text'),
                controller: musicController,
                decoration: const InputDecoration(hintText: 'Music genre'),
                textInputAction: TextInputAction.done,
                onChanged: onMusicText,
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Any'),
                    selected: draft.musicGenreId == null,
                    onSelected: (_) => onMusic(null),
                  ),
                  ...music.map(
                    (option) => ChoiceChip(
                      label: Text(option.name),
                      selected: draft.musicGenreId == option.id,
                      onSelected: (_) => onMusic(option.id),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
          ],
        ),
      ],
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: poppinsRegularStyle(
          fontSize: 13,
          context: context,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  String _sortLabel(String sort) {
    switch (sort) {
      case 'nearest':
        return 'Nearest';
      case 'soonest':
        return 'Soonest';
      case 'newest':
        return 'Newest';
      default:
        return 'Relevance';
    }
  }
}

List<String> discoveryActiveFilterLabels({
  required DiscoverySearchDraft draft,
  required List<DiscoveryCatalogOption> activities,
  required List<DiscoveryCatalogOption> music,
}) {
  final labels = <String>[];
  final text = draft.text.trim();
  if (text.isNotEmpty) labels.add(text);
  if (isCompleteUsZip(draft.postalCode)) labels.add('ZIP ${draft.postalCode.trim()}');
  for (final id in draft.activityIds) {
    final match = activities.where((option) => option.id == id);
    labels.add(match.isEmpty ? 'Activity $id' : match.first.name);
  }
  if (draft.activityIds.isEmpty && draft.activityText.trim().isNotEmpty) {
    labels.add(draft.activityText.trim());
  }
  if (draft.musicGenreId != null) {
    final match = music.where((option) => option.id == draft.musicGenreId);
    labels.add(match.isEmpty ? 'Music' : match.first.name);
  } else if (draft.musicText.trim().isNotEmpty) {
    labels.add(draft.musicText.trim());
  }
  if (draft.sort != 'relevance') {
    labels.add(draft.sort[0].toUpperCase() + draft.sort.substring(1));
  }
  if (draft.applyRadius) labels.add('${draft.radius} mi');
  return labels;
}
