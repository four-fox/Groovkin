import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:iconsax/iconsax.dart';
import 'payment_models.dart';
import 'stripe_connect_controller.dart';
import 'stripe_connect_models.dart';

class StripeConnectBanner extends StatelessWidget {
  const StripeConnectBanner({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final controller = stripeConnectController();
    return GetBuilder<StripeConnectController>(
      init: controller,
      initState: (_) => controller.refreshConnectStatus(silent: true),
      builder: (controller) {
        if (controller.isOnboardingComplete) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: padding ?? const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: StripeConnectStatusCard(
            status: controller.status,
            role: controller.role,
            compact: true,
            onPrimaryAction: () => Get.toNamed(Routes.connectOnboardingScreen),
          ),
        );
      },
    );
  }
}

class StripeConnectStatusCard extends StatelessWidget {
  const StripeConnectStatusCard({
    super.key,
    required this.status,
    required this.role,
    this.onPrimaryAction,
    this.onRefresh,
    this.compact = false,
    this.checkingVerification = false,
  });

  final StripeConnectStatus? status;
  final StripeConnectRole role;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onRefresh;
  final bool compact;
  final bool checkingVerification;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final complete = status?.onboardingComplete == true;
    final requirementsDue = status?.requirementsDue ?? const [];

    if (checkingVerification) {
      return _card(
        context,
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: DynamicColor.yellowClr,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Checking Stripe setup...',
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 13,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (complete) {
      return _card(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.verify, color: DynamicColor.greenClr, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    StripeConnectCopy.completeTitle(role),
                    style: poppinsMediumStyle(
                      context: context,
                      fontSize: compact ? 15 : 18,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 8),
              Text(
                StripeConnectCopy.completeDescription(role),
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 13,
                  color: DynamicColor.grayClr,
                ),
              ),
              const SizedBox(height: 10),
              _detailLine(
                  context, 'Verification', connectVerificationLabel(status)),
              _detailLine(context, 'Charges enabled',
                  status?.chargesEnabled == true ? 'Yes' : 'No'),
              _detailLine(context, 'Payouts enabled',
                  status?.payoutsEnabled == true ? 'Yes' : 'No'),
              _detailLine(context, 'Requirements due', 'None'),
              _detailLine(
                context,
                'Account',
                maskConnectAccountId(status?.accountId),
              ),
            ],
            if (onRefresh != null) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onRefresh,
                  child: const Text('Refresh Status'),
                ),
              ),
            ],
          ],
        ),
      );
    }

    final title = requirementsDue.isNotEmpty
        ? 'More information required'
        : StripeConnectCopy.title(role);
    final description = requirementsDue.isNotEmpty
        ? 'Stripe still needs additional details before your account can be verified.'
        : StripeConnectCopy.description(role);

    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: poppinsMediumStyle(
              context: context,
              fontSize: compact ? 15 : 18,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            compact ? StripeConnectCopy.bannerMessage(role) : description,
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 10),
            _detailLine(
                context, 'Verification', connectVerificationLabel(status)),
            _detailLine(context, 'Charges enabled',
                status?.chargesEnabled == true ? 'Yes' : 'No'),
            _detailLine(context, 'Payouts enabled',
                status?.payoutsEnabled == true ? 'Yes' : 'No'),
            if (requirementsDue.isEmpty)
              _detailLine(context, 'Requirements due', 'None'),
            _detailLine(
              context,
              'Account',
              maskConnectAccountId(status?.accountId),
            ),
          ],
          if (requirementsDue.isNotEmpty) ...[
            const SizedBox(height: 10),
            if (!compact)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Requirements due',
                  style: poppinsMediumStyle(
                    context: context,
                    fontSize: 13,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ...requirementsDue.take(compact ? 2 : 6).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• ${StripeConnectRequirementLabel.labelFor(item)}',
                      style: poppinsRegularStyle(
                        context: context,
                        fontSize: 12,
                        color: DynamicColor.lightRedClr,
                      ),
                    ),
                  ),
                ),
            if (requirementsDue.length > (compact ? 2 : 6))
              Text(
                '• Additional verification items required',
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 12,
                  color: DynamicColor.lightRedClr,
                ),
              ),
          ],
          if (onPrimaryAction != null) ...[
            const SizedBox(height: 12),
            CustomButton(
              heights: compact ? 38 : 44,
              borderClr: Colors.transparent,
              onTap: onPrimaryAction,
              text: requirementsDue.isNotEmpty
                  ? 'Continue Stripe Setup'
                  : StripeConnectCopy.primaryButton(role),
            ),
          ],
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DynamicColor.darkGrayClr,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: DynamicColor.yellowClr.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }

  Widget _detailLine(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
          Text(
            value,
            style: poppinsMediumStyle(
              context: context,
              fontSize: 13,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class OrganizerConnectIncompleteView extends StatelessWidget {
  const OrganizerConnectIncompleteView({
    super.key,
    required this.onTryAgain,
    required this.onBack,
  });

  final VoidCallback onTryAgain;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.info_circle, color: DynamicColor.yellowClr, size: 42),
          const SizedBox(height: 14),
          Text(
            'Organizer Payment Setup Incomplete',
            textAlign: TextAlign.center,
            style: poppinsMediumStyle(
              context: context,
              fontSize: 20,
              color: theme.primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'The Event Organizer must complete their Stripe payout setup before this event can be accepted.',
            textAlign: TextAlign.center,
            style: poppinsRegularStyle(
              context: context,
              fontSize: 13,
              color: DynamicColor.grayClr,
            ),
          ),
          const SizedBox(height: 18),
          CustomButton(
            borderClr: Colors.transparent,
            onTap: onTryAgain,
            text: 'Try Again',
          ),
          const SizedBox(height: 8),
          CustomButton(
            borderClr: DynamicColor.yellowClr,
            backgroundClr: false,
            onTap: onBack,
            text: 'Back',
          ),
        ],
      ),
    );
  }
}
