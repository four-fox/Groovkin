import 'package:get/get.dart';
import 'package:groovkin/Components/videoScreen.dart';
import 'package:groovkin/View/Chat/chat.dart';
import 'package:groovkin/View/GroovkinManager/addVenueItems/AddVenueScreen.dart';
import 'package:groovkin/View/GroovkinManager/addVenueDetailScreen.dart';
import 'package:groovkin/View/GroovkinManager/createCompanyProfile.dart';
import 'package:groovkin/View/GroovkinManager/manageApprovedEventScreen.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/GroovkinManager/managerUpcomingEventScreen.dart';
import 'package:groovkin/View/GroovkinManager/paymentConfirmationScreen.dart';
import 'package:groovkin/View/GroovkinManager/venueDetailsManagerFlow.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/groupFlow/groupScreen.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/groupFlow/theSquadScreen.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsScreen.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userHome.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userHomeController.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userMyGroovkinScreen.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/venueMoreImage.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/viewAllRecommendedEventScreen.dart';
import 'package:groovkin/View/GroovkinUser/linkYourAccountSurveyScreen.dart';
import 'package:groovkin/View/GroovkinUser/notifyFriendScreen.dart';
import 'package:groovkin/View/GroovkinUser/survey/quickSurveyScreen.dart';
import 'package:groovkin/View/GroovkinUser/searchFilterScreen.dart';
import 'package:groovkin/View/GroovkinUser/survey/surveyLifeStyleScreen.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userBottomNav.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/authView/forgotPassword/otpScreen.dart';
import 'package:groovkin/View/authView/forgotPassword/sendEmailScreen.dart';
import 'package:groovkin/View/authView/loginScreen.dart';
import 'package:groovkin/View/authView/newPasswordScreen.dart';
import 'package:groovkin/View/authView/sendEmailForOtpScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/ongoingEvents/ongoingEventsCompleteScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/AllUsersScreen.dart';
import 'package:groovkin/unuses/venueInfoScreen.dart';
import 'package:groovkin/View/counters/counterScreen.dart';
import 'package:groovkin/View/paymentMethod/transectionHistoryScreen.dart';
import 'package:groovkin/View/profile/createProfile.dart';
import 'package:groovkin/View/profile/createProfileController.dart';
import 'package:groovkin/View/authView/hardwareScreen.dart';
import 'package:groovkin/View/authView/insuranceScreen.dart';
import 'package:groovkin/View/authView/introPages.dart';
import 'package:groovkin/View/authView/loginOrSignUp.dart';
import 'package:groovkin/View/authView/loginSelection.dart';
import 'package:groovkin/View/authView/loginWith.dart';
import 'package:groovkin/View/profile/quickSurveyScreen.dart';
import 'package:groovkin/View/authView/serviceScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/bookingForm.dart';
import 'package:groovkin/View/bottomNavigation/settingView/bookingFormFields.dart';
import 'package:groovkin/View/bottomNavigation/settingView/followingScren.dart';
import 'package:groovkin/View/bottomNavigation/settingView/groovkinInvitesScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/myTagCollectionScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/sendInvitationScreen.dart';
import 'package:groovkin/View/bottomNavigation/settingView/venueDetailsScreen.dart';
import 'package:groovkin/View/Chat/chatRoom.dart';
import 'package:groovkin/View/eventOrganizerScreen.dart';
import 'package:groovkin/View/profile/ViewProfileScreen.dart';
import 'package:groovkin/View/switchProfileScreen.dart';
import 'package:groovkin/View/bottomNavigation/AnalyticFlowBottomBar/analyticFilter.dart';
import 'package:groovkin/View/bottomNavigation/bottomNavigation.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/cancelResonScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/commentsAndAttechment.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/confimationEvent.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/disclaimerScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/editEvent.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventPreviewScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/hardwareProvidedScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/musicChoiceView/musicChoiceScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/myEventsScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/pastEventUI/aboutEventScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/pendingDetailsScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/proposedMusicGenre.dart';
import 'package:groovkin/View/profile/editProfileScreen.dart';
import 'package:groovkin/View/bottomNavigation/notificationScreen.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/upgradeEvent.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/upcomingScreen.dart';
import 'package:groovkin/View/paymentMethod/addCardDetails.dart';
import 'package:groovkin/View/paymentMethod/paymentMethod.dart';
import 'package:groovkin/View/paymentMethod/subscriptionScreen.dart';
import 'package:groovkin/View/authView/welcomeScreen.dart';
import 'package:groovkin/View/splashScreen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: _Path.splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Path.introPages,
      page: () => IntroPages(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Path.loginSelection,
      page: () => LoginSelection(),
    ),
    GetPage(
      name: _Path.sendEmailScreen,
      page: () => SendEmailScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Path.oTPScreen,
      page: () => OTPScreen(),
      binding: AuthBinding(),
    ),
    // GetPage(
    //   name: _Path.signUpScreen,
    //   page: () => SignUpScreen(),
    // ),
    GetPage(
      name: _Path.loginWithScreen,
      page: () => LoginWithScreen(),
    ),
    GetPage(
      name: _Path.loginOrSignUpScreen,
      page: () => LoginOrSignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Path.loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Path.sendEmailForOtp,
      page: () => SendEmailForOtp(),
    ),
    GetPage(
      name: _Path.newPasswordScreen,
      page: () => NewPasswordScreen(),
    ),
    GetPage(
      name: _Path.createProfile,
      page: () => CreateProfile(),
      binding: CreateProfileBinding(),
    ),
    GetPage(
      name: _Path.welComeScreen,
      page: () => WelComeScreen(),
    ),
    GetPage(
        name: _Path.serviceScreen,
        page: () => ServiceScreen(),
        bindings: [AuthBinding(), EventBinding()]),
    GetPage(
      name: _Path.subscriptionScreen,
      page: () => SubscriptionScreen(),
    ),
    GetPage(
        name: _Path.paymentMethodScreen,
        page: () => PaymentMethodScreen(),
        binding: AuthBinding()),
    GetPage(
      name: _Path.addCardDetails,
      page: () => AddCardDetails(),
    ),
    GetPage(
      name: _Path.transactionScreen,
      page: () => TransactionScreen(),
    ),
    GetPage(
      name: _Path.viewAllCardList,
      page: () => ViewAllCardList(),
    ),
    GetPage(
      name: _Path.insuranceScreen,
      page: () => InsuranceScreen(),
    ),
    GetPage(
        name: _Path.hardwareScreen,
        page: () => HardwareScreen(),
        binding: AuthBinding()),
    GetPage(
        name: _Path.quickSurveyScreen,
        page: () => QuickSurveyScreen(),
        binding: AuthBinding()),
    // GetPage(
    //   name: _Path.homeScreen,
    //   page: () => HomeScreen(),
    // ),
    GetPage(
      name: _Path.upcomingScreen,
      page: () => UpcomingScreen(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Path.upGradeEvents,
      page: () => UpGradeEvents(),
      binding: EventBinding(),
    ),
    GetPage(
      name: _Path.hardwareProvidedScreen,
      page: () => HardwareProvidedScreen(),
    ),
    GetPage(
      name: _Path.proposedMusicScreen,
      page: () => ProposedMusicScreen(),
    ),
    GetPage(
      name: _Path.musicChoiceScreen,
      page: () => MusicChoiceScreen(),
    ),
    GetPage(
      name: _Path.eventPreview,
      page: () => EventPreview(),
    ),
    GetPage(
      name: _Path.commentsAndAttachment,
      page: () => CommentsAndAttachment(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: _Path.confirmationEventScreen,
      page: () => ConfirmationEventScreen(),
    ),
    GetPage(
      name: _Path.disclaimerScreen,
      page: () => DisclaimerScreen(),
    ),
    GetPage(
      name: _Path.editEventScreen,
      page: () => EditEventScreen(),
    ),
    GetPage(
      name: _Path.cancelReason,
      page: () => CancelReason(),
    ),
    GetPage(
      name: _Path.pendingEventDetails,
      page: () => PendingEventDetails(),
    ),
    GetPage(
      name: _Path.aboutEventScreen,
      page: () => AboutEventScreen(),
    ),
    GetPage(
      name: _Path.generateTicket,
      page: () => GenerateTicket(),
    ),
    GetPage(
      name: _Path.notificationScreen,
      page: () => NotificationScreen(),
    ),
    GetPage(
      name: _Path.myEventsScreen,
      page: () => MyEventsScreen(),
      bindings: [EventBinding(), AuthBinding()],
    ),
    // GetPage(
    //   name: _Path.myGroovkinScreen,
    //   page: () => MyGroovkinScreen(),
    // ),
    GetPage(
      name: _Path.bottomNavigationView,
      page: () => BottomNavigationView(),
      bindings: [
        HomeBinding(),
        ManagerBinding(),
        EventBinding(),
      ],
    ),
    GetPage(
      name: _Path.addMoreHardwareScreen,
      page: () => AddMoreHardwareScreen(),
    ),
    GetPage(
      name: _Path.analyticFilterScreen,
      page: () => AnalyticFilterScreen(),
    ),
    // GetPage(
    //   name: _Path.settingScreen,
    //   page: () => SettingScreen(),
    // ),
    GetPage(
      name: _Path.profileScreen,
      page: () => editProfileScreen(),
      bindings: [CreateProfileBinding(), AuthBinding()],
    ),
    GetPage(
      name: _Path.viewProfileScreen,
      page: () => ViewProfileScreen(),
    ),
    // GetPage(
    //   name: _Path.venueScreen,
    //   page: () => VenueScreen(),
    // ),
    GetPage(
      name: _Path.venueDetailsScreen,
      page: () => VenueDetailsScreen(),
    ),
    GetPage(
      name: _Path.bookingFormScreen,
      page: () => BookingFormScreen(),
    ),
    GetPage(
      name: _Path.bookingFormFields,
      page: () => BookingFormFields(),
    ),
    GetPage(
      name: _Path.groovkinInviteScreen,
      page: () => GroovkinInviteScreen(),
    ),
    GetPage(
      name: _Path.chatRoom,
      page: () => ChatRoom(),
    ),
    GetPage(
      name: _Path.chatCenterScreen,
      page: () => ChatCenterScreen(),
    ),
    GetPage(
      name: _Path.followingScreen,
      page: () => FollowingScreen(),
    ),
    GetPage(
      name: _Path.allUserScreen,
      page: () => AllUserScreen(),
    ),
    // GetPage(
    //   name: _Path.groovkinManagerScreen,
    //   page: () => GroovkinManagerScreen(),
    // ),
    GetPage(
      name: _Path.sendInvitationScreen,
      page: () => SendInvitationScreen(),
    ),
    GetPage(
      name: _Path.myTagCollection,
      page: () => MyTagCollection(),
    ),
    GetPage(
      name: _Path.myCollectionDetailsScreen,
      page: () => MyCollectionDetailsScreen(),
    ),
    GetPage(
      name: _Path.createNewTag,
      page: () => CreateNewTag(),
    ),
    // GetPage(
    //   name: _Path.viewPaymentMethod,
    //   page: () => ViewPaymentMethod(),
    // ),
    GetPage(
      name: _Path.userQuickSurveyScreen,
      page: () => UserQuickSurveyScreen(),
    ),
    GetPage(
      name: _Path.linkYourAccountSurveyScreen,
      page: () => LinkYourAccountSurveyScreen(),
    ),
    GetPage(
      name: _Path.surveyLifeStyleScreen,
      page: () => SurveyLifeStyleScreen(),
      bindings: [EventBinding(), AuthBinding()],
    ),
    GetPage(
      name: _Path.userBottomNavigationNav,
      page: () => UserBottomNavigationNav(),
      binding: UserHomeBinding(),
    ),
    GetPage(
      name: _Path.userMyGroovkinScreen,
      page: () => UserMyGroovkinScreen(),
      binding: UserHomeBinding(),
    ),
    GetPage(
        name: _Path.userEventDetailsScreen,
        page: () => UserEventDetailsScreen(),
        bindings: [
          UserHomeBinding(),
          EventBinding(),
          AuthBinding(),
        ]),
    GetPage(
      name: _Path.venueMoreImageScreen,
      page: () => VenueMoreImageScreen(),
    ),
    GetPage(
      name: _Path.eventOrganizerScreen,
      page: () => EventOrganizerScreen(),
    ),
    GetPage(
      name: _Path.searchFilterScreen,
      page: () => SearchFilterScreen(),
    ),
    GetPage(
      name: _Path.createNewGroup,
      page: () => CreateNewGroup(),
    ),
    GetPage(
      name: _Path.viewCreatedGroup,
      page: () => ViewCreatedGroup(),
    ),
    // GetPage(
    //   name: _Path.inviteFriendsInGroups,
    //   page: () => InviteFriendsInGroups(),
    // ),
    GetPage(
      name: _Path.theSquadScreen,
      page: () => TheSquadScreen(),
    ),

    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Groovkin manager
    GetPage(
      name: _Path.createCompanyProfileScreen,
      page: () => CreateCompanyProfileScreen(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: _Path.managerApprovedEventScreen,
      page: () => ManagerApprovedEventScreen(),
    ),
    GetPage(
      name: _Path.addVenueScreen,
      page: () => AddVenueScreen(),
    ),
    GetPage(
      name: _Path.addVenueDetailsScreen,
      page: () => AddVenueDetailsScreen(),
    ),
    GetPage(
      name: _Path.venuePermitDetailScreen,
      page: () => VenuePermitDetailScreen(),
    ),
    GetPage(
      name: _Path.houseEventCapabilitiesScreen,
      page: () => HouseEventCapabilitiesScreen(),
    ),
    GetPage(
      name: _Path.venueDetailsManagerScreen,
      page: () => VenueDetailsManagerScreen(),
    ),
    GetPage(
      name: _Path.paymentConfirmationScreen,
      page: () => PaymentConfirmationScreen(),
    ),
    GetPage(
      name: _Path.successPaymentScreen,
      page: () => SuccessPaymentScreen(),
    ),
    GetPage(
      name: _Path.viewOtherEventsDetails,
      page: () => ViewOtherEventsDetails(),
    ),
    GetPage(
      name: _Path.managerUpcomingEventScreen,
      page: () => ManagerUpcomingEventScreen(),
      binding: EventBinding(),
    ),
    // GetPage(
    //   name: _Path.groupScreen,
    //   page: () => GroupScreen(),
    // ),
    GetPage(
      name: _Path.groovkinPreferenceDetails,
      page: () => GroovkinPreferenceDetails(),
    ),
    GetPage(
      name: _Path.notifyScreen,
      page: () => NotifyScreen(),
    ),
    GetPage(
      name: _Path.counterScreen,
      page: () => CounterScreen(),
    ),
    GetPage(
      name: _Path.eventDetailsScreen,
      page: () => EventDetailsScreen(),
    ),
    GetPage(
      name: _Path.activityChoiceScreen,
      page: () => ActivityChoiceScreen(),
    ),
    GetPage(
      name: _Path.listOfVenuesScreen,
      page: () => ListOfVenuesScreen(),
    ),
    GetPage(
      name: _Path.addLocationScreen,
      page: () => AddLocationScreen(),
    ),
    GetPage(
      name: _Path.venueInfoScreen,
      page: () => VenueInfoScreen(),
    ),
    GetPage(
      name: _Path.switchProfileScreen,
      page: () => SwitchProfileScreen(),
    ),
    GetPage(
      name: _Path.saveHashTagScreen,
      page: () => SaveHashTagScreen(),
    ),
    GetPage(
      name: _Path.createNewHashTagScreen,
      page: () => CreateNewHashTagScreen(),
    ),
    GetPage(
      name: _Path.viewAllEventListScreen,
      page: () => ViewAllEventListScreen(),
    ),
    GetPage(
      name: _Path.cancellationReason,
      page: () => CancellationReason(),
    ),
    GetPage(
      name: _Path.videoPlayerClass,
      page: () => VideoPlayerClass(),
    ),
    GetPage(
      name: _Path.completeOnGoingEventsScreen,
      page: () => CompleteOnGoingEventsScreen(),
    ),
    GetPage(
      name: _Path.viewAllRecommendedScreen,
      page: () => ViewAllRecommendedScreen(),
    ),
    GetPage(
      name: _Path.viewAllNearByScreen,
      page: () => ViewAllNearByScreen(),
    ),
    GetPage(
      name: _Path.viewAllTopRatingScreen,
      page: () => ViewAllTopRatingScreen(),
    ),
  ];
}
