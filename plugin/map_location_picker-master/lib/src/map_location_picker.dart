// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'logger.dart';
import 'provider.dart';

class MapLocationPicker extends StatefulWidget {
  /// Padding around the map
  final EdgeInsets padding;

  /// Compass for the map (default: true)
  final bool compassEnabled;

  /// Lite mode for the map (default: false)
  final bool liteModeEnabled;

  /// API key for the map & places
  final String apiKey;

  /// GPS accuracy for the map
  final LocationAccuracy desiredAccuracy;

  /// GeoCoding base url
  final String? geoCodingBaseUrl;

  /// GeoCoding http client
  final Client? geoCodingHttpClient;

  /// GeoCoding api headers
  final Map<String, String>? geoCodingApiHeaders;

  /// GeoCoding location type
  final List<String> locationType;

  /// GeoCoding result type
  final List<String> resultType;

  /// Map minimum zoom level & maximum zoom level
  final MinMaxZoomPreference minMaxZoomPreference;

  /// Top card margin
  final EdgeInsetsGeometry topCardMargin;

  /// Top card color
  final Color? topCardColor;

  /// Top card shape
  final ShapeBorder topCardShape;

  /// Top card text field border radius
  final BorderRadius? borderRadius;

  /// Top card text field hint text
  String? searchHintText;

  /// Bottom card shape
  final ShapeBorder bottomCardShape;

  /// Bottom card margin
  final EdgeInsetsGeometry bottomCardMargin;

  /// Bottom card icon
  final Icon bottomCardIcon;

  /// Bottom card tooltip
  final String bottomCardTooltip;

  /// Bottom card color
  final Color? bottomCardColor;

  /// On Suggestion Selected callback
  final Function(PlacesDetailsResponse?)? onSuggestionSelected;

  /// On Next Page callback
  final Function(
    GeocodingResult?,
  ) onNext;

  /// Show back button (default: true)
  final bool showBackButton;

  /// Popup route on next press (default: false)
  final bool canPopOnNextButtonTaped;

  /// Back button replacement when [showBackButton] is false and [backButton] is not null
  final Widget? backButton;

  /// Show more suggestions
  final bool showMoreOptions;

  /// Dialog title
  final String dialogTitle;

  /// httpClient is used to make network requests.
  final Client? placesHttpClient;

  /// apiHeader is used to add headers to the request.
  final Map<String, String>? placesApiHeaders;

  /// baseUrl is used to build the url for the request.
  final String? placesBaseUrl;

  /// Session token for Google Places API
  final String? sessionToken;

  /// Offset for pagination of results
  /// offset: int,
  final num? offset;

  /// Origin location for calculating distance from results
  /// origin: Location(lat: -33.852, lng: 151.211),
  final Location? origin;

  /// Location bounds for restricting results to a radius around a location
  /// location: Location(lat: -33.867, lng: 151.195)
  final Location? location;

  /// Radius for restricting results to a radius around a location
  /// radius: Radius in meters
  final num? radius;

  /// Language code for Places API results
  /// language: 'en',
  final String? language;

  /// Types for restricting results to a set of place types
  final List<String> types;

  /// Components set results to be restricted to a specific area
  /// components: [Component(Component.country, "us")]
  final List<Component> components;

  /// Bounds for restricting results to a set of bounds
  final bool strictbounds;

  /// Region for restricting results to a set of regions
  /// region: "us"
  final String? region;

  /// fields
  final List<String> fields;

  /// Hide Suggestions on keyboard hide
  final bool hideSuggestionsOnKeyboardHide;

  ///map style
  String? mapStyle;

  /// map ontap function
  bool onTap;

  ///init lat lang
  LatLng? latLng;

  ///edit disable
  bool hideLocation = false;
  double? lat;
  double? long;
  bool? backBtnn = false;

  /// address
  String? initAddress;
  GestureTapCallback? onTappp;
  bool onTapShow = false;
  GestureTapCallback? nextPage;
  MapLocationPicker({
    Key? key,
    this.desiredAccuracy = LocationAccuracy.high,
    required this.apiKey,
    this.geoCodingBaseUrl,
    this.lat,
    this.onTappp,
    this.onTapShow = false,
    this.nextPage,
    this.long,
    this.geoCodingHttpClient,
    this.geoCodingApiHeaders,
    this.language,
    this.backBtnn,
    this.locationType = const [],
    this.resultType = const [],
    this.minMaxZoomPreference = const MinMaxZoomPreference(10, 20),
    this.padding = const EdgeInsets.all(0),
    this.compassEnabled = true,
    this.liteModeEnabled = false,
    this.topCardMargin = const EdgeInsets.all(8),
    this.topCardColor,
    this.topCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.searchHintText,
    this.bottomCardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.bottomCardMargin = const EdgeInsets.fromLTRB(8, 8, 8, 16),
    this.bottomCardIcon = const Icon(
      Icons.send,
      color: Colors.black,
    ),
    this.bottomCardTooltip = "Continue with this location",
    this.bottomCardColor,
    this.onSuggestionSelected,
    required this.onNext,
    this.showBackButton = true,
    this.canPopOnNextButtonTaped = false,
    this.backButton,
    this.showMoreOptions = true,
    this.dialogTitle = 'You can also use the following options',
    this.placesHttpClient,
    this.placesApiHeaders,
    this.placesBaseUrl,
    this.sessionToken,
    this.offset,
    this.origin,
    this.location,
    this.radius,
    this.region,
    this.fields = const [],
    this.types = const [],
    this.components = const [],
    this.strictbounds = false,
    this.hideSuggestionsOnKeyboardHide = false,
    this.onTap = true,
    this.latLng,
    this.initAddress,
    this.hideLocation = false,
  }) : super(key: key);

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  @override
  void initState() {
    currentPositionLatLng(
      latLng: widget.latLng,
      address: widget.initAddress,
    );

    // _setMarkerIcon();
    // currentPositionLatLng();
    super.initState();
    // rootBundle.loadString('assets/map_style.txt').then((string) {
    //   widget.mapStyle = string;
    // });
  }

  /// Map controller for movement & zoom
  final Completer<GoogleMapController> _controller = Completer();

  /// Search text field controller
  final TextEditingController _searchController = TextEditingController();

  /// initial latitude & longitude
  LatLng? _initialPosition;

  currentPositionLatLng({latLng, address}) async {
    print(widget.lat);
    print(widget.long);
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.unableToDetermine ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    if (latLng == null) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if ((widget.lat != null) && (widget.long != null)) {
        LatLng latLng = LatLng(widget.lat!, widget.long!);
        _initialPosition = latLng;
      } else {
        LatLng latLng = LatLng(position.latitude, position.longitude);
        _initialPosition = latLng;
      }
      setState(() {});
    } else {
      _initialPosition = latLng;

      _address = address;
      setState(() {});
    }
  }

  /// initial address text
  String? _address;

  /// Map type (default: MapType.normal)
  MapType _mapType = MapType.normal;

  /// initial zoom level
  double _zoom = 18.0;

  /// GeoCoding result for further use
  GeocodingResult? _geocodingResult;

  /// GeoCoding results list for further use
  List<GeocodingResult> _geocodingResultList = [];

  /// Camera position moved to location
  CameraPosition cameraPosition() {
    return CameraPosition(
      target: _initialPosition!,
      zoom: _zoom,
    );
  }

  /// Decode address from latitude & longitude
  void _decodeAddress(Location location) async {
    try {
      final geocoding = GoogleMapsGeocoding(
        apiKey: widget.apiKey,
        baseUrl: widget.geoCodingBaseUrl,
        apiHeaders: widget.geoCodingApiHeaders,
        httpClient: widget.geoCodingHttpClient,
      );
      final response = await geocoding.searchByLocation(
        location,
        language: widget.language,
        locationType: widget.locationType,
        resultType: widget.resultType,
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        logger.e(response.errorMessage);
        _address = response.status;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ??
                  "Address not found, something went wrong!"),
            ),
          );
        }
        return;
      }
      _address = response.results.first.formattedAddress ?? "";
      _geocodingResult = response.results.first;
      if (response.results.length > 1) {
        _geocodingResultList = response.results;
      }
      setState(() {});
    } catch (e) {
      logger.e(e);
    }
  }

  /// Get address details from place id
  void _getDetailsByPlaceId(String placeId) async {
    try {
      final places = GoogleMapsPlaces(
        apiKey: widget.apiKey,
        httpClient: widget.placesHttpClient,
        apiHeaders: widget.placesApiHeaders,
        baseUrl: widget.placesBaseUrl,
      );
      final response = await places.getDetailsByPlaceId(
        placeId,
        region: widget.region,
        sessionToken: widget.sessionToken,
        language: widget.language,
        fields: widget.fields,
      );

      /// When get any error from the API, show the error in the console.
      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        logger.e(response.errorMessage);
        _address = response.status;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.errorMessage ??
                  "Address not found, something went wrong!"),
            ),
          );
        }
        return;
      }

      _initialPosition = LatLng(
        response.result.geometry?.location.lat ?? 0,
        response.result.geometry?.location.lng ?? 0,
      );
      final controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition()));
      _address = response.result.formattedAddress ?? "";
      widget.onSuggestionSelected?.call(response);
      setState(() {});
    } catch (e) {
      logger.e(e);
    }
  }

  /// marker icon custom

  BitmapDescriptor? _markerIcon;
  // void _setMarkerIcon() async {
  //   _markerIcon = await BitmapDescriptor.fromAssetImage(
  //       const ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
  // }

  @override
  Widget build(BuildContext context) {
    return _initialPosition != null
        ? MultiProvider(
            providers: [
              /// Change notifier for place search results
              ChangeNotifierProvider(
                create: (_) => AutoCompleteState(
                  baseUrl: widget.placesBaseUrl,
                  apiHeaders: widget.placesApiHeaders,
                  httpClient: widget.placesHttpClient,
                ),
              ),
            ],
            child: Scaffold(
              body: Stack(
                children: [
                  /// Google map view
                  GoogleMap(
                    minMaxZoomPreference: widget.minMaxZoomPreference,
                    onCameraMove: (CameraPosition position) {
                      /// set zoom level
                      _zoom = position.zoom;
                    },
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition!,
                      zoom: 18,
                    ),
                    onTap: widget.onTap
                        ? (LatLng position) async {
                            _initialPosition = position;
                            final controller = await _controller.future;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    cameraPosition()));
                            _decodeAddress(Location(
                                lat: position.latitude,
                                lng: position.longitude));
                            setState(() {});
                          }
                        : (LatLng position) {
                            _initialPosition = _initialPosition;
                          },
                    onMapCreated: (GoogleMapController controller) async {
                      _controller.complete(controller);
                      if (widget.mapStyle != null) {
                        controller.setMapStyle(widget.mapStyle);
                      }
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('one'),
                        position: _initialPosition!,
                        icon: BitmapDescriptor.defaultMarker,
                      )
                    },
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    padding: widget.padding,
                    compassEnabled: widget.compassEnabled,
                    liteModeEnabled: widget.liteModeEnabled,
                    mapType: _mapType,
                  ),
                  widget.hideLocation == false
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            widget.onTap
                                ? SafeArea(
                                    child: Card(
                                      margin: widget.topCardMargin,
                                      shape: widget.topCardShape,
                                      color: Colors.white,
                                      child: ListTile(
                                        minVerticalPadding: 0,
                                        contentPadding: const EdgeInsets.only(
                                            right: 4, left: 4),
                                        leading: widget.showBackButton
                                            ? const BackButton(
                                                color: Colors.black,
                                              )
                                            : widget.backButton,
                                        title: ClipRRect(
                                          borderRadius: widget.borderRadius!,
                                          child: Consumer<AutoCompleteState>(
                                            builder: (context, state, child) {
                                              return FormBuilderTypeAhead<
                                                  Prediction>(
                                                decoration: InputDecoration(
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  hintStyle: TextStyle(
                                                      color: Colors.white),
                                                  hintText:
                                                      widget.searchHintText,
                                                  border: InputBorder.none,
                                                  filled: true,
                                                  suffixIcon: IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () async {
                                                      _searchController.clear();
                                                    },
                                                  ),
                                                ),
                                                name: 'Search',
                                                controller: _searchController,
                                                selectionToTextTransformer:
                                                    (result) {
                                                  return result.description ??
                                                      "";
                                                },
                                                itemBuilder:
                                                    (context, continent) {
                                                  return ListTile(
                                                    title: Text(
                                                        continent.description ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'poppinsLight',
                                                          letterSpacing: 0,
                                                        )),
                                                  );
                                                },
                                                suggestionsCallback:
                                                    (query) async {
                                                  await state.search(
                                                    query,
                                                    widget.apiKey,
                                                    language: widget.language,
                                                    sessionToken:
                                                        widget.sessionToken,
                                                    region: widget.region,
                                                    components:
                                                        widget.components,
                                                    location: widget.location,
                                                    offset: widget.offset,
                                                    origin: widget.origin,
                                                    radius: widget.radius,
                                                    strictbounds:
                                                        widget.strictbounds,
                                                    types: widget.types,
                                                  );
                                                  return state.results;
                                                },
                                                onSuggestionSelected:
                                                    (value) async {
                                                  _searchController.selection =
                                                      TextSelection.collapsed(
                                                    offset: _searchController
                                                        .text.length,
                                                  );
                                                  _getDetailsByPlaceId(
                                                      value.placeId ?? "");
                                                  setState(() {});
                                                },
                                                hideSuggestionsOnKeyboardHide:
                                                    widget
                                                        .hideSuggestionsOnKeyboardHide,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 26, horizontal: 14),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 44,
                                        width: 44,
                                        padding: const EdgeInsets.all(04.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: const Icon(Icons.arrow_back,
                                            size: 28, color: Colors.white),
                                      ),
                                    ),
                                  ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(360),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.5),
                                  child: PopupMenuButton(
                                    tooltip: 'Map Type',
                                    initialValue: _mapType,
                                    icon: const Icon(
                                      Icons.layers,
                                      color: Colors.black,
                                    ),
                                    onSelected: (MapType mapType) {
                                      setState(() {
                                        _mapType = mapType;
                                      });
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: MapType.normal,
                                        child: Text('Normal'),
                                      ),
                                      PopupMenuItem(
                                        value: MapType.hybrid,
                                        child: Text('Hybrid'),
                                      ),
                                      PopupMenuItem(
                                        value: MapType.satellite,
                                        child: Text('Satellite'),
                                      ),
                                      PopupMenuItem(
                                        value: MapType.terrain,
                                        child: Text('Terrain'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            widget.onTap
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FloatingActionButton(
                                      tooltip: 'My Location',
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.white,
                                      onPressed: () async {
                                        var permission =
                                            await Geolocator.checkPermission();
                                        if (permission ==
                                                LocationPermission
                                                    .unableToDetermine ||
                                            permission ==
                                                LocationPermission
                                                    .deniedForever ||
                                            permission ==
                                                LocationPermission.denied) {
                                          await Geolocator.requestPermission();
                                        }
                                        Position position =
                                            await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              widget.desiredAccuracy,
                                        );
                                        LatLng latLng = LatLng(
                                            position.latitude,
                                            position.longitude);
                                        _initialPosition = latLng;
                                        final controller =
                                            await _controller.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                cameraPosition()));
                                        _decodeAddress(Location(
                                            lat: position.latitude,
                                            lng: position.longitude));
                                        widget.searchHintText =
                                            "Start typing here to search";
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.my_location,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            widget.onTap
                                ? SafeArea(
                                    child: Card(
                                      margin: widget.bottomCardMargin,
                                      shape: widget.bottomCardShape,
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              _address ??
                                                  "Tap on map to select location",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily:
                                                    'MonstserratRegular',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              tooltip: widget.bottomCardTooltip,
                                              icon: widget.bottomCardIcon,
                                              onPressed: () async {
                                                widget.onNext
                                                    .call(_geocodingResult);
                                                if (widget
                                                    .canPopOnNextButtonTaped) {
                                                  if (widget.backBtnn == true) {
                                                    Navigator.pop(context);
                                                  } else {
                                                    widget.nextPage;
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          widget.onTapShow == false
                                              ? SizedBox.shrink()
                                              : GestureDetector(
                                                  onTap: widget.onTappp,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6.0,
                                                            horizontal: 10),
                                                    child: Container(
                                                      height: 40,
                                                      width: MediaQuery.sizeOf(
                                                              context)
                                                          .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            Color(0xffd6a331),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Continue",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                          // if (widget.showMoreOptions &&
                                          //     _geocodingResultList.isNotEmpty)
                                          //   GestureDetector(
                                          //     onTap: () {
                                          //       showDialog(
                                          //         context: context,
                                          //         builder: (context) => AlertDialog(
                                          //           title: Text(widget.dialogTitle),
                                          //           scrollable: true,
                                          //           content: Column(
                                          //             mainAxisSize: MainAxisSize.min,
                                          //             children: _geocodingResultList
                                          //                 .map((element) {
                                          //               return ListTile(
                                          //                 title: Text(
                                          //                     element.formattedAddress ??
                                          //                         "",
                                          //                     style: TextStyle(
                                          //                       fontSize: 14,
                                          //                       color: Colors.black,
                                          //                       fontWeight:
                                          //                           FontWeight.bold,
                                          //                       fontFamily:
                                          //                           'MonstserratRegular',
                                          //                       letterSpacing: 0,
                                          //                     )),
                                          //                 onTap: () {
                                          //                   _address = element
                                          //                           .formattedAddress ??
                                          //                       "";
                                          //                   _geocodingResult = element;
                                          //                   setState(() {});
                                          //                   Navigator.pop(context);
                                          //                 },
                                          //               );
                                          //             }).toList(),
                                          //           ),
                                          //           actions: [
                                          //             TextButton(
                                          //               child: const Text(
                                          //                 'Cancel',
                                          //                 style: TextStyle(
                                          //                     color: Colors.black),
                                          //               ),
                                          //               onPressed: () {
                                          //                 Navigator.pop(context);
                                          //               },
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       );
                                          //     },
                                          //     child: Chip(
                                          //       label: Text(
                                          //         "Tap to show ${(_geocodingResultList.length - 1)} more result options",
                                          //       ),
                                          //     ),
                                          //   ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        )
                      : Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 30),
                              child: CircleAvatar(
                                backgroundColor: Color(0xff006B14),
                                radius: 18,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.black,
          ));
  }
}
