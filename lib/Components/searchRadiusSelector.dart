import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/utils/search_radius.dart';

class SearchRadiusSelector extends StatelessWidget {
  const SearchRadiusSelector({
    super.key,
    required this.selected,
    required this.onSelected,
    this.options = kDefaultSearchRadiiMiles,
    this.enabled = true,
  });

  final int selected;
  final ValueChanged<int> onSelected;
  final List<int> options;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = options.isEmpty ? kDefaultSearchRadiiMiles : options;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: radii
          .map(
            (radius) => ChoiceChip(
              label: Text('$radius mi'),
              selected: selected == radius,
              onSelected: !enabled
                  ? null
                  : (_) {
                      if (selected != radius) onSelected(radius);
                    },
              selectedColor: DynamicColor.yellowClr,
              labelStyle: poppinsRegularStyle(
                context: context,
                fontSize: 12,
                color: selected == radius
                    ? theme.scaffoldBackgroundColor
                    : theme.primaryColor,
              ),
            ),
          )
          .toList(),
    );
  }
}
