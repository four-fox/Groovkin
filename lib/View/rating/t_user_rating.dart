import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/t_rounded_container.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

class UserRating extends StatelessWidget {
  const UserRating({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // ! profile of rating user
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                // CircleAvatar(
                //   backgroundImage: AssetImage(TImageString.userImage),
                // ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
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
              rating: 4,
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
              "03 March, 2024",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        const SizedBox(
          height: 16,
        ),
        ReadMoreText(
          "The user inteface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great Job!",
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shahzain Store",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "03 March 2024",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ReadMoreText(
                  "The user inteface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great Job!",
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
