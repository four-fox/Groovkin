The Flutter app has an organizer Analytics tab and a RevenueCat purchase screen. It does not implement Basic versus Advanced Organizer Analytics, and it unlocks Premium on the device before Laravel verifies a production store subscription.

This audit is read-only. No project files were edited, and no purchases or production APIs were called. The Laravel backend is not in this repository, so new organizer-analytics and entitlement routes are NOT VERIFIED.

1. Executive Summary
   CONFIRMED FROM SOURCE. Groovkin Flutter is a GetX application. Organizers land in BottomNavigationView, whose third tab is AnalyticPortalScreen. That screen loads genre counts from GET show-analytics-chart and GET show-analytics-list. It then hides the whole portal until either RevenueCat says the premium entitlement is active, or the user taps “Enjoy Your Free Subscription,” which writes eo_phase1_free_subscription into on-device storage.

CONFIRMED FROM SOURCE. Store purchase uses RevenueCat (purchases_flutter 10.14.0). After a successful purchase, the app sets appData.entitlementIsActive from RevenueCat and only then posts {"id": planType} to POST subscription. That body has no purchase token, transaction id, receipt, or environment. A second, unused in_app_purchase client treats verification as always true.

MISSING. There is no Basic versus Advanced analytics split, no event views, impressions, engagement, conversions, registrations, bookings, audience insights, or date-range filters tied to real data. There is no Laravel entitlement check, no sandbox-versus-production check, and no UTC entitlement decision.

NOT VERIFIED. Google Play Console products, App Store Connect products, and the production Laravel routes at db1215bc9b98260accce324830a11ca71f243426. This Flutter repo has no production branch. Its remote is git@github.com:four-fox/Groovkin.git, not the Bitbucket backend.

2. Flutter Architecture and Environment
   Item	Status	Evidence
   Dart SDK constraint
   CONFIRMED
   pubspec.yaml lines 8–9: >=3.6.0 <4.0.0
   Installed toolchain on this machine
   CONFIRMED
   Flutter 3.47.6, Dart 3.13.5. Tests were not run
   Project template revision
   CONFIRMED
   .metadata revision ea121f8859e4b13e47a8f845e4586164519588bc
   Architecture
   CONFIRMED
   GetX (get 4.7.3). Controllers are GetxController. Navigation is GetMaterialApp / GetPage. No Bloc, Riverpod, Provider, or Redux in pubspec.yaml
   HTTP
   CONFIRMED
   Singleton API in lib/Components/Network/API.dart using Dio 5.11.1
   App version
   CONFIRMED
   pubspec.yaml line 6: 1.0.0+38
   Android application ID
   CONFIRMED
   android/app/build.gradle.kts lines 21 and 40: com.gologonow.groovkin
   iOS bundle ID
   CONFIRMED
   ios/Runner.xcodeproj/project.pbxproj lines 422, 559, and 590: com.gologonow.groovkinn (extra n)
   macOS bundle ID
   CONFIRMED
   macos/Runner/Configs/AppInfo.xcconfig line 11: com.gologonow.groovkin
   API base URL
   CONFIRMED
   lib/Components/Network/Url.dart lines 9–11. One hardcoded host: https://groovkin.gologonow.app/api/
   Flavors
   MISSING
   No productFlavors in the app Gradle file. No environment switch
   Git
   CONFIRMED
   Branch feature/discovery-v2-flutter, HEAD de4a05dd02cb2bc4f875457b7ecd9fa6916a82c4. No local or origin/production branch. Default remote branch is origin/master
   Working tree
   CONFIRMED
   android/local.properties differs from HEAD only in local SDK paths and flutter.buildMode (release in git, debug locally). No application source was changed by this audit
   State and auth. Tokens live in GetStorage under token. API sends Authorization: Bearer <token> on authenticated calls (API.dart lines 54–56 and 110–111). Connect timeout and receive timeout are 180 seconds (lines 32–33). A 401 with message Unauthenticated. erases storage and sends the user to login (lib/Components/Network/interceptors_service.dart lines 26–34). returnResponse in lib/Components/Network/ErrorMethod.dart lines 26–34 also erases storage on that message, without the same navigation. Logout posts logout, then erases storage (lib/View/authView/autController.dart lines 1573–1588).

Roles. Storage roles are User, eventOrganizer, and eventManager. lib/utils/backend_contract.dart maps eventOrganizer to backend event_owner. Organizers with an event open Routes.bottomNavigationView (autController.dart lines 842–851). Users open Routes.userBottomNavigationNav (lines 831–840). The user shell has Home, My Events, Invites, and Settings. It has no Analytics tab (lib/View/GroovkinUser/UserBottomView/userBottomNav.dart lines 36–41).

Billing and chart packages, resolved from pubspec.lock.

purchases_flutter 10.14.0, iOS RevenueCat 5.92.0 / PurchasesHybridCommon 19.5.0 (ios/Podfile.lock)
in_app_purchase 3.3.1, Android plugin 0.5.3, StoreKit plugin 0.4.13
syncfusion_flutter_charts 33.2.10, fl_chart 1.2.0, material_charts 0.0.39
CONFIRMED dependency constraint: both billing plugins are registered. android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java registers InAppPurchasePlugin (line 129) and PurchasesFlutterPlugin (line 164). RevenueCat’s Android Gradle selects Billing Client dimension bc8 (purchases_flutter 10.14.0 android/build.gradle lines 39–46, plugin cache). in_app_purchase_android 0.5.3 depends on com.android.billingclient:billing:8.0.0. The live UI never calls InAppPurchased. INFERRED: two Billing Clients are packaged; only RevenueCat is used.

fl_chart has no Dart usage. material_charts is imported by the analytics screen and the chart style is never built. Syncfusion draws the live chart.

Android minSdk is flutter.minSdkVersion, not a literal in this repo. The RevenueCat plugin sets minSdkVersion 21. The resolved app minSdk is NOT VERIFIED. iOS deployment target is 15.0 in ios/Podfile line 1, and 15.6 on the Runner targets in project.pbxproj. StoreKit.framework is linked. ios/configuration.storekit is copied into the app resources (project.pbxproj line 223).

3. Existing Analytics UI Inventory
   Feature	Status	Data source	Where
   Organizer shell / home
   PARTIAL
   Event APIs, not analytics
   lib/View/bottomNavigation/bottomNavigation.dart lines 54–62; lib/View/bottomNavigation/homeScreen.dart
   Analytics tab
   IMPLEMENTED for organizer and any non-manager role on that shell
   —
   bottomNavigation.dart lines 59–61 and 157–159. Managers see “My Events” instead
   Basic genre chart
   PARTIAL
   Live GET show-analytics-chart when HTTP 200
   lib/View/bottomNavigation/AnalyticFlowBottomBar/AnalyticPortal.dart lines 118–156; homeController.dart lines 596–601; model lib/model/analytic_model.dart (genre, count)
   Basic genre list
   PARTIAL
   Live GET show-analytics-list when HTTP 200
   AnalyticPortal.dart lines 158–301; homeController.dart lines 606–611; model lib/model/analytic_list_model.dart
   Advanced / event performance
   MISSING
   —
   No views, impressions, engagement, conversions, registrations, bookings, or audience models
   Date-range filter
   MISSING
   —
   No query parameters on the analytics calls
   Free versus Premium presentation
   PARTIAL and locally bypassed
   Device flag or RevenueCat
   AnalyticPortal.dart lines 16–17, 40–41, 305–308, 375–455
   Upgrade prompt
   PARTIAL
   Hardcoded copy. Button does nothing
   AnalyticPortal.dart lines 396–412, onPressed: null
   Empty state
   PARTIAL
   List only: “No Analytic Found!”
   AnalyticPortal.dart lines 159–164
   Loading state
   PARTIAL
   Global Dio loader, not a screen state
   API.dart lines 60–62
   Error / retry
   MISSING
   Force-unwrap can throw if the model or data is null
   AnalyticPortal.dart lines 72–81
   Filter screen
   PARTIAL
   Hardcoded chips. Apply only calls Get.back()
   lib/View/bottomNavigation/AnalyticFlowBottomBar/analyticFilter.dart lines 12–547. Route /AnalyticFilterScreen (app_routes.dart line 189). Not opened from the live portal
   Demo “event analytics”
   PARTIAL
   Hardcoded Rock 60%, Classical 30%, Disco 10%
   analyticFilter.dart lines 550–669. Route /EventDetailsScreen (app_pages.dart lines 527–529). The portal navigation is commented out (AnalyticPortal.dart line 183)
   The portal comment at AnalyticPortal.dart lines 16–17 says Phase-1 organizer analytics is free. Tapping “Enjoy Your Free Subscription” (lines 89–94 and 437–454) sets the storage flag and removes the blur. That is a local grant, not a backend entitlement.

4. Analytics API Integration Matrix
   Client paths below are CONFIRMED FROM SOURCE as strings the app calls. Whether production Laravel at db1215bc still serves them is NOT VERIFIED. No new organizer-analytics paths appear in this repo, so those cells stay UNVERIFIED. No mutating requests were sent.

Feature	Flutter screen	Flutter service	Backend endpoint	Integration status	Missing work
Organizer home
HomeScreen inside /BottomNavigationView
HomeController event methods
UNVERIFIED for analytics. Existing event calls are separate
PARTIAL
This is not an analytics dashboard
Genre chart
AnalyticPortalScreen
HomeController.getAllAnalyticsData
GET show-analytics-chart
PARTIAL
Confirm the route still exists. It returns genre counts, not event performance
Genre ranking list
AnalyticPortalScreen
HomeController.getAllAnalyticsListData
GET show-analytics-list
PARTIAL
Same. No date, event, or tier parameters
Basic Organizer Analytics as specified
None
None
UNVERIFIED
MISSING
Need the deployed contract before wiring
Advanced Organizer Analytics
None
None
UNVERIFIED
MISSING
Need the deployed contract and a Premium gate driven by Laravel
Subscription catalog
SubscriptionScreen
SubscriptionController.getSubscription
GET subscription-list
PARTIAL
Call is commented out (subscriptionScreen.dart lines 31–33). UI prices are hardcoded
Record a plan after purchase
SubscriptionScreenTwo
AuthController.completePurchase
POST subscription with {"id": planType}
PARTIAL
Not store verification. No token, receipt, transaction id, or environment
Read Premium entitlement from Laravel
None
None
UNVERIFIED
MISSING
App never reads a server entitlement for Premium
Event payments / Connect / wallet
Separate payment screens
lib/payment/*
Stripe journey docs under docs/
IMPLEMENTED for event payments
Do not reuse this as organizer Premium verification
Auth header, 401 logout, and 180-second timeouts are the shared client behavior in API.dart and interceptors_service.dart. PrettyDioLogger logs request headers and response bodies (API.dart lines 36–41). The interceptor also logs response.data (interceptors_service.dart line 45).

Backend evidence required: the route list and JSON samples from Laravel commit db1215bc9b98260accce324830a11ca71f243426 for basic analytics, advanced analytics, and the entitlement object, including the exact Premium, expiry, environment, and revocation fields.

5. Google Play Billing Audit
   CONFIRMED

Permission com.android.vending.BILLING is in android/app/src/main/AndroidManifest.xml line 7.
Application ID is com.gologonow.groovkin.
Release signing reads key.properties (build.gradle.kts lines 49–64). Those values were not opened.
Live purchases go through RevenueCat, configured for Play Store in lib/main.dart lines 108–113 and 49–55, with PurchasesAreCompletedByRevenueCat.
Android purchase uses the first subscription option of a reversed RevenueCat package (subscription_screen_two.dart lines 222–252). There is no named base plan or offer id.
Product strings in source: rc_premium_month:monthly (line 384), and unused rc_premium_month / rc_premium_year in lib/payment/in_app_purchased.dart line 27.
Management opens Play subscriptions with the stored product id and package com.gologonow.groovkin (subscription_screen_two.dart lines 659–664).
Display prices $2.99 and $29.99 are hardcoded (lines 70–82 and 604–606), not taken from Play product details.
MISSING in the live path

Pending-purchase UI, grace period, billing retry, revocation, and renewal listener (Purchases.addCustomerInfoUpdateListener does not appear).
Purchase acknowledgement in Dart. RevenueCat is configured to complete purchases.
Server verification of the Play purchase token.
Sandbox versus production handling.
CONFIRMED unsafe / dead client. InAppPurchased is never referenced outside its own file. If called, _verifySubscription and _verifyPurchased return true (in_app_purchased.dart lines 155–160), then the purchase is completed locally (lines 135–136). It also registers two listeners on the same stream (lines 65–92).

Play Console product activation, base plans, offers, license testers, and service-account credentials are NOT VERIFIED. Identifiers in source are not evidence that products exist.

6. Apple Billing Audit
   CONFIRMED

StoreKit is linked. Deployment target is 15.6 on Runner. Pod platform is 15.0.
RevenueCat is configured with the Apple store in main.dart lines 109–110.
iOS purchase uses PurchaseParams.package on the non-reversed package list (subscription_screen_two.dart lines 254–280). Android uses the reversed list and subscriptionOptions[0].
Status text treats an active subscription id of rc_monthly as monthly (lines 387–391).
Local StoreKit file ios/configuration.storekit defines one recurring product: rc_monthly, display price 2.99, period P1M, group name subscription, local group id D7B7B134 (lines 71–108). Introductory offer id is free_trial with a trailing space (line 83), period P2W.
Restore button calls AuthController.restore() (lines 301–302).
Cancel on iOS is a dialog telling the user to use Settings (subscription_screen_two.dart lines 665–682). It does not open the App Store subscription management URL.
completePurchase is shared with Android and posts only a plan integer.
MISSING

App Store Server API calls, receipt or transaction handoff, transaction finish in the live RevenueCat path, grace period, revocation, and a yearly product in the local StoreKit file.
Any code that reads StoreKit environment.
NOT VERIFIED. App Store Connect subscription group, product approval, sandbox testers, and server notification endpoint. The local .storekit file is an Xcode test configuration, not Connect.

CONFIRMED platform split. Android expects rc_premium_month:monthly. iOS expects rc_monthly. The unused billing class expects rc_premium_month and rc_premium_year. Bundle IDs also differ: Android com.gologonow.groovkin, iOS com.gologonow.groovkinn.

7. Premium Entitlement Security Findings
   Premium is decided on the device. Laravel is not the authority.

Decision source	What the code does	Status
RevenueCat premium
appData.entitlementIsActive is set from customerInfo.entitlements
CONFIRMED lib/utils/constant.dart line 2; lib/model/single_ton_data.dart line 4; main.dart lines 82–83; autController.dart lines 3361–3363; subscription_screen_two.dart lines 243–250 and 270–278
Local preference
eo_phase1_free_subscription == true unlocks the analytics portal with no network call
CONFIRMED AnalyticPortal.dart lines 40–41 and 89–91
Purchase callback before server success
The flag is set, then completePurchase is called. A failed POST subscription does not clear the flag
CONFIRMED subscription_screen_two.dart lines 246–250 and 273–278; autController.dart lines 3255–3285
Hardcoded role
Organizer role does not itself set Premium. It only shows the Subscription settings row
CONFIRMED settingScreen.dart lines 341–365
Backend entitlement field
No reader
MISSING
completePurchase (autController.dart lines 3266–3282) stores identifier, maps the product id with contains("monthly") or contains("yearly"), and posts {"id": 0|1|2}. rc_premium_month and rc_premium_year do not contain those substrings, so they stay 0. rc_monthly and rc_premium_month:monthly become 1. The string RevenueCat actually returns at runtime is NOT VERIFIED.

Risk checks:

Local Premium before verification. CONFIRMED. RevenueCat isActive and the Phase-1 storage flag both unlock UI. The API body cannot prove a store purchase.
Sandbox treated as entitlement. CONFIRMED on the client. No environment check. A sandbox or local StoreKit purchase that RevenueCat marks active sets the same flag used for Premium. Production’s rejection of sandbox purchases cannot be enforced by this client.
Expired or revoked access. PARTIAL. The live flag follows RevenueCat isActive only at startup, login, and the subscription screens. There is no customer-info listener, so expiry while the app stays open is not applied. The minute check in restore() (autController.dart lines 3303–3312) only chooses a toast. It uses toLocal(), not UTC, and does not change entitlementIsActive. Revocation and grace period are MISSING.
Stale Premium after logout. CONFIRMED. logout() and logOutRevenuecat() (autController.dart lines 1573–1588 and 3343–3351) never set entitlementIsActive = false. The field is an in-memory singleton.
Cross-account leak. CONFIRMED structure. Login starts restore(), logInWithRevenueCat(), and checkUserSubscriptionIsActive() without awaiting them (autController.dart lines 811–815). GetStorage is not partitioned by user. Profile switch (autController.dart lines 2428–2438) does not clear the analytics flag. Logout does erase storage, so the Phase-1 key is removed only when logout succeeds.
Sensitive logging. CONFIRMED. Purchases.setLogLevel(LogLevel.debug) runs in every build (main.dart line 50). completePurchase logs the full CustomerInfo (line 3256). Dio logs headers, which include the bearer token. The product id is written to storage as identifier (line 3268).
Restore is inverted. CONFIRMED. restore() calls Purchases.restorePurchases() only when RevenueCat already reports an active entitlement (lines 3295–3299). A user with no local entitlement never restores. App start calls this whenever userId is set (main.dart lines 170–171), and checkSub shows a toast (lines 3336–3340).
Repeated listeners. CONFIRMED only in unused InAppPurchased. The live RevenueCat path has no Dart purchase stream. MISSING deduplication of POST subscription.
Duplicate verification. The live path does not verify. It posts a plan id after already unlocking.
Time zone. CONFIRMED the only expiry comparison uses local time and does not gate access. Display dates use DateTime.parse plus DateFormat (subscription_screen_two.dart lines 532–571).
Secrets observed and omitted from this report. A tracked Apple private key file, SubscriptionKey_ D5FF3A8C.p8, is in git. ios/configuration.storekit lines 116–118 contain a subscriptionOffersKeyPair private key for key id D5FF3A8C, and that file is in the iOS app bundle. lib/utils/constant.dart contains RevenueCat SDK keys (lines 5 and 8) and a third-party client secret (line 21). AndroidManifest.xml line 72 contains a Google API key. Those values should be rotated outside this audit. They are not repeated here.

8. Organizer User Journey Gaps
   Step	What exists	Gap
   Organizer login
   login() writes the Sanctum token and, when an event exists, opens /BottomNavigationView (autController.dart lines 842–851)
   Subscription refresh races the navigation and does not wait for Laravel
   First-time organizer
   Login with is_event_created == 0 opens the service screen (lines 845–847). Welcome opens /SubscriptionScreen (welcomeScreen.dart lines 111–112). Subscription Skip also opens the service screen (subscriptionScreen.dart lines 66–69)
   Two different entry paths. Subscription is skippable
   Dashboard
   Home tab, index 0
   No analytics summary on the dashboard
   Basic Analytics
   Analytics tab, index 2, back arrow disabled (AnalyticPortal.dart line 111)
   Whole portal is blurred until a local grant. Data is genre counts. No retry
   Advanced Analytics
   MISSING
   No route, screen, or locked section
   Premium upgrade
   Settings → /SubscriptionScreen for organizers (settingScreen.dart lines 341–349). Portal “Subscribe Now” is disabled
   Portal does not navigate to the paywall
   Store purchase
   SubscriptionScreenTwo inside the subscription screen
   Hardcoded plans. Android and iOS select different package indexes. Offerings can be null and the button does not guard that
   Server verification
   POST subscription with a plan integer
   Purchase token is never sent. UI is already Premium
   Premium access
   In-memory RevenueCat flag, plus the analytics storage bypass
   Restart restores RevenueCat only if userId is present (main.dart lines 170–171). It does not ask Laravel
   Subscription management
   “Active Subscription” only if the RevenueCat flag is true (settingScreen.dart lines 352–364). Screen is SubscrptionScreenCheck
   Price and plan labels are hardcoded. Android opens Play. iOS shows instructions. No refresh on resume
   Back from the root shell asks to exit the app (bottomNavigation.dart lines 67–79). Filter Apply only pops. There is no analytics state restoration beyond GetStorage and RevenueCat’s own cache.

9. Store and Backend Configuration Requirements
   Item	Status
   Android package com.gologonow.groovkin
   VERIFIED in Gradle
   iOS bundle com.gologonow.groovkinn
   VERIFIED in the Xcode project. It does not match Android
   Product ids in Flutter/StoreKit config
   VERIFIED as source strings only: premium, rc_monthly, rc_premium_month, rc_premium_year, rc_premium_month:monthly
   Subscription group / base plan in App Store Connect or Play Console
   UNVERIFIED
   Local StoreKit group subscription / rc_monthly
   VERIFIED in ios/configuration.storekit. Not Connect
   Store products active for sale
   UNVERIFIED
   License / sandbox testers
   UNVERIFIED
   RevenueCat project, offering, and premium entitlement dashboard
   UNVERIFIED. Client entitlement id is premium
   Play service account and App Store Server API credentials on Laravel
   UNVERIFIED. Not present in this Flutter repo
   Store server notifications
   UNVERIFIED / MISSING in Flutter
   Production release readiness
   MISSING. Single production API URL, no staging flavor, client grants Premium locally
   Separate staging backend for sandbox
   MISSING and required. This app can only talk to https://groovkin.gologonow.app/api/
   Sandbox purchases must be tested against a staging Laravel environment. The production policy that rejects sandbox entitlements should stay unchanged.

10. Testing Coverage and Limitations
    test/ has contract, payment, discovery, and profile tests. A search of test/ for analytics, entitlement, subscription, Purchases, and in-app purchase returned no matches.

Case	Coverage
Analytics API parsing
MISSING
Basic versus Premium
MISSING
Valid, expired, canceled-but-still-entitled, and revoked subscriptions
MISSING
Purchase failure, cancellation, pending, duplicate callbacks, restore
MISSING
Offline / reconnect
MISSING for this feature. Dio can return status 0 on getApi network failure (API.dart lines 76–88). Analytics does not handle it
Logout / login entitlement
MISSING
Android versus iOS
MISSING
Flutter 3.47.6 and Dart 3.13.5 are installed. The suite was not executed. flutter pub get and flutter pub upgrade were not run. Laravel source was not available locally, so endpoint behavior was not compared with commit db1215bc.

11. Phase 5A / 5B / 5C Implementation Roadmap
    PHASE 5A — Flutter Analytics UI and API Integration
    Complexity: MEDIUM.

Tasks:

Take the analytics and entitlement JSON from the deployed Laravel commit before adding client paths.
Add models for basic metrics and, separately, advanced metrics. Keep genre AnalyticsModel only if those old routes are still part of basic analytics.
Load basic analytics for every organizer without the storage bypass.
Call advanced analytics only after Laravel says Premium is valid. Show the existing locked card when it is not, and point “Subscribe Now” at the current subscription screen.
Add loading, empty, error, and retry states around the current Syncfusion chart and list.
Leave AnalyticFilterScreen unused until a real filter API exists. Its chips are demo data.
Remove eo_phase1_free_subscription as an access grant.
Reuse: AnalyticPortalScreen, HomeController request style, API.getApi, customAppBar, DynamicColor, Poppins text styles, and the blur overlay in notSubscribeCardWidget.

Likely new files: an analytics repository and basic/advanced models. A small entitlement model once the server field names are known.

Backend dependency: the real route paths and JSON from db1215bc. Do not guess them.

Store dependency: none for basic analytics.

Risk: building on show-analytics-chart if production has already replaced it. The chart force-unwrap will crash on a null body.

Acceptance: an organizer sees basic data from the server with no local flag; advanced data stays hidden unless the Laravel payload grants Premium; failed requests can be retried; logout clears the in-memory grant.

PHASE 5B — Google Play / Apple Billing Configuration and Purchase Integration
Complexity: HIGH.

Tasks:

Choose one billing stack. The live stack is RevenueCat. Remove or stop registering the unused in_app_purchase path so its always-true verifier cannot be called.
Align application id, bundle id, product ids, base plans, and the RevenueCat premium entitlement with the consoles. Resolve groovkin versus groovkinn before any store build.
Load prices from the store. Stop showing hardcoded $2.99 / $29.99 as the charged price.
On purchase, send the store transaction proof to Laravel and set Premium only from the Laravel response. Keep the production rule that sandbox receipts do not grant Premium.
Clear appData.entitlementIsActive on logout, 401, and account switch. Refresh it from Laravel on launch and resume.
Fix restore so it runs when the user is not already active, and stop toasting on every cold start.
Use UTC for any client expiry display. Do not let that display grant access.
Rotate the committed .p8 and the StoreKit offers private key, and remove them from the app bundle and git history under a separate security change.
Add a staging base URL. Do not point sandbox builds at production.
Reuse: SubscriptionScreen, SubscriptionScreenTwo, settings rows, and configureSDK if RevenueCat remains the store client.

Likely new files: a purchase-verification service and an entitlement repository. Staging URL configuration.

Backend dependency: the verification endpoint and the entitlement resource from the deployed backend.

Store dependency: Play Console app, base plans, and testers; App Store Connect group, products, and sandbox testers; RevenueCat offering if that remains the client.

Risk: two Billing Clients, mismatched product ids, and a client that currently treats every active RevenueCat entitlement as production Premium.

Acceptance: a production purchase stays locked until Laravel returns a verified, unexpired production entitlement; a sandbox purchase against production does not unlock Premium; logout and account switch cannot show the previous user’s Premium; restore recovers a verified subscription.

PHASE 5C — End-to-End QA, Internal Testing, and Release Readiness
Complexity: HIGH.

Tasks:

Add unit tests for entitlement parsing, plan-id mapping, and the analytics empty/error states.
Add widget tests for the free portal, the locked advanced state, purchase cancel, and logout.
Run internal testing on a staging backend: Play license testers and App Store sandbox, including expiry, cancel-with-time-remaining, revoke, pending, restore, and offline.
Confirm server notifications on the staging backend.
Ship to production stores only after staging proves the client cannot unlock Premium by itself.
Reuse: existing test/ style in backend_contract_test.dart and payment_models_test.dart.

Risk: the only configured API host is production, and production must keep rejecting sandbox entitlements.

Acceptance: the cases in section 10 exist as tests or a written staging run; no sandbox account gains Premium on production; basic analytics works without a subscription.

12. Critical, High, Medium, and Low Findings
    Critical

Premium is granted from RevenueCat and from eo_phase1_free_subscription without a Laravel verification result (AnalyticPortal.dart lines 40–41 and 89–91; subscription_screen_two.dart lines 246–250).
POST subscription sends only a plan integer (autController.dart lines 3281–3282), so the client cannot satisfy the production store-verification policy.
An Apple private key is tracked at SubscriptionKey_ D5FF3A8C.p8, and another private key is inside ios/configuration.storekit, which is packaged into the iOS app. Values omitted.
High

entitlementIsActive survives logout and can race the next account (single_ton_data.dart line 4; autController.dart lines 811–815 and 3343–3351).
Restore runs only when already subscribed, and it toasts on launch (autController.dart lines 3295–3311; main.dart lines 148–151).
Android and iOS product ids and bundle ids do not match.
in_app_purchase is registered and its verifier returns true (in_app_purchased.dart lines 155–160).
Bearer tokens and RevenueCat customer objects are logged (API.dart lines 36–41; main.dart line 50; autController.dart line 3256).
No staging flavor. The only API host is production (Url.dart lines 9–11).
Medium

Analytics is a genre chart, not organizer event analytics, and the advanced tier is absent.
“Subscribe Now” is disabled. The paywall is only in Settings.
Filter and /EventDetailsScreen use hardcoded demo content.
Chart loading force-unwraps the model (AnalyticPortal.dart lines 77–80).
Expiry is not watched during the session and is not evaluated in UTC.
First-time organizers can skip subscription, and login does not even open it when is_event_created == 0.
Low

fl_chart is unused. The material_charts style in AnalyticPortal.dart lines 315–331 is unused.
GET subscription-list is commented out.
Subscription marketing copy is placeholder text (subscriptionScreen.dart lines 152–168).
InAppPurchased would attach two listeners if it were ever constructed.
13. Open Questions and Required Evidence
    The exact basic analytics, advanced analytics, and entitlement JSON from Laravel db1215bc9b98260accce324830a11ca71f243426.
    Whether show-analytics-chart, show-analytics-list, subscription-list, and subscription still exist on that deployment.
    Whether RevenueCat is still the intended store client, or the backend now expects Play tokens and App Store transaction ids directly.
    Play Console application com.gologonow.groovkin: subscription ids, base plans, offers, and activation.
    App Store Connect bundle: com.gologonow.groovkinn or com.gologonow.groovkin, plus the real subscription group and product ids.
    Whether key id D5FF3A8C is still valid. It should be treated as exposed.
    Which Flutter branch is meant to ship. This repo has master, not production.
14. Recommended First Implementation Task
    Confirm the deployed Laravel analytics and entitlement contract from commit db1215bc, then change AnalyticPortalScreen so basic analytics renders from that payload and eo_phase1_free_subscription no longer unlocks anything.

That is the smallest safe step. It reuses the current portal, chart, and Dio client, and it stops the local Premium bypass before any store purchase work. Store integration should wait until the app sets Premium only from the Laravel response.