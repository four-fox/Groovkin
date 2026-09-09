import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:groovkin/Components/CustomMultipart.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/backend_error.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/View/GroovkinUser/survey/surveyModel.dart' as survey;
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/musicChoiceView/musicChoiceModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/pastEventModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/showVenueByLatLngModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/showVenueByLatLngModel.dart'
    as Data;
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/upcomingEvents/upcomingEventsModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as form;

import 'hashtagCollectionModel.dart';
import 'hashtagCollectionRepository.dart';
import 'ongoingEvents/ongoingEventsModel.dart';
import 'venueDiscoveryModel.dart';
import 'venueDiscoveryRepository.dart';

enum VenuePickerViewMode { list, map }

enum VenueLocationState {
  initial,
  loading,
  available,
  denied,
  deniedForever,
  serviceDisabled,
  unavailable,
}

class EventController extends GetxController {
  late AuthController _authController;
  late ManagerController managerController;
  late HomeController homeController;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ManagerController>()) {
      managerController = Get.find<ManagerController>();
    } else {
      managerController = Get.put(ManagerController());
    }
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
    if (Get.isRegistered<HomeController>()) {
      homeController = Get.find<HomeController>();
    } else {
      homeController = Get.put(HomeController());
    }
  }

  ///quick survey condition Value

  RxBool hipHop = false.obs;
  RxBool soul = false.obs;
  RxBool rock = false.obs;
  RxBool african = false.obs;
  RxBool latin = false.obs;
  RxBool jazz = false.obs;
  RxBool country = false.obs;
  RxBool dance = false.obs;
  RxBool international = false.obs;
  List addForEvent = [];

  List<ListClass> hipList = [
    ListClass(text: "hip 1", condition: false.obs),
    ListClass(text: "hip 2", condition: false.obs),
    ListClass(text: "hip 3", condition: false.obs),
    ListClass(text: "hip 4", condition: false.obs),
  ];
  List<ListClass> africanList = [
    ListClass(text: "african 1", condition: false.obs),
    ListClass(text: "african 2", condition: false.obs),
    ListClass(text: "african 3", condition: false.obs),
    ListClass(text: "african 4", condition: false.obs),
  ];
  List<ListClass> latinList = [
    ListClass(text: "latin 1", condition: false.obs),
    ListClass(text: "latin 2", condition: false.obs),
    ListClass(text: "latin 3", condition: false.obs),
    ListClass(text: "latin 4", condition: false.obs),
  ];
  List<ListClass> jazzList = [
    ListClass(text: "jazz 1", condition: false.obs),
    ListClass(text: "jazz 2", condition: false.obs),
    ListClass(text: "jazz 3", condition: false.obs),
    ListClass(text: "jazz 4", condition: false.obs),
  ];
  List<ListClass> countryList = [
    ListClass(text: "country 1", condition: false.obs),
    ListClass(text: "country 2", condition: false.obs),
    ListClass(text: "country 3", condition: false.obs),
    ListClass(text: "country 4", condition: false.obs),
  ];
  List<ListClass> danceList = [
    ListClass(text: "dance 1", condition: false.obs),
    ListClass(text: "dance 2", condition: false.obs),
    ListClass(text: "dance 3", condition: false.obs),
    ListClass(text: "dance 4", condition: false.obs),
  ];
  List<ListClass> internationalList = [
    ListClass(text: "international 1", condition: false.obs),
    ListClass(text: "international 2", condition: false.obs),
    ListClass(text: "international 3", condition: false.obs),
    ListClass(text: "international 4", condition: false.obs),
  ];
  List<ListClass> soulList = [
    ListClass(text: "soul 1", condition: false.obs),
    ListClass(text: "soul 2", condition: false.obs),
    ListClass(text: "soul 3", condition: false.obs),
    ListClass(text: "soul 4", condition: false.obs),
    ListClass(text: "soul 5", condition: false.obs),
  ];
  List<ListClass> rockList = [
    ListClass(
      text: "rock 1",
      condition: false.obs,
    ),
    ListClass(
      text: "rock 2",
      condition: false.obs,
    ),
    ListClass(
      text: "rock 3",
      condition: false.obs,
    ),
    ListClass(
      text: "rock 4",
      condition: false.obs,
    ),
    ListClass(
      text: "rock 5",
      condition: false.obs,
    ),
  ];

  /// todo create event functionality
  final eventTitleController = TextEditingController();
  final featuringController = TextEditingController();
  final aboutController = TextEditingController();
  final themeOfEventController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventEndDateController = TextEditingController();
  final proposedTimeWindowsController = TextEditingController();
  final endTimeController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final otherRateController = TextEditingController();
  final eventHoursController = TextEditingController();
  final maxCapacityController = TextEditingController();
  final commentsController = TextEditingController();
  RxInt eventRateHourly = 0.obs;
  RxInt paymentScheduleValue = 0.obs;
  RxString? rateType = "hourly".obs;
  RxString? paymentSchedule = "0".obs;
  final downPaymentController = TextEditingController();
  final format = DateFormat('dd-MM-yyyy');

  ///>>>>>>>>>>>>>>>>>  get music tag
  RxBool getMusicTagLoader = true.obs;
  MusicTagModel? addMusicTag;
  List<TagObject> tagList = [];
  List<TagObject> activityList = [];

  getMusicTag({type}) async {
    getMusicTagLoader(false);
    var response = await API().getApi(url: "event-tags?type=$type");
    if (response.statusCode == 200) {
      addMusicTag = MusicTagModel.fromJson(response.data);
      if (type == "music_choice") {
        tagListPost.clear();
        tagList.clear();
        tagList.addAll(MusicTagModel.fromJson(response.data).data!);
      } else {
        activityListPost.clear();
        activityList.clear();
        activityList.addAll(MusicTagModel.fromJson(response.data).data!);
      }
      getMusicTagLoader(true);
      update();
    }
  }

  final HashtagCollectionRepository hashtagCollectionRepository =
      HashtagCollectionRepository();
  final manualHashtagController = TextEditingController();
  RxBool getMusicHashTagLoader = true.obs;
  RxBool getMyTagCollectionLoader = true.obs;
  RxBool getTagCollectionDetails = true.obs;
  RxBool addTagCollectionLoading = true.obs;
  RxBool removeTagCollectionLoading = true.obs;
  String? hashtagCollectionError;
  List<HashtagCollection> organizerCollections = [];
  List<HashtagCollection> selectedOrganizerCollections = [];
  HashtagCollection? tagCollectionDetail;
  List<String> manualHashtags = [];
  bool manualHashtagsChanged = false;
  bool collectionSelectionChanged = false;
  final Set<String> removingEventHashtags = {};

  List<HashtagCollection> get activeOrganizerCollections =>
      organizerCollections.where((element) => element.isActive).toList();

  bool get hasOrganizerHashtagSource =>
      manualHashtags.isNotEmpty || selectedOrganizerCollections.isNotEmpty;

  List<int> get selectedCollectionIds => selectedOrganizerCollections
      .map((collection) => collection.id)
      .whereType<int>()
      .toList();

  getHashtagCollectionApi({type}) async {
    await getEventTagCollection(type: type);
  }

  getEventTagCollection({type}) async {
    try {
      getMyTagCollectionLoader(false);
      getMusicHashTagLoader(false);
      hashtagCollectionError = null;
      organizerCollections =
          await hashtagCollectionRepository.getHashtagCollections(type: type);
      _bindSelectedCollectionsFromEventIfNeeded();
    } catch (e) {
      hashtagCollectionError = e.toString();
    }
    getMyTagCollectionLoader(true);
    getMusicHashTagLoader(true);
    update();
  }

  getEventTagDetail({id}) async {
    if (id == null) return;
    try {
      getTagCollectionDetails(false);
      hashtagCollectionError = null;
      tagCollectionDetail =
          await hashtagCollectionRepository.getHashtagCollection(id);
    } catch (e) {
      hashtagCollectionError = e.toString();
      tagCollectionDetail = null;
    }
    getTagCollectionDetails(true);
    update();
  }

  addTagCollection({
    String? title,
    String? name,
    String? hashtagsText,
    List<String>? hashtags,
    int? collectionId,
    int? hashtagId,
    String type = 'music_choice',
  }) async {
    final collectionTitle = (title ?? name ?? '').trim();
    final tagItems = hashtags ?? parseHashtagText(hashtagsText ?? '');
    final error = validateCollectionForm(
      title: collectionTitle,
      type: type,
      hashtags: tagItems,
    );
    if (error != null) {
      BotToast.showText(text: error);
      return;
    }

    try {
      addTagCollectionLoading(false);
      hashtagCollectionError = null;
      final saved = collectionId != null || hashtagId != null
          ? await hashtagCollectionRepository.updateHashtagCollection(
              UpdateHashtagCollectionRequest(
                collectionId: collectionId ?? hashtagId!,
                title: collectionTitle,
                type: type,
                hashtags: tagItems,
              ),
            )
          : await hashtagCollectionRepository.createHashtagCollection(
              CreateHashtagCollectionRequest(
                title: collectionTitle,
                type: type,
                hashtags: tagItems,
              ),
            );
      await getEventTagCollection();
      if (!selectedOrganizerCollections.any((c) => c.id == saved.id)) {
        selectedOrganizerCollections.add(saved);
        collectionSelectionChanged = true;
      }
      BotToast.showText(text: 'Collection saved');
    } catch (e) {
      hashtagCollectionError = e.toString();
      BotToast.showText(text: hashtagCollectionError!);
    }
    addTagCollectionLoading(true);
    update();
  }

  removeTagCollection({List<int>? collectionIds, List<int>? hashtagIds}) async {
    final ids = collectionIds ?? hashtagIds ?? [];
    if (ids.isEmpty) return;
    try {
      removeTagCollectionLoading(false);
      hashtagCollectionError = null;
      await hashtagCollectionRepository.removeHashtagCollections(ids);
      selectedOrganizerCollections
          .removeWhere((collection) => ids.contains(collection.id));
      collectionSelectionChanged = true;
      await getEventTagCollection();
      BotToast.showText(text: 'Collection removed');
    } catch (e) {
      hashtagCollectionError = e.toString();
      BotToast.showText(text: hashtagCollectionError!);
    }
    removeTagCollectionLoading(true);
    update();
  }

  String? validateCollectionForm({
    required String title,
    required String type,
    required List<String> hashtags,
  }) {
    if (title.trim().isEmpty) return 'Collection title is required';
    if (type != 'music_choice' && type != 'activity_choice') {
      return 'Please select a valid collection type';
    }
    if (hashtags.where((tag) => cleanHashtag(tag).isNotEmpty).isEmpty) {
      return 'At least one hashtag is required';
    }
    return null;
  }

  void addManualHashtagText(String value) {
    final tags = parseHashtagText(value);
    for (final tag in tags) {
      final normalized = normalizeHashtag(tag);
      final exists =
          manualHashtags.any((item) => normalizeHashtag(item) == normalized);
      if (!exists) manualHashtags.add(tag);
    }
    manualHashtagController.clear();
    manualHashtagsChanged = true;
    update();
  }

  Future<void> removeManualHashtag(String value) async {
    final normalized = normalizeHashtag(value);
    if (removingEventHashtags.contains(normalized)) return;
    final eventId = eventDetail?.data?.id;
    final isAttachedToSavedEvent = eventId != null &&
        (eventDetail?.data?.manualHashtags ?? const []).any(
          (tag) => normalizeHashtag(tag.name) == normalized,
        );
    if (isAttachedToSavedEvent) {
      removingEventHashtags.add(normalized);
      update();
      try {
        await hashtagCollectionRepository.removeEventHashtag(
          eventId: eventId,
          name: value,
        );
      } on HashtagApiException catch (error) {
        BotToast.showText(text: error.message);
        if (error.statusCode == 404) {
          await eventDetails(eventId: eventId);
          seedHashtagsFromEventDetail();
        }
        removingEventHashtags.remove(normalized);
        update();
        return;
      }
      removingEventHashtags.remove(normalized);
      if (Get.isRegistered<HomeController>()) {
        await homeController.invalidateRecommendations();
      }
    }
    manualHashtags.removeWhere(
      (tag) => normalizeHashtag(tag) == normalized,
    );
    manualHashtagsChanged = true;
    update();
  }

  void toggleOrganizerCollection(HashtagCollection collection, bool selected) {
    if (!collection.isActive) {
      BotToast.showText(text: 'Inactive collections cannot be selected');
      return;
    }
    if (selected) {
      if (!selectedOrganizerCollections
          .any((item) => item.id == collection.id)) {
        selectedOrganizerCollections.add(collection);
      }
    } else {
      selectedOrganizerCollections
          .removeWhere((item) => item.id == collection.id);
    }
    collectionSelectionChanged = true;
    update();
  }

  void removeSelectedCollection(HashtagCollection collection) {
    selectedOrganizerCollections
        .removeWhere((item) => item.id == collection.id);
    collectionSelectionChanged = true;
    update();
  }

  void _bindSelectedCollectionsFromEventIfNeeded() {
    if (eventDetail == null) return;

    // Collections and manual hashtags are independent. Previously this
    // returned early when collections were empty, so edit-event never
    // seeded manual-only hashtags into the editor.
    if (selectedOrganizerCollections.isEmpty) {
      final collections = eventDetail!.data!.hashtagCollections;
      if (collections != null && collections.isNotEmpty) {
        selectedOrganizerCollections = collections
            .map((collection) => HashtagCollection(
                  id: collection.id,
                  title: collection.title ?? '',
                  type: collection.type,
                  hashtags: collection.hashtags
                      .map((tag) => HashtagCollectionItem(
                            name: tag.name,
                            displayName: tag.displayName,
                          ))
                      .toList(),
                ))
            .toList();
        collectionSelectionChanged = false;
      }
    }

    if (manualHashtags.isEmpty && !manualHashtagsChanged) {
      final manuals = eventDetail!.data!.manualHashtags;
      if (manuals != null && manuals.isNotEmpty) {
        manualHashtags = manuals
            .map((tag) => tag.name)
            .where((tag) => tag.isNotEmpty)
            .toList();
        manualHashtagsChanged = false;
      }
    }
  }

  /// Clears in-memory hashtag editor state and reloads from [eventDetail].
  /// Call when starting an edit so leftover create/edit state cannot hide
  /// the event's saved manual hashtags.
  void seedHashtagsFromEventDetail() {
    selectedOrganizerCollections.clear();
    manualHashtags.clear();
    manualHashtagsChanged = false;
    collectionSelectionChanged = false;
    _bindSelectedCollectionsFromEventIfNeeded();
  }

  ///>>>>>>>>>>>>>>>>>>>> tag list fill check box function
  List<CategoryItem> tagListPost = [];
  bool musicChoiceChanged = false;
  bool activityChoiceChanged = false;
  bool musicGenreChanged = false;
  tagAddFtn({
    CategoryItem? items,
    value,
  }) async {
    items!.selected!.value = value;
    if (value == true) {
      tagListPost.add(items);
    } else {
      tagListPost.remove(items);
    }
    musicChoiceChanged = true;
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>> activity list fill check box function
  List<CategoryItem> activityListPost = [];
  activityAddFtn({
    CategoryItem? items,
    value,
  }) async {
    items!.selected!.value = value;
    if (value == true) {
      activityListPost.add(items);
    } else {
      activityListPost.remove(items);
    }
    activityChoiceChanged = true;
    update();
  }

  /// Registered Groovkin venue picker (Event Organizer only).
  final VenueDiscoveryRepository venueDiscoveryRepository =
      VenueDiscoveryRepository();
  VenuePickerViewMode venuePickerViewMode = VenuePickerViewMode.list;
  VenueLocationState venueLocationState = VenueLocationState.initial;
  double? venueOriginLatitude;
  double? venueOriginLongitude;
  int venueRadius = 10;
  String venueSearchQuery = '';
  List<CompactVenue> discoveredVenues = [];
  List<CompactVenue> venueMarkers = [];
  CompactVenue? selectedVenue;
  int venueCurrentPage = 1;
  int venueLastPage = 1;
  bool venueListLoading = false;
  bool venueMapLoading = false;
  bool venuePaginationLoading = false;
  bool venueRefreshing = false;
  bool venueMarkersTruncated = false;
  String? venueDiscoveryError;
  int _venueRequestGeneration = 0;
  Timer? _venueSearchDebounce;

  bool get hasVenueLocation =>
      venueOriginLatitude != null &&
      venueOriginLongitude != null &&
      !(venueOriginLatitude == 0 && venueOriginLongitude == 0);

  bool get canDiscoverVenues =>
      hasVenueLocation || venueSearchQuery.trim().length >= 2;

  bool get hasMoreVenuePages => venueCurrentPage < venueLastPage;

  Future<void> initializeVenuePicker() async {
    if (hasVenueLocation) {
      await refreshVenueDiscovery();
      return;
    }
    await acquireVenueLocation();
  }

  Future<void> acquireVenueLocation() async {
    venueLocationState = VenueLocationState.loading;
    venueDiscoveryError = null;
    update();
    try {
      if (!await geo.Geolocator.isLocationServiceEnabled()) {
        venueLocationState = VenueLocationState.serviceDisabled;
        update();
        return;
      }
      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }
      if (permission == geo.LocationPermission.deniedForever) {
        venueLocationState = VenueLocationState.deniedForever;
        update();
        return;
      }
      if (permission == geo.LocationPermission.denied) {
        venueLocationState = VenueLocationState.denied;
        update();
        return;
      }
      final position = await geo.Geolocator.getCurrentPosition(
        locationSettings:
            const geo.LocationSettings(accuracy: geo.LocationAccuracy.high),
      ).timeout(const Duration(seconds: 15));
      if (position.latitude == 0 && position.longitude == 0) {
        venueLocationState = VenueLocationState.unavailable;
        update();
        return;
      }
      venueOriginLatitude = position.latitude;
      venueOriginLongitude = position.longitude;
      venueLocationState = VenueLocationState.available;
      await refreshVenueDiscovery();
    } catch (_) {
      venueLocationState = VenueLocationState.unavailable;
      venueDiscoveryError =
          'Your location is unavailable. Search Groovkin venues by name.';
      update();
    }
  }

  Future<void> openVenueLocationSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.location);

  void setVenuePickerViewMode(VenuePickerViewMode mode) {
    if (venuePickerViewMode == mode) return;
    venuePickerViewMode = mode;
    update();
  }

  Future<void> setVenueRadius(int radius) async {
    if (!const {10, 25, 50}.contains(radius) || venueRadius == radius) return;
    venueRadius = radius;
    await refreshVenueDiscovery();
  }

  void setVenueSearch(String value) {
    venueSearchQuery = value.trim();
    _venueSearchDebounce?.cancel();
    _venueSearchDebounce = Timer(const Duration(milliseconds: 400), () {
      refreshVenueDiscovery();
    });
    update();
  }

  Future<void> refreshVenueDiscovery() async {
    _venueSearchDebounce?.cancel();
    final generation = ++_venueRequestGeneration;
    venueCurrentPage = 1;
    venueLastPage = 1;
    venueDiscoveryError = null;
    if (!canDiscoverVenues) {
      discoveredVenues = [];
      venueMarkers = [];
      update();
      return;
    }
    venueListLoading = true;
    venueMapLoading = true;
    venueRefreshing = true;
    update();

    final results = await Future.wait<Object?>([
      venueDiscoveryRepository
          .discover(
            latitude: hasVenueLocation ? venueOriginLatitude : null,
            longitude: hasVenueLocation ? venueOriginLongitude : null,
            radius: venueRadius,
            search: venueSearchQuery,
          )
          .then<Object?>((value) => value)
          .catchError((Object error) => error),
      venueDiscoveryRepository
          .markers(
            latitude: hasVenueLocation ? venueOriginLatitude : null,
            longitude: hasVenueLocation ? venueOriginLongitude : null,
            radius: venueRadius,
            search: venueSearchQuery,
          )
          .then<Object?>((value) => value)
          .catchError((Object error) => error),
    ]);
    if (generation != _venueRequestGeneration) return;
    final page = results[0] is VenueDiscoveryPage
        ? results[0] as VenueDiscoveryPage
        : null;
    final markers = results[1] is VenueMarkerResult
        ? results[1] as VenueMarkerResult
        : null;
    if (page != null) {
      discoveredVenues = page.venues;
      venueCurrentPage = page.currentPage;
      venueLastPage = page.lastPage;
    }
    if (markers != null) {
      venueMarkers = markers.venues
          .where((venue) => venue.latitude != null && venue.longitude != null)
          .toList();
      venueMarkersTruncated = markers.truncated;
    }
    final error = page == null
        ? results[0]
        : markers == null
            ? results[1]
            : null;
    if (error != null) venueDiscoveryError = error.toString();
    final selectedId = selectedVenue?.id;
    if (selectedId != null &&
        !discoveredVenues.any((venue) => venue.id == selectedId) &&
        !venueMarkers.any((venue) => venue.id == selectedId)) {
      selectedVenue = null;
    }
    venueListLoading = false;
    venueMapLoading = false;
    venueRefreshing = false;
    update();
  }

  Future<void> loadMoreVenues() async {
    if (venuePaginationLoading || !hasMoreVenuePages || !canDiscoverVenues) {
      return;
    }
    final generation = _venueRequestGeneration;
    venuePaginationLoading = true;
    update();
    try {
      final page = await venueDiscoveryRepository.discover(
        latitude: hasVenueLocation ? venueOriginLatitude : null,
        longitude: hasVenueLocation ? venueOriginLongitude : null,
        radius: venueRadius,
        search: venueSearchQuery,
        page: venueCurrentPage + 1,
      );
      if (generation != _venueRequestGeneration) return;
      final ids = discoveredVenues.map((venue) => venue.id).toSet();
      discoveredVenues.addAll(
        page.venues.where((venue) => !ids.contains(venue.id)),
      );
      venueCurrentPage = page.currentPage;
      venueLastPage = page.lastPage;
    } catch (error) {
      if (generation == _venueRequestGeneration) {
        venueDiscoveryError = error.toString();
      }
    } finally {
      if (generation == _venueRequestGeneration) {
        venuePaginationLoading = false;
        update();
      }
    }
  }

  void selectVenue(CompactVenue venue) {
    selectedVenue = venue;
    update();
  }

  void clearSelectedVenue() {
    selectedVenue = null;
    update();
  }

  /// Legacy venue state remains for old screens outside the new EO picker.
  ///get list of venues as lat lng
  RxBool getVenuesLatLngLoader = true.obs;
  VenueListModel? allVenueList;
  VenueListModel? allVenueSearchingList;
  VenueByLatLng? venuesDetails;
  getVenuesLatLng() async {
    isFilterApiHit = false;
    getVenuesLatLngLoader(false);
    var response = await API().getApi(
        url:
            "show-venues-by-distance?miles=500&latitude=${managerController.lat}&longitude=${managerController.lng}");
    if (response.statusCode == 200) {
      allVenueList = null;
      allVenueList = VenueListModel.fromJson(response.data);
      allVenueSearchingList = VenueListModel.fromJson(response.data);
      getVenuesLatLngLoader(true);
      update();
    }
  }

// filter Searching Locally Venues

  Future<void> searchingList(String text) async {
    if (text.isEmpty) {
      allVenueSearchingList = allVenueList;
    } else {
      final filtered = allVenueList!.data!.data!.where((data) {
        return data.venueName!.toLowerCase().contains(text.toLowerCase());
      }).toList();
      allVenueSearchingList = VenueListModel(data: Data.Data(data: filtered));
    }
    update();
  }

// get list of filter venue
  TextEditingController radiusController = TextEditingController();
  VenueListModel? filterVenueModel;
  double? radius;
  double startMile = 10.0;
  double endMile = 1000.0;
  bool getFilterVenueLoader = true;
  bool isFilterApiHit = false;

  getFilterVenueLatLng(int startMile, int endMile) async {
    getFilterVenueLoader = false;
    isFilterApiHit = false;
    try {
      var response = await API().getApi(
          url:
              "filter-venues?latitude=${managerController.lat}&longitude=${managerController.lng}&radius=${radius}&max_occupancy_from=${startMile}&max_occupancy_to=${endMile}");
      if (response.statusCode == 200) {
        isFilterApiHit = true;
        getFilterVenueLoader = true;
        allVenueList = null;
        allVenueList = VenueListModel.fromJson(response.data);
        allVenueSearchingList = VenueListModel.fromJson(response.data);
        Get.back();
        update();
      }
    } catch (e) {
      isFilterApiHit = false;
      getFilterVenueLoader = false;
      update();
    }
  }

  String? datePost;
  String? endDatePost;

  String? postTime;
  String? postEndTime;

  /// Static event time defaults for the picker (not wall-clock "now").
  /// Avoids the dial landing on the current minute (e.g. 3:47 → :47).
  static const int defaultEventStartHour = 20; // 8:00 PM
  static const int defaultEventStartMinute = 0;
  static const int defaultEventEndHour = 0; // 12:00 AM
  static const int defaultEventEndMinute = 0;

  static TimeOfDay get defaultEventStartTimeOfDay => const TimeOfDay(
        hour: defaultEventStartHour,
        minute: defaultEventStartMinute,
      );

  static TimeOfDay get defaultEventEndTimeOfDay => const TimeOfDay(
        hour: defaultEventEndHour,
        minute: defaultEventEndMinute,
      );

  /// Picker initial: already-chosen field value, else static start/end default.
  static TimeOfDay eventTimePickerInitial({
    required bool isEnd,
    String? displayText,
  }) {
    final parsed = tryParseEventDisplayTime(displayText);
    if (parsed != null) return parsed;
    return isEnd ? defaultEventEndTimeOfDay : defaultEventStartTimeOfDay;
  }

  static TimeOfDay? tryParseEventDisplayTime(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    final trimmed = text.trim();
    for (final format in <DateFormat>[
      DateFormat.jm(),
      DateFormat('hh:mm a'),
      DateFormat('HH:mm'),
      DateFormat('HH:mm:ss'),
    ]) {
      try {
        final dt = format.parse(trimmed);
        return TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {}
    }
    return null;
  }

  /// Display string for the static default (jm style, e.g. "8:00 PM").
  static String defaultEventStartDisplay() {
    final now = DateTime.now();
    return DateFormat.jm().format(DateTime(
      now.year,
      now.month,
      now.day,
      defaultEventStartHour,
      defaultEventStartMinute,
    ));
  }

  static String defaultEventEndDisplay() {
    final now = DateTime.now();
    return DateFormat.jm().format(DateTime(
      now.year,
      now.month,
      now.day,
      defaultEventEndHour,
      defaultEventEndMinute,
    ));
  }

  postEventFunction(context, theme, {bool draft = false}) async {
    print(
        "lora lae $datePost ${postTime.toString().split(" ")[0]} $endDatePost $postEndTime");

    if (!draft && selectedVenue == null) {
      BotToast.showText(text: 'Select a registered Groovkin venue.');
      Get.toNamed(Routes.listOfVenuesScreen);
      return;
    }
    AuthController authController = Get.find();
    List<form.MultipartFile> mediaList = [];
    for (var element in managerController.mediaClass) {
      if (element.thumbnail != null) {
        mediaList.add(form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Video.${element.filename!.split('.').last}",
          contentType: MediaType("video", element.filename!.split('.').last),
        ));
      } else {
        mediaList.add(form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Image.${element.filename!.split('.').last}",
          contentType: MediaType("image", element.filename!.split('.').last),
        ));
      }
    }

    ///bannerImage
    List imageList = [];
    if (authController.imageBytes != null) {
      var a = multiPartingImage(authController.imageBytes);
      imageList.add(a);
    }
    form.FormData formData = form.FormData.fromMap({
      "event_title": eventTitleController.text,
      "featuring": featuringController.text,
      "about": aboutController.text,
      "theme_of_event": themeOfEventController.text,
      "start_date_time":
          "$datePost ${postTime.toString().split(" ")[0]}" /*datePost*/,
      // "check_in": postTime,
      "end_date_time": "$endDatePost ${postEndTime.toString().split(" ")[0]}",
      // "max_capacity": maxCapacityController.text,
      "rate": hourlyRateController.text,
      "rate_type": rateType!.value,
      "payment_schedule": int.parse(paymentSchedule!.value.toString()),
      if (commentsController.text.isNotEmpty)
        "comment": commentsController.text,
      if (selectedVenue != null) "venue_id": selectedVenue!.id,
      if (mediaList.isNotEmpty) "image[]": mediaList,
      "banner_image[]": imageList,
      "save_draft": draft
    });

    /// todo service params
    for (var i = 0; i <= authController.serviceList.length; i++) {
      if (i != authController.serviceList.length) {
        formData.fields.add(MapEntry(
            'service_id[$i]', authController.serviceList[i].id.toString()));
      }
    }

    /// todo service params

    /// todo hardware params
    int? indexVal = -1;
    int? iiid = -1;
    print(authController.eventItemsList.length);
    for (var a = 0; a <= authController.eventItemsList.length; a++) {
      if (a != authController.eventItemsList.length) {
        if (iiid != authController.eventItemsList[a].categoryId) {
          indexVal = indexVal! + 1;
          formData.fields.add(MapEntry(
              'hardware_provides[$indexVal][hardware_provide_id]',
              authController.eventItemsList[a].categoryId.toString()));
        }
        if (authController.eventItemsList[a].selectedItem!.value == true) {
          iiid = authController.eventItemsList[a].categoryId;
          formData.fields.add(MapEntry(
              'hardware_provides[$indexVal][hardware_item_ids][]',
              authController.eventItemsList[a].id.toString()));
        }
      }
    }

    /// todo hardware params

    /// todo life Style params
    int? indexVaal = -1;
    int? iiad = -1;
    print(authController.itemsList.length);
    for (var a = 0; a <= authController.itemsList.length; a++) {
      if (a != authController.itemsList.length) {
        if (iiad != authController.itemsList[a].categoryId) {
          indexVaal = indexVaal! + 1;
          formData.fields.add(MapEntry(
              'music_genre[$indexVaal][music_genre_id]',
              authController.itemsList[a].categoryId.toString()));
        }
        if (authController.itemsList[a].selectedItem!.value == true) {
          iiad = authController.itemsList[a].categoryId;
          formData.fields.add(MapEntry(
              'music_genre[$indexVaal][music_genre_item_ids][]',
              authController.itemsList[a].id.toString()));
        }
      }
    }

    /// todo life Style params
    int? indexVall = -1;
    int? iiidd = -1;
    for (var a = 0; a <= tagListPost.length; a++) {
      if (a != tagListPost.length) {
        if (iiidd != tagListPost[a].eventTagId) {
          indexVall = indexVall! + 1;
          formData.fields.add(MapEntry(
              'music_choice_tag[$indexVall][music_choice_tag_id]',
              tagListPost[a].eventTagId.toString()));
        }
        if (tagListPost[a].selected!.value == true) {
          iiidd = tagListPost[a].eventTagId;
          formData.fields.add(MapEntry(
              'music_choice_tag[$indexVall][music_choice_tag_item_ids][]',
              tagListPost[a].id.toString()));
        }
      }
    }

    /// todo life Style params

    /// todo activity choice
    int? indexValll = -1;
    int? iiiddd = -1;
    for (var a = 0; a <= activityListPost.length; a++) {
      if (a != activityListPost.length) {
        if (iiiddd != activityListPost[a].eventTagId) {
          indexValll = indexValll! + 1;
          formData.fields.add(MapEntry(
              'activity_choice_tag[$indexValll][activity_choice_tag_id]',
              activityListPost[a].eventTagId.toString()));
        }
        if (activityListPost[a].selected!.value == true) {
          iiiddd = activityListPost[a].eventTagId;
          formData.fields.add(MapEntry(
              'activity_choice_tag[$indexValll][activity_choice_tag_item_ids][]',
              activityListPost[a].id.toString()));
        }
      }
    }

    /// todo activity choice

    if (!draft && !hasOrganizerHashtagSource) {
      BotToast.showText(
        text:
            'Add at least one manual hashtag or select at least one hashtag collection before submitting this event.',
      );
      return;
    }
    if (manualHashtags.isNotEmpty || selectedCollectionIds.isNotEmpty) {
      EventHashtagPayload(
        manualHashtags: manualHashtags,
        collectionIds: selectedCollectionIds,
      ).addToFormData(formData);
    }

    print(formData);
    var response = await API().postApi(formData, 'create-event');
    if (response.statusCode == 200) {
      if (draft == false) {
        Get.back();
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed(Routes.bottomNavigationView,
              arguments: {"indexValue": 0});
        });

        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertWidget(
                height: kToolbarHeight * 4.4,
                container: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Congratulation!',
                        style: poppinsRegularStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'Venue request sent\nWaiting for the Venue Manager to respond',
                        style: poppinsRegularStyle(
                          fontSize: 16,
                          context: context,
                          color: theme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 90,
                        child: Image(
                          image: AssetImage("assets/handshake.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      } else {
        Get.offAllNamed(Routes.bottomNavigationView,
            arguments: {"indexValue": 0});
      }
    } else {
      final message = backendErrorMessage(response, field: 'venue_id');
      BotToast.showText(text: message);
      if (response.statusCode == 422 &&
          message.toLowerCase().contains('not available')) {
        clearSelectedVenue();
        await refreshVenueDiscovery();
        Get.offNamed(Routes.listOfVenuesScreen);
      }
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>edit Event Function
  editEventFunction() async {
    AuthController authController = Get.find();
    final publishVenueId = selectedVenue?.id ?? eventDetail?.data?.venueId;
    if (publishingDraft && publishVenueId == null) {
      BotToast.showText(
          text: 'Select a registered Groovkin venue before publishing.');
      Get.toNamed(Routes.listOfVenuesScreen);
      return;
    }
    List<form.MultipartFile> mediaList = [];
    for (var element in managerController.mediaClass) {
      if (element.thumbnail != null) {
        mediaList.add(form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Video.${element.filename!.split('.').last}",
          contentType: MediaType("video", element.filename!.split('.').last),
        ));
      } else {
        mediaList.add(form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Image.${element.filename!.split('.').last}",
          contentType: MediaType("image", element.filename!.split('.').last),
        ));
      }
    }

    ///bannerImage
    List imageList = [];
    if (authController.imageBytes != null) {
      var a = multiPartingImage(authController.imageBytes);
      imageList.add(a);
    }
    List service = [];
    for (var actions in authController.serviceList) {
      service.add(actions.id);
    }
    var formData = form.FormData.fromMap({
      "event_title": eventTitleController.text,
      "featuring": featuringController.text,
      "about": aboutController.text,
      "theme_of_event": themeOfEventController.text,
      "start_date_time": "$datePost $postTime" /*datePost*/,
      // "check_in": postTime,
      "end_date_time": "$endDatePost $postEndTime",
      // "max_capacity": maxCapacityController.text,
      "rate": hourlyRateController.text,
      "rate_type": rateType!.value,
      "payment_schedule": int.parse(paymentSchedule!.value.toString()),
      "comment": commentsController.text,
      "event_id": eventDetail!.data!.id,
      if (mediaList.isNotEmpty) "image[]": mediaList,
      if (imageList.isNotEmpty) "banner_image[]": imageList,
      "service_id[]": service,
      if (publishingDraft) "venue_id": publishVenueId,
      if (publishingDraft) "save_draft": false,
    });

    /// todo hardware params
    int? indexVal = -1;
    int? iiid = -1;
    int indexValue = -1;
    for (var a = 0; a <= authController.eventItemsList.length; a++) {
      if (a != authController.eventItemsList.length) {
        if (iiid != authController.eventItemsList[a].eventId) {
          indexVal = indexVal! + 1;
          indexValue = -1;
          formData.fields.add(MapEntry('hardware_provides[$indexVal]',
              authController.eventItemsList[a].eventId.toString()));
        }
        if (authController.eventItemsList[a].selectedItem!.value == true) {
          indexValue = indexValue + 1;
          iiid = authController.eventItemsList[a].eventId;
          formData.fields.add(MapEntry(
              'hardware_item_ids[$indexVal][$indexValue]',
              authController.eventItemsList[a].id.toString()));
        }
      }
    }

    /// todo hardware params
    /// todo life Style params
    if (musicGenreChanged) {
      if (authController.itemsList.isEmpty) {
        formData.fields.add(const MapEntry('music_genre', '[]'));
      } else {
        int? indexVaal = -1;
        int? iiad = -1;
        int genreIndex = -1;
        for (var a = 0; a < authController.itemsList.length; a++) {
          if (iiad != authController.itemsList[a].categoryId) {
            indexVaal = indexVaal! + 1;
            genreIndex = -1;
            formData.fields.add(MapEntry('music_genre[$indexVaal]',
                authController.itemsList[a].categoryId.toString()));
          }
          if (authController.itemsList[a].selectedItem!.value == true) {
            iiad = authController.itemsList[a].categoryId;
            genreIndex++;
            formData.fields.add(MapEntry(
                'music_genre_item_ids[$indexVaal][$genreIndex]',
                authController.itemsList[a].id.toString()));
          }
        }
      }
    }

    /// todo life Style params

    /// todo music choice params
    if (musicChoiceChanged) {
      if (tagListPost.isEmpty) {
        formData.fields
          ..add(const MapEntry('music_choice_tag', '[]'))
          ..add(const MapEntry('music_choice_tag_item_ids', '[]'));
      } else {
        int? indexVall = -1;
        int? iiidd = -1;
        int musicChoiceIndex = -1;
        for (var a = 0; a < tagListPost.length; a++) {
          if (iiidd != tagListPost[a].eventTagId) {
            indexVall = indexVall! + 1;
            musicChoiceIndex = -1;
            formData.fields.add(MapEntry('music_choice_tag[$indexVall]',
                tagListPost[a].eventTagId.toString()));
          }
          if (tagListPost[a].selected!.value == true) {
            iiidd = tagListPost[a].eventTagId;
            musicChoiceIndex++;
            formData.fields.add(MapEntry(
                'music_choice_tag_item_ids[$indexVall][$musicChoiceIndex]',
                tagListPost[a].id.toString()));
          }
        }
      }
    }

    /// todo life Style params

    /// todo activity choice
    if (activityChoiceChanged) {
      if (activityListPost.isEmpty) {
        formData.fields
          ..add(const MapEntry('activity_choice_tag', '[]'))
          ..add(const MapEntry('activity_choice_tag_item_ids', '[]'));
      } else {
        int? indexValll = -1;
        int? iiiddd = -1;
        int activityChoiceIndex = -1;
        for (var a = 0; a < activityListPost.length; a++) {
          if (iiiddd != activityListPost[a].eventTagId) {
            indexValll = indexValll! + 1;
            activityChoiceIndex = -1;
            formData.fields.add(MapEntry('activity_choice_tag[$indexValll]',
                activityListPost[a].eventTagId.toString()));
          }
          if (activityListPost[a].selected!.value == true) {
            iiiddd = activityListPost[a].eventTagId;
            activityChoiceIndex++;
            formData.fields.add(MapEntry(
                'activity_choice_tag_item_ids[$indexValll][$activityChoiceIndex]',
                activityListPost[a].id.toString()));
          }
        }
      }
    }

    /// todo activity choice
    final existingManualCount = eventDetail!.data!.manualHashtags?.length ?? 0;
    final existingCollectionCount =
        eventDetail!.data!.hashtagCollections?.length ?? 0;
    final finalManualCount =
        manualHashtagsChanged ? manualHashtags.length : existingManualCount;
    final finalCollectionCount = collectionSelectionChanged
        ? selectedCollectionIds.length
        : existingCollectionCount;
    if (finalManualCount == 0 && finalCollectionCount == 0) {
      BotToast.showText(
        text:
            'Add at least one manual hashtag or select at least one hashtag collection before submitting this event.',
      );
      return;
    }
    EventHashtagPayload(
      manualHashtags: manualHashtagsChanged ? manualHashtags : null,
      collectionIds: collectionSelectionChanged ? selectedCollectionIds : null,
    ).addToFormData(formData);

    var response = await API().postApi(formData, "update-event");
    if (response.statusCode == 200) {
      await homeController.invalidateRecommendations();
      showEditPreviewScreen.value = false;
      publishingDraft = false;
      update();
      BotToast.showText(text: response.data['message']);
      clearFields();
      Get.offAllNamed(Routes.bottomNavigationView,
          arguments: {"indexValue": 0});
    } else {
      final message = backendErrorMessage(response, field: 'venue_id');
      BotToast.showText(text: message);
      if (response.statusCode == 422 &&
          message.toLowerCase().contains('not available')) {
        clearSelectedVenue();
        await refreshVenueDiscovery();
        Get.offNamed(Routes.listOfVenuesScreen);
      }
    }
  }

  ///delete image
  List removeImageList = [];
  deleteImage({id, bool eventImg = false}) async {
    var formData = form.FormData.fromMap({
      if (eventImg == false) "venue_image_id[]": removeImageList,
      if (eventImg == true) "event_image_id[]": removeImageList,
      "source_id": id,
    });
    var response = await API().postApi(formData, "remove-media");
    if (response.statusCode == 200) {}
  }

  ///>>>>>>>>>>>>>>>>>>>>>>> event start and end time are checking
  checkingTime({sta}) async {
    var formData = form.FormData.fromMap({
      "start_date_time": "$datePost $postTime",
      "end_date_time": "$endDatePost $postEndTime",
    });
    var response = await API().postApi(formData, "check-date-time");
    if (response.statusCode == 200) {
      Get.toNamed(Routes.serviceScreen, arguments: {"addMoreService": 3});
    }
  }

  /// clear fields
  RxBool draftCondition = false.obs;
  clearFields() async {
    // draftCondition(true);

    duplicateValue(true);
    draftValue(true);
    _authController.imageBytes = null;
    eventTitleController.clear();
    featuringController.clear();
    aboutController.clear();
    themeOfEventController.clear();
    maxCapacityController.clear();
    hourlyRateController.clear();
    commentsController.clear();
    datePost = null;
    postTime = null;
    endDatePost = null;
    postEndTime = null;
    rateType!.value = "hourly";
    paymentSchedule!.value = "0";
    downPaymentController.clear();
    _authController.serviceList.clear();
    _authController.eventItemsList.clear();
    _authController.lifeStyleItemsList.clear();
    _authController.itemsList.clear();
    selectedOrganizerCollections.clear();
    organizerCollections.clear();
    manualHashtags.clear();
    manualHashtagsChanged = false;
    collectionSelectionChanged = false;
    activityListPost.clear();
    tagListPost.clear();
    selectedVenue = null;
    publishingDraft = false;
    musicGenreChanged = false;
    musicChoiceChanged = false;
    activityChoiceChanged = false;
    eventDateController.clear();
    eventEndDateController.clear();
    proposedTimeWindowsController.clear();
    endTimeController.clear();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get my all events for organizer

  EventsListModel? allEvents;
  RxBool getAllEventsLoader = true.obs;
  bool getAllEventWaiting = false;

  getAllEvents({nextUrl, loader = true}) async {
    getAllEventsLoader(false);
    var response = await API().getApi(
        url: "show-venue-my-events", fullUrl: nextUrl, isLoader: loader);
    if (response.statusCode == 200) {
      if (nextUrl == null) {
        getAllEventWaiting = false;
        allEvents = EventsListModel.fromJson(response.data);
      } else {
        allEvents!.data!.data
            .addAll(EventsListModel.fromJson(response.data).data!.data);
        allEvents!.data!.nextPageUrl =
            EventsListModel.fromJson(response.data).data!.nextPageUrl;
        getAllEventWaiting = false;
      }
      getAllEventsLoader(true);
      update();
    }
  }

  ///searching events
  final searchingController = TextEditingController();
  searchingEvent({nextUrl}) async {
    getAllEventsLoader(false);
    var response = await API().getApi(
        url: "search-events?search=${searchingController.text}",
        fullUrl: nextUrl);
    if (response.statusCode == 200) {
      if (nextUrl == null) {
        getAllEventWaiting = false;
        allEvents = EventsListModel.fromJson(response.data);
      } else {
        allEvents!.data!.data
            .addAll(EventsListModel.fromJson(response.data).data!.data);
        allEvents!.data!.nextPageUrl =
            EventsListModel.fromJson(response.data).data!.nextPageUrl;
        getAllEventWaiting = false;
      }
      getAllEventsLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>> get all event sending requests
  RxBool getAllSendingRequestLoader = true.obs;
  bool requestEventWaiting = false;

  getAllSendingRequest({nextUrl}) async {
    getAllSendingRequestLoader(false);
    var response = await API().getApi(
      url: "show-requested-events",
      fullUrl: nextUrl,
      queryParameters: {
        "filter": (homeController.showIndexValue == 1 &&
                (homeController.selectedFilter == 0))
            ? "recent"
            : (homeController.showIndexValue == 1 &&
                    (homeController.selectedFilter == 1))
                ? "past_week"
                : "older_than_1_month",
      },
    );

    if (response.statusCode == 200) {
      if (nextUrl == null) {
        requestEventWaiting = false;
        allEvents = EventsListModel.fromJson(response.data);
      } else {
        allEvents!.data!.data
            .addAll(EventsListModel.fromJson(response.data).data!.data);
        allEvents!.data!.nextPageUrl =
            EventsListModel.fromJson(response.data).data!.nextPageUrl;
        requestEventWaiting = false;
      }
      getAllSendingRequestLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get details of event details
  ///
  UserEventDetailsModel? eventDetail;
  RxBool eventDetailsLoader = true.obs;
  List<String> venueImageList = [];
  RxBool duplicateValue = false.obs;
  RxBool draftValue = false.obs;
  bool publishingDraft = false;
  RxBool showEditPreviewScreen = false.obs;

  eventDetails({eventId}) async {
    eventDetailsLoader(false);
    duplicateValue(false);
    draftValue(false);
    var response = await API().getApi(url: "event-details/$eventId");
    if (response.statusCode == 200) {
      eventDetail = UserEventDetailsModel.fromJson(response.data);
      venueImageList.clear();
      for (var element in eventDetail!.data!.profilePicture!) {
        venueImageList.add(element.mediaPath!);
      }
      eventDetailsLoader(true);
      update();
    }
  }

  List imageListtt = [];
  // downPayment = "396.00"
  // balanceDue = "3564.00"
  // totalAmount = "4752.00"
  assignValueForUpdate() async {
    musicGenreChanged = false;
    musicChoiceChanged = false;
    activityChoiceChanged = false;
    eventTitleController.text = eventDetail!.data!.eventTitle.toString();
    // downPaymentController.text = eventDetail!.data!.downPayment.toString();
    featuringController.text = eventDetail!.data!.featuring.toString();
    aboutController.text = eventDetail!.data!.about.toString();
    themeOfEventController.text = eventDetail!.data!.themeOfEvent.toString();
    maxCapacityController.text = eventDetail!.data!.maxCapacity.toString();
    eventDateController.text =
        DateFormat('dd-MM-yyyy').format(eventDetail!.data!.startDateTime!);
    eventEndDateController.text =
        DateFormat('dd-MM-yyyy').format(eventDetail!.data!.endDateTime!);
    proposedTimeWindowsController.text =
        DateFormat("HH:mm a").format(eventDetail!.data!.startDateTime!);
    endTimeController.text =
        DateFormat("HH:mm a").format(eventDetail!.data!.endDateTime!);
    postEndTime = endTimeController.text;
    postTime = proposedTimeWindowsController.text;
    endDatePost =
        DateFormat('yyyy-MM-dd').format(eventDetail!.data!.endDateTime!);
    datePost =
        DateFormat('yyyy-MM-dd').format(eventDetail!.data!.startDateTime!);

    if (eventDetail!.data!.rateType == "hourly") {
      eventRateHourly.value = 0;
      rateType!.value = "hourly";
    } else {
      eventRateHourly.value = 1;
      rateType!.value = "flat";
    }
    hourlyRateController.text = eventDetail!.data!.rate.toString();
    final existingSchedule =
        double.tryParse(eventDetail!.data!.paymentSchedule?.toString() ?? "");
    if (existingSchedule != null) {
      paymentSchedule!.value = existingSchedule.round().toString();
      downPaymentController.text = paymentSchedule!.value;
    }
    if (eventDetail!.data!.comment != null) {
      commentsController.text = eventDetail!.data!.comment.toString();
    }
    seedHashtagsFromEventDetail();
    Get.toNamed(Routes.upGradeEvents);
  }

  ///service data are binding
  checkServices({survey.SurveyObject? surveyObj}) async {
    // _authController.serviceList.clear();
    List serviceList = [];
    for (var action in eventDetail!.data!.services!) {
      serviceList.add(action.eventItemId);
    }
    for (var service in _authController.serviceListing) {
      if (serviceList.contains(service.id)) {
        service.showItems!.value = true;
        _authController.serviceList.add(service);
        // _authController.serviceAddFtn(items: service);
      }
    }
  }

  ///hardware data are binding
  checkHardware(
      {survey.SurveyObject? items, value, CategoryItem? serviceObj}) async {
    List<String> temp = [];
    eventDetail!.data!.hardwareProvide?.forEach((element) {
      element.hardwareItems!.map((data) {
        temp.add(data.id.toString());
      });
    });
    for (var action in _authController.hardwareListing) {
      if (temp.contains(action.name)) {
        action.showItems!.value = true;
      } else {
        action.showItems!.value = false;
      }
      for (var items in action.categoryItems!) {
        if (temp.contains(items.id.toString())) {
          items.selectedItem!.value = true;
          _authController.eventItemsList.add(items);
        } else {
          items.selectedItem!.value = false;
        }
      }
    }
  }

  ///bind survey data
  surveyDataBind() async {
    List musicGenreId = [];
    for (var action in eventDetail!.data!.musicGenre!) {
      action.musicGenreItems!.map((data) {
        musicGenreId.add(data.id);
      });
    }
    for (var element in _authController.surveyData!.data!) {
      for (var ele in element.categoryItems!) {
        if (musicGenreId.contains(ele.id)) {
          element.showItems!.value = true;
          ele.selectedItem!.value = true;
          _authController.itemsList.add(ele);
        } else {
          ele.selectedItem!.value = false;
        }
      }
    }
  }

  musicChoiceBinding() async {
    List musicChoice = [];
    for (var action in eventDetail!.data!.eventMusicChoiceTags!) {
      musicChoice.add(action.eventTagItemId);
    }
    for (var ele in tagList) {
      for (var element in ele.categoryItems!) {
        if (musicChoice.contains(element.id)) {
          ele.showSubCat!.value = true;
          element.selected!.value = true;
          tagListPost.add(element);
        } else {
          element.selected!.value = false;
        }
      }
    }
  }

  ///create Event
  activityChoice() async {
    List activityChoiceList = [];
    for (var action in eventDetail!.data!.eventActivityChoiceTags!) {
      activityChoiceList.add(action.eventTagItemId);
    }
    for (var elementss in activityList) {
      for (var ele in elementss.categoryItems!) {
        if (activityChoiceList.contains(ele.id)) {
          elementss.showSubCat!.value = true;
          ele.selected!.value = true;
          activityListPost.add(ele);
        } else {
          ele.selected!.value = false;
        }
      }
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>> manager Acknowledged complete event
  acknowledgedEvent({eventId}) async {
    var formData = form.FormData.fromMap({
      "event_id": eventId,
    });
    var response = await API().postApi(formData, "acknowledged-event");
    if (response.statusCode == 200) {
      bottomToast(text: response.data['message']);
      Get.back();
      // int a = pastEventData!.data!.data!
      //     .indexWhere((element) => element.id == eventId);
      // pastEventData!.data!.data!.remove(pastEventData!.data!.data![a]);
      update();
      Get.back();
    }
  }

  ///user side interested or going etc
  userInterested({statusValue, eventId}) async {
    var formData = form.FormData.fromMap({
      "source_id": eventId,
      "status": statusValue,
    });
    var response = await API().postApi(formData, "user-event-status");
    if (response.statusCode == 200) {
      eventDetail!.data!.eventGoingOrInterested!.value = 1;
      update();
    }
  }

  ///user cancel events
  userCancelEvents({eventId}) async {
    var formData = form.FormData.fromMap({
      "source_id": eventId,
    });
    var response = await API().postApi(formData, "cancel-event-by-user");
    if (response.statusCode == 200) {
      eventDetail!.data!.eventGoingOrInterested!.value = 0;
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cancel events
  final cancellationController = TextEditingController();
  cancelEvents({eventId, back = false}) async {
    bottomToast(
      text: "Cancellation now requires quote review and explicit confirmation.",
    );
    Get.toNamed(
      Routes.cancellationWorkflowScreen,
      arguments: {
        "eventId": eventId,
        "initialReason": cancellationController.text,
      },
    );
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get upcoming events
  UpcomingEventsModel? upcomingEventData;
  RxBool getUpcomingEventsLoader = true.obs;

  getUpcomingEvents() async {
    getUpcomingEventsLoader(false);
    var response = await API().getApi(url: "upcoming-events");
    if (response.statusCode == 200) {
      upcomingEventData = UpcomingEventsModel.fromJson(response.data);
      getUpcomingEventsLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> postponed data assign
  ///
  postponedAssign() async {
    proposedTimeWindowsController.text =
        DateFormat().add_jm().format(eventDetail!.data!.startDateTime!);
    endTimeController.text =
        DateFormat().add_jm().format(eventDetail!.data!.endDateTime!);
    datePost =
        DateFormat('yyyy-MM-dd').format(eventDetail!.data!.startDateTime!);
    endDatePost =
        DateFormat('yyyy-MM-dd').format(eventDetail!.data!.endDateTime!);
    postTime = DateFormat("HH:mm")
        .parse(proposedTimeWindowsController.text)
        .toString()
        .replaceRange(0, 11, "")
        .split(".")[0];
    postEndTime = DateFormat("HH:mm")
        .parse(endTimeController.text)
        .toString()
        .replaceRange(0, 11, "")
        .split(".")[0];
    Get.toNamed(Routes.editEventScreen,
        arguments: {"eventId": eventDetail!.data!.id});
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> postponed event

  final rescheduleDescriptionController = TextEditingController();
  eventPostponed({eventId}) async {
    var formData = form.FormData.fromMap({
      "event_id": eventId,
      "start_date_time": "$datePost $postTime",
      "end_date_time": "$endDatePost $postEndTime",
      "about": rescheduleDescriptionController.text,
    });
    var response = await API().postApi(formData, "reschedule-event");
    if (response.statusCode == 200) {
      bottomToast(text: response.data["message"].toString());
      Get.back();
      Get.back();
      // print(object);
    }
  }

  ///get all ongoing events
  RxBool getAllOngoingEventsLoader = true.obs;
  OngoingEventModel? ongoingEvents;
  getAllOngoingEvents() async {
    getAllOngoingEventsLoader(false);
    var response = await API().getApi(url: "on-going-events");
    if (response.statusCode == 200) {
      ongoingEvents = OngoingEventModel.fromJson(response.data);
      getAllOngoingEventsLoader(true);
      update();
    }
  }

  ///complete event and submit rating
  final ratingDescriptionController = TextEditingController();
  String ratingValue = "1.0";
  completeEvent({EventDetails? eventDetails}) async {
    var formData = form.FormData.fromMap({
      "event_id": eventDetails!.id,
      "rate_num": ratingValue,
      if (ratingDescriptionController.text.isNotEmpty)
        "rating_text": ratingDescriptionController.text,
      "venue_id": eventDetails.venue!.id,
    });
    var response = await API().postApi(formData, "complete-event");
    if (response.statusCode == 200) {
      bottomToast(text: response.data["message"].toString());
      Get.back();
      Get.back();
    }
  }

  /// get past events
  PastEventModel? pastEventData;
  getPastEvent() async {
    var response = await API().getApi(url: "past-events-by-organizer");
    if (response.statusCode == 200) {
      pastEventData = PastEventModel.fromJson(response.data);
      update();
    }
  }

  @override
  void onClose() {
    _venueSearchDebounce?.cancel();
    super.onClose();
  }

  /// todo create event functionality
}

class ListClass {
  String? text;
  RxBool? condition = false.obs;
  ListClass({this.text, this.condition});
}

class EventBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(() => EventController());
  }
}
