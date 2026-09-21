import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/model/invite_model.dart';
import 'package:groovkin/utils/backend_contract.dart';

class GroovkinInviteScreen extends StatefulWidget {
  const GroovkinInviteScreen({super.key});

  @override
  State<GroovkinInviteScreen> createState() => _GroovkinInviteScreenState();
}

class _GroovkinInviteScreenState extends State<GroovkinInviteScreen> {
  late AuthController _authController;
  final invitationForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put<AuthController>(AuthController());
    }
    _authController.resetInviteUi();
    if (API().sp.read("role") == "eventOrganizer") {
      _authController.loadInviteHistory();
    }
  }

  bool get _isEventOrganizer => API().sp.read("role") == "eventOrganizer";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<AuthController>(builder: (controller) {
      return Scaffold(
        appBar: customAppBar(
          theme: theme,
          text: "Groovkin Invites",
          onTap: () {
            controller.resetInviteUi();
            Get.back();
          },
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              controller.resetInviteUi();
              Get.back();
            }
          },
          child: Form(
            key: invitationForm,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    if (_isEventOrganizer) ...[
                      Text(
                        'Choose an invitation type',
                        style: poppinsMediumStyle(
                          fontSize: 16,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        borderClr: Colors.transparent,
                        color1: controller.selectedInviteType ==
                                kInviteTypeRegularUser
                            ? DynamicColor.blackClr
                            : DynamicColor.lightWhite,
                        color2: controller.selectedInviteType ==
                                kInviteTypeRegularUser
                            ? DynamicColor.blackClr
                            : DynamicColor.lightWhite,
                        textClr: controller.selectedInviteType ==
                                kInviteTypeRegularUser
                            ? null
                            : theme.scaffoldBackgroundColor,
                        onTap: () =>
                            controller.selectInviteType(kInviteTypeRegularUser),
                        text: "Regular User Invite",
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        borderClr: Colors.transparent,
                        color1: controller.selectedInviteType ==
                                kInviteTypeVenueManager
                            ? DynamicColor.blackClr
                            : DynamicColor.lightWhite,
                        color2: controller.selectedInviteType ==
                                kInviteTypeVenueManager
                            ? DynamicColor.blackClr
                            : DynamicColor.lightWhite,
                        textClr: controller.selectedInviteType ==
                                kInviteTypeVenueManager
                            ? null
                            : theme.scaffoldBackgroundColor,
                        onTap: () => controller
                            .selectInviteType(kInviteTypeVenueManager),
                        text: "Venue Manager Invite",
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (controller.selectedInviteType ==
                            kInviteTypeVenueManager &&
                        _isEventOrganizer)
                      CustomTextFields(
                        validationError: "email",
                        isEmail: true,
                        controller:
                            controller.venueManagerInviteEmailController,
                        labelText: "Venue Manager email",
                      )
                    else
                      CustomTextFields(
                        validationError: "email",
                        isEmail: true,
                        isOptional: true,
                        controller:
                            controller.regularUserInviteEmailController,
                        labelText: "email (optional)",
                      ),
                    const SizedBox(height: 20),
                    CustomButton(
                      borderClr: Colors.transparent,
                      color1: DynamicColor.blackClr,
                      color2: DynamicColor.blackClr,
                      onTap: controller.inviteUiState == InviteUiState.loading
                          ? () {}
                          : () {
                              if (controller.selectedInviteType ==
                                      kInviteTypeVenueManager &&
                                  _isEventOrganizer) {
                                if (invitationForm.currentState!.validate()) {
                                  controller.createVenueManagerInvite();
                                }
                              } else {
                                controller.createRegularUserInvite();
                              }
                            },
                      text: controller.inviteUiState == InviteUiState.loading
                          ? "Creating..."
                          : "Create Invite",
                    ),
                    if (controller.inviteError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        controller.inviteError!,
                        style: poppinsRegularStyle(
                          fontSize: 13,
                          context: context,
                          color: DynamicColor.lightRedClr,
                        ),
                      ),
                    ],
                    if (controller.inviteUiState == InviteUiState.success &&
                        controller.lastCreatedInvite != null)
                      _InviteSuccessCard(
                        invite: controller.lastCreatedInvite!,
                        theme: theme,
                      ),
                    if (controller.inviteHistory.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Recent invites',
                        style: poppinsMediumStyle(
                          fontSize: 16,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...controller.inviteHistory.take(8).map(
                            (invite) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '${invite.inviteType ?? ''} • ${invite.email ?? 'no email'} • ${invite.status ?? ''}',
                                style: poppinsRegularStyle(
                                  fontSize: 12,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _InviteSuccessCard extends StatelessWidget {
  const _InviteSuccessCard({
    required this.invite,
    required this.theme,
  });

  final InviteRecord invite;
  final ThemeData theme;

  Future<void> _copy(String? value, String label) async {
    if (value == null || value.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: value));
    bottomToast(text: '$label copied');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: DynamicColor.grayClr.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite created successfully',
              style: poppinsMediumStyle(
                fontSize: 16,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            if (invite.code != null)
              Text(
                'Code: ${invite.code}',
                style: poppinsRegularStyle(
                  fontSize: 14,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
            if (invite.expiresAt != null)
              Text(
                'Expires: ${invite.expiresAt}',
                style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: DynamicColor.grayClr,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              invite.emailSent
                  ? 'Invitation email was sent.'
                  : (invite.emailError ??
                      'Invite created successfully, but email could not be sent. You can copy and share the invite code manually.'),
              style: poppinsRegularStyle(
                fontSize: 12,
                context: context,
                color: invite.emailSent
                    ? DynamicColor.greenClr
                    : DynamicColor.lightYellowClr,
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              borderClr: Colors.transparent,
              color1: DynamicColor.blackClr,
              color2: DynamicColor.blackClr,
              onTap: () => _copy(invite.code, 'Invite code'),
              text: "Copy Code",
            ),
            const SizedBox(height: 10),
            CustomButton(
              borderClr: Colors.transparent,
              backgroundClr: false,
              color1: DynamicColor.lightWhite,
              color2: DynamicColor.lightWhite,
              textClr: theme.scaffoldBackgroundColor,
              onTap: () => _copy(
                invite.shareText ?? invite.code,
                'Invite text',
              ),
              text: "Copy Invite Text",
            ),
          ],
        ),
      ),
    );
  }
}

class UserClass {
  String? name;
  RxBool? selectedVal = false.obs;
  TextEditingController emailController = TextEditingController();
  UserClass({this.name, this.selectedVal, required this.emailController});
}
