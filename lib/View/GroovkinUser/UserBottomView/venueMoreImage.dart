



import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';

class VenueMoreImageScreen extends StatelessWidget {
  const VenueMoreImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Venue Image",),
      body: GridView.custom(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        gridDelegate: SliverStairedGridDelegate(
          crossAxisSpacing: 8,
          mainAxisSpacing: 0.0,
          startCrossAxisDirectionReversed: true,
          pattern: [
            const StairedGridTile(0.5, 4 / 4),
            const StairedGridTile(0.5, 4 / 4),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: DynamicColor.yellowClr)
                ),
                // padding: EdgeInsets.all(4),
                child: const Image(
                  image: AssetImage('assets/event2.png'),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
          childCount: 12,
        ),
      ),
    );
  }
}
