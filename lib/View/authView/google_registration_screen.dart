import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/location/location_fields.dart';
import 'package:groovkin/utils/invite_code.dart';

/// Collects role and location after Google identifies an account that is
/// not registered yet. No Groovkin session exists until register succeeds.
class GoogleRegistrationScreen extends StatefulWidget {
  const GoogleRegistrationScreen({super.key});

  @override
  State<GoogleRegistrationScreen> createState() =>
      _GoogleRegistrationScreenState();
}

class _GoogleRegistrationScreenState extends State<GoogleRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
    ensureLocationController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _auth.cancelGoogleOnboarding();
      },
      child: Scaffold(
        body: GetBuilder<AuthController>(
          builder: (controller) {
            final needsInvite = controller.activeSignupRole != null &&
                controller.activeSignupRole != 'User';
            return Form(
              key: _formKey,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/loginBg.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      GestureDetector(
                        onTap: controller.cancelGoogleOnboarding,
                        child: ImageIcon(
                          const AssetImage('assets/backArrow.png'),
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Finish signing up',
                        style: poppinsMediumStyle(
                          fontSize: 28,
                          context: context,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.emailController.text.trim().isEmpty
                            ? 'This Google account is new to Groovkin. Choose an account type and your area to continue.'
                            : '${controller.emailController.text.trim()} is new to Groovkin. Choose an account type and your area to continue.',
                        style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Account type',
                        style: poppinsMediumStyle(
                          fontSize: 14,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _roleChip(controller, 'User', 'Groovkin User'),
                      _roleChip(
                        controller,
                        'eventOrganizer',
                        'Event Organizer',
                      ),
                      _roleChip(
                        controller,
                        'eventManager',
                        'Venue Manager',
                      ),
                      const SizedBox(height: 12),
                      const LocationFields(),
                      if (needsInvite) ...[
                        const SizedBox(height: 15),
                        CustomTextFields(
                          labelText: 'Invite Code',
                          hintText: kInviteCodeHint,
                          controller: controller.inviteCodeController,
                          validationError: 'Invite code',
                          isEmail: false,
                          isInviteCode: true,
                        ),
                      ],
                      const SizedBox(height: 24),
                      CustomButton(
                        borderClr: Colors.transparent,
                        onTap: () async {
                          if (controller.googleAuthBusy) return;
                          if (!_formKey.currentState!.validate()) return;
                          await controller.completePendingGoogleRegistration(
                            context,
                          );
                        },
                        text: 'Continue',
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        borderClr: Colors.transparent,
                        backgroundClr: false,
                        onTap: controller.cancelGoogleOnboarding,
                        text: 'Cancel',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _roleChip(AuthController controller, String role, String label) {
    final selected = controller.activeSignupRole == role;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => controller.selectPendingSignupRole(role),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? DynamicColor.lightYellowClr
                  : DynamicColor.grayClr.withValues(alpha: 0.5),
            ),
            color: DynamicColor.grayClr.withValues(alpha: 0.15),
          ),
          child: Text(
            label,
            style: poppinsMediumStyle(
              fontSize: 15,
              context: context,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
