import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/t_rounded_container.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

class UserRating extends StatelessWidget {
  final String image, description, date, name;
  final double ratingNum;
  const UserRating({
    super.key,
    required this.image,
    required this.description,
    required this.date,
    required this.name,
    required this.ratingNum,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ! profile of rating user
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(image),
                ),
                SizedBox(
                  width: 16,
                ),
                // Text(
                //   name,
                //   style: Theme.of(context).textTheme.bodyMedium,
                // ),
              ],
            ),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        // ! Review
        Row(
          children: [
            RatingBarIndicator(
              itemSize: 20,
              rating: ratingNum,
              itemBuilder: (context, index) {
                return Icon(
                  Iconsax.star1,
                  color: DynamicColor.yellowClr,
                );
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              date,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        const SizedBox(
          height: 16,
        ),
        ReadMoreText(
          description,
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: " show less",
          trimCollapsedText: " show more",
          moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: DynamicColor.yellowClr),
          lessStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: DynamicColor.yellowClr),
        ),
        const SizedBox(
          height: 16,
        ),
        TRoundedContainer(
          backgroundColor: dark ? Color(0xFF4F4F4F) : Color(0xFFEDEDED),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ReadMoreText(
                  description,
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: " show less",
                  trimCollapsedText: " show more",
                  moreStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: DynamicColor.yellowClr),
                  lessStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: DynamicColor.yellowClr),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
