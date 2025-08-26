import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/View/rating/over_all_rating.dart';
import 'package:groovkin/View/rating/t_user_rating.dart';
import 'package:iconsax/iconsax.dart';

class EventRating extends StatefulWidget {
  const EventRating({super.key});

  @override
  State<EventRating> createState() => _EventRatingState();
}

class _EventRatingState extends State<EventRating> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: customAppBar(
        text: "View Rating",
        backArrow: false,
        theme: theme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ratings and reviews are verified and are from people who use the same type of device that you use.",
              ),
              const SizedBox(
                height: 24.0,
              ),
              // ! Overall Product Ratings
              const OverAllProductRating(),
              RatingBarIndicator(
                itemSize: 20,
                rating: 4,
                itemBuilder: (context, index) {
                  return Icon(
                    Iconsax.star1,
                    color: DynamicColor.yellowClr,
                  );
                },
              ),
              Text(
                "13,411",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(
                height: 16.0,
              ),
              const UserRating(),
              const UserRating(),
            ],
          ),
        ),
      ),
    );
  }
}
