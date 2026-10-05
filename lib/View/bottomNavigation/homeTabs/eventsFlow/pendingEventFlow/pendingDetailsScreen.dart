// ignore_for_file: prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/cancelEventWidget.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/showCustomMap.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/payment/journey/payment_journey_controller.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/eventActionBar.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/eventDetailsSections.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/model/event_counter_model.dart';
import 'package:groovkin/payment/journey/payment_journey_widgets.dart';
import 'package:groovkin/payment/payment_controller.dart';

class PendingEventDetails extends StatefulWidget {
  const PendingEventDetails({super.key});

  @override
  State<PendingEventDetails> createState() => _PendingEventDetailsState();
}

class _PendingEventDetailsState extends State<PendingEventDetails> {
  int flowBtn = Get.arguments['notInterestedBtn'];
  final TextEditingController eventReasonController = TextEditingController();
  String titleText = Get.arguments['title'];

  int eventId = Get.arguments['eventId'];

  String type = Get.arguments["type"];

  RxBool organizerFollowVal = false.obs;

  RxBool organizerGuestVal = false.obs;

  late ManagerController _controller;
  late EventController _eventController;

  late AuthController _authController;
  late HomeController _homeController;
  late PaymentController _paymentController;

  @override
  void initState() {
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
    if (Get.isRegistered<ManagerController>()) {
      _controller = Get.find<ManagerController>();
    } else {
      _controller = Get.put(ManagerController());
    }
    if (Get.isRegistered<EventController>()) {
      _eventController = Get.find<EventController>();
    } else {
      _eventController = Get.put(EventController());
    }

    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
    if (Get.isRegistered<PaymentController>()) {
      _paymentController = Get.find<PaymentController>();
    } else {
      _paymentController = Get.put(PaymentController());
    }
    // Summary load happens in pendingDetailsWidget via
    // _ensurePaymentControllerForPendingDetails (also covers Upcoming entry).
    super.initState();
  }

  Future<void> _openCounterSheet(
    BuildContext context,
    EventDetails event, {
    required bool again,
  }) async {
    await showPriceCounterSheet(
      context: context,
      agreedMinor: event.counter.currentAgreedAmountMinor ?? 0,
      currency: event.counter.currency,
      again: again,
      onSubmit: (minor, message) async {
        if (again) {
          final id = event.counter.activeCounter?.id;
          if (id == null) return false;
          return _eventController.counterAgainStructured(
            eventId: event.id!,
            counterId: id,
            proposedPrincipalMinor: minor,
            message: message,
          );
        }
        return _eventController.createStructuredCounter(
          eventId: event.id!,
          proposedPrincipalMinor: minor,
          message: message,
        );
      },
    );
  }

  Future<void> _confirmAcceptEvent(
    BuildContext context,
    ThemeData theme,
    int eventId,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Event'),
        content: const Text(
          'Accepting this event starts the existing payment flow. Continue?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue')),
        ],
      ),
    );
    if (ok == true) {
      await _controller.beginPaidEventAcceptance(eventId);
      await _eventController.eventDetails(eventId: eventId);
    }
  }

  Future<void> _confirmDecline(
    BuildContext context,
    ThemeData theme,
    int? eventId,
  ) async {
    cancelEventWidget(
      context: context,
      theme: theme,
      onTap: () async {
        Get.back();
        await _controller.eventAcceptDeclineFtn(
          status: 'declined',
          id: eventId,
        );
        if (eventId != null) {
          await _eventController.eventDetails(eventId: eventId);
        }
      },
    );
  }

  Future<void> _confirmAcceptCounter(
    BuildContext context,
    EventDetails event,
  ) async {
    final id = event.counter.activeCounter?.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Counter'),
        content: const Text(
          'This updates the agreed event price only. It does not accept the event or charge a final payment.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Accept Counter')),
        ],
      ),
    );
    if (ok == true) {
      await _eventController.acceptStructuredCounter(
        eventId: event.id!,
        counterId: id,
      );
    }
  }

  Future<void> _confirmRejectCounter(
    BuildContext context,
    EventDetails event,
  ) async {
    final id = event.counter.activeCounter?.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Counter'),
        content: const Text('Reject this proposed price? The agreed price stays the same.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reject Counter')),
        ],
      ),
    );
    if (ok == true) {
      await _eventController.rejectStructuredCounter(
        eventId: event.id!,
        counterId: id,
      );
    }
  }

  Future<void> _confirmApproveFinalPayment(
    BuildContext context,
    int eventId,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Final Payment'),
        content: const Text(
          'This charges the remaining final payment. It is not the same as accepting a Counter.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Approve')),
        ],
      ),
    );
    if (ok == true) {
      await _eventController.approveFinalPayment(eventId: eventId);
    }
  }

  Future<void> _confirmMarkComplete(
    BuildContext context,
    EventDetails event,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Complete'),
        content: const Text(
          'Mark this event complete so the venue can review final payment?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Mark Complete')),
        ],
      ),
    );
    if (ok == true) {
      Get.toNamed(Routes.completeOnGoingEventsScreen, arguments: {
        'eventData': event,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(initState: (v) {
      _eventController.eventDetails(eventId: eventId);
    }, builder: (controller) {
      if (controller.eventDetailsLoader.value == false) {
        return const SizedBox.shrink();
      }
      if (controller.eventDetailsError != null ||
          controller.eventDetail?.data == null) {
        return Scaffold(
          appBar: customAppBar(theme: theme, text: titleText),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                controller.eventDetailsError ??
                    'You do not have access to this event.',
                textAlign: TextAlign.center,
                style: poppinsRegularStyle(
                  context: context,
                  fontSize: 14,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        );
      }
      final event = controller.eventDetail!.data!;
      final flags = EventActionFlags.fromCounter(
        counter: event.counter,
        eventEnd: event.endDateTime,
      );
      return Scaffold(
          appBar: customAppBar(theme: theme, text: titleText, actions: [
            flowBtn == 1
                ? type == "event" &&
                        (API().sp.read("role") == "eventManager" &&
                            event.status != "cancelled")
                    ? IconButton(
                        onPressed: () => _showReportSheet(context),
                        icon: Icon(
                          Icons.more_vert,
                          color: theme.primaryColor,
                        ))
                    : const SizedBox()
                : const SizedBox.shrink()
          ]),
          body: pendingDetailsWidget(theme, controller, context, flowBtn,
              eventId, _controller, _authController, _homeController),
          bottomNavigationBar: EventActionBar(
            flags: flags,
            busy: controller.eventActionBusy.value,
            onAcceptEvent: () =>
                _confirmAcceptEvent(context, theme, event.id!),
            onDeclineEvent: () => _confirmDecline(context, theme, event.id),
            onCounter: () => _openCounterSheet(context, event, again: false),
            onAcceptCounter: () =>
                _confirmAcceptCounter(context, event),
            onRejectCounter: () =>
                _confirmRejectCounter(context, event),
            onCounterAgain: () =>
                _openCounterSheet(context, event, again: true),
            onEditEvent: () {
              controller.duplicateValue.value = false;
              controller.draftValue.value = false;
              controller.showEditPreviewScreen.value = true;
              controller.assignValueForUpdate();
            },
            onMarkComplete: () => _confirmMarkComplete(context, event),
            onApproveFinalPayment: () =>
                _confirmApproveFinalPayment(context, event.id!),
          ));
    });
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: eventReasonController,
                  decoration: const InputDecoration(
                    hintText: "Reason",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  borderClr: Colors.transparent,
                  heights: 35,
                  fontSized: 13,
                  onTap: () async {
                    Get.back();
                    await _authController
                        .reportAccount(
                            type: type,
                            sourceId: eventId,
                            message: eventReasonController.text)
                        .then((value) {
                      eventReasonController.clear();
                    });
                  },
                  text: "Report",
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    eventReasonController.dispose();
    super.dispose();
  }

  List list = [
    false.obs,
    false.obs,
    false.obs,
  ];
}

Widget customWidget(context, theme, {title, value}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title ?? "Event Comments",
            style: poppinsRegularStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              context: context,
              underline: true,
              color: theme.primaryColor,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: poppinsRegularStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                context: context,
                underline: true,
                color: DynamicColor.whiteClr.withValues(alpha: 0.6)),
          ),
        ),
      ),
    ],
  );
}

/// Avoids GetBuilder crash when [pendingDetailsWidget] is opened from
/// Upcoming (not only [PendingEventDetails]), where PaymentController may
/// not have been put yet. Also loads summary once per eventId.
int? _paymentSummaryLoadedForEventId;

PaymentController _ensurePaymentControllerForPendingDetails(int eventId) {
  final payment = Get.isRegistered<PaymentController>()
      ? Get.find<PaymentController>()
      : Get.put(PaymentController());
  final role = API().sp.read('role');
  if ((role == 'eventManager' || role == 'eventOrganizer') &&
      _paymentSummaryLoadedForEventId != eventId) {
    _paymentSummaryLoadedForEventId = eventId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<PaymentController>()) return;
      Get.find<PaymentController>().loadPaymentSummary(eventId);
    });
  }
  return payment;
}

Widget pendingDetailsWidget(
    ThemeData theme,
    EventController controller,
    BuildContext context,
    int flowBtn,
    int eventId,
    ManagerController _controller,
    AuthController _authController,
    HomeController _homeController) {
  final event = controller.eventDetail!.data!;
  _ensurePaymentControllerForPendingDetails(eventId);
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RefreshIndicator(
        color: DynamicColor.yellowClr,
        onRefresh: () async {
          await controller.eventDetails(eventId: eventId);
          final role = API().sp.read('role');
          if (role == 'eventManager' || role == 'eventOrganizer') {
            _paymentSummaryLoadedForEventId = eventId;
            await _ensurePaymentControllerForPendingDetails(eventId)
                .loadPaymentSummary(eventId);
          }
          if (Get.isRegistered<PaymentJourneyController>(
              tag: 'payment_journey_$eventId')) {
            await Get.find<PaymentJourneyController>(
                    tag: 'payment_journey_$eventId')
                .refreshJourney(silent: true);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              EventHeroHeader(event: event),
              const SizedBox(height: 16),
              EventPriceSummaryCard(
                counter: event.counter,
                fallbackTotal: event.totalAmount,
              ),
              ActiveCounterCard(counter: event.counter),
              EventInfoSection(
                title: 'Event Information',
                rows: {
                  'Capacity': event.maxCapacity ?? '',
                  'Venue': event.venue?.venueName ?? '',
                },
              ),
              EventInfoSection(
                title: 'Event Details',
                rows: {
                  'Featuring': event.featuring ?? '',
                  'Theme': event.themeOfEvent ?? '',
                  'Description': event.about ?? '',
                  'Comments': event.comment?.toString() ?? '',
                },
              ),
              if (!event.counter.canEditEventCost)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Event price can only be changed through Counter.',
                    style: poppinsRegularStyle(
                      context: context,
                      fontSize: 13,
                      color: DynamicColor.grayClr,
                    ),
                  ),
                ),
              CounterHistorySection(counter: event.counter),
              EventPreferencesSection(event: event),
              EventTagsSection(event: event),
              if (API().sp.read('role') == 'eventOrganizer' ||
                  API().sp.read('role') == 'eventManager')
                EventPaymentJourneySection(
                  eventId: eventId,
                  hideDuplicateActions: true,
                ),
              const SizedBox(
                height: 5,
              ),
              API().sp.read('role') == "eventManager"
                  ? const SizedBox.shrink()
                  : Obx(
                      () => _authController.followingLoader.value == false
                          ? const SizedBox.shrink()
                          : event.venue != null
                              ? aboutEventCreator(
                                  isDelete: event.venue!.user!.isDelete == null
                                      ? false
                                      : true,
                                  rowOnTap: () {
                                    Get.toNamed(Routes.viewProfileScreen,
                                        arguments: {
                                          "venueDetails": event,
                                          "venueId": controller
                                              .eventDetail!.data!.venue!.userId,
                                        });
                                  },
                                  // text: event.venue!.streetAddress.toString(),
                                  horizontalPadding: 0,
                                  theme: theme,
                                  context: context,
                                  image:
                                      event.venue!.user!.profilePicture != null
                                          ? event.venue!.user!.profilePicture!
                                              .mediaPath
                                              .toString()
                                          : groupPlaceholder,
                                  organizerName: controller
                                      .eventDetail!.data!.venue!.venueName
                                      .toString(),
                                  icons: event.venue!.user!.following == null
                                      ? Icons.check
                                      : Icons.add,
                                  followBg: event.venue!.user!.following != null
                                      ? DynamicColor.avatarBgClr
                                      : DynamicColor.grayClr,
                                  textClr: event.venue!.user!.following == null
                                      ? theme.scaffoldBackgroundColor
                                      : theme.primaryColor,
                                  text: event.venue!.user!.profile!.about
                                      .toString(),
                                  followText:
                                      event.venue!.user!.following == null
                                          ? "Follow"
                                          : "Unfollow",
                                  onTap: () {
                                    if (event.venue!.user!.following == null) {
                                      _authController.followUser(
                                          userData: controller
                                              .eventDetail!.data!.venue!.user,
                                          fromAllUser: false);
                                    } else {
                                      _authController.unfollow(
                                          userData: controller
                                              .eventDetail!.data!.venue!.user,
                                          fromAllUser: false);
                                    }
                                  })
                              : const SizedBox(),
                    ),
              API().sp.read('role') == "eventOrganizer"
                  ? const SizedBox.shrink()
                  : Obx(
                      () => _authController.followingLoader.value == false
                          ? const SizedBox.shrink()
                          : ourGuestWidget(
                              isDelete:
                                  event.user?.isDelete == null ? false : true,
                              onTap: () {
                                Get.toNamed(Routes.viewProfileScreen,
                                    arguments: {
                                      "eventDetails": event,
                                      "eventId": event.userId
                                    });
                              },
                              networkImg: event.user?.profilePicture == null
                                  ? groupPlaceholder
                                  : event.user?.profilePicture!.mediaPath
                                      .toString(),
                              venueOwner: event.user?.name.toString(),
                              theme: theme,
                              context: context,
                              horizontalPadding: 0.0,
                              rowPadding: 0.0,
                              avatarPadding: 6,
                              rowVerticalPadding: 0.0,
                              followBgClr: event.user?.following != null
                                  ? DynamicColor.grayClr
                                  : DynamicColor.avatarBgClr,
                              textClr: event.user?.following == null
                                  ? theme.primaryColor
                                  : theme.scaffoldBackgroundColor,
                              followText: event.user?.following == null
                                  ? "Follow"
                                  : "Unfollow",
                              followOnTap: () {
                                if (controller
                                        .eventDetail!.data!.user!.following ==
                                    null) {
                                  _authController.followUser(
                                      userData: event.user, fromAllUser: false);
                                } else {
                                  _authController.unfollow(
                                      userData: event.user, fromAllUser: false);
                                }
                              }),
                    ),
              if (event.location != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Location",
                      style: poppinsMediumStyle(
                          fontSize: 18,
                          context: context,
                          color: DynamicColor.lightRedClr,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      event.location!,
                      style: poppinsMediumStyle(
                        fontSize: 13,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                ShowCustomMap(
                  horizontalPadding: 2,
                  lat: double.parse(event.latitude!),
                  lng: double.parse(event.longitude!),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
}
