// ignore_for_file: prefer_collection_literals

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:map_location_picker/map_location_picker.dart';


class ShowCustomMap extends StatefulWidget {
  ShowCustomMap({
    super.key,
    this.horizontalPadding,
    this.circle = false,
    this.lat = 37.42796133580664,
    this.lng = -122.085749655962,
  });

  double? horizontalPadding;
  bool circle = false;
  double? lat = 37.42796133580664;
  double? lng = -122.085749655962;

  @override
  _ShowCustomMapState createState() => _ShowCustomMapState();
}

class _ShowCustomMapState extends State<ShowCustomMap> {
  @override
  void initState() {
    super.initState();
    print("As");
    moveToPosition(LatLng(widget.lat!, widget.lng!));
  }

  @override
  void didUpdateWidget(covariant ShowCustomMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    moveToPosition(LatLng(widget.lat!, widget.lng!));
  }

  Completer<GoogleMapController> controllerGoogleMap = Completer();
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(widget.lat!, widget.lng!),
      zoom: 14.4746,
    );

    Set<Circle> circles = {
      if (widget.circle)
        Circle(
          circleId: CircleId('myPosition1'),
          center: LatLng(
            widget.lat!,
            widget.lng!,
          ),
          radius: 500,
          fillColor: Colors.red.withOpacity(0.4),
          strokeWidth: 0,
        ),
    };

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 12.0),
      child: Container(
        height: kToolbarHeight * 3.8,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            markers: Set<Marker>.of(
              <Marker>[
                Marker(
                  draggable: true,
                  markerId: MarkerId("1"),
                  position: LatLng(
                    widget.lat!,
                    widget.lng!,
                  ),
                  icon: BitmapDescriptor.defaultMarker,
                  onDragEnd: (newPosition) {
                    moveToPosition(newPosition);
                  },
                )
              ],
            ),
            myLocationButtonEnabled: true,
            circles: circles,
            initialCameraPosition: kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              controllerGoogleMap.complete(controller);
              googleMapController = controller;
              // Move the camera once the map is created
              moveToPosition(LatLng(widget.lat!, widget.lng!));
            },
          ),
        ),
      ),
    );
  }

  Future<void> moveToPosition(LatLng position) async {
    print("New Posiotn");
    final GoogleMapController controller = await controllerGoogleMap.future;
    CameraPosition newCameraPosition =
        CameraPosition(target: position,   zoom: 15.4746,);

    controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }
}

class DisclaimerView extends StatelessWidget {
  DisclaimerView({
    Key? key,
    this.onTap,
  }) : super(key: key);

  RxBool acceptTerms = false.obs;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      width: Get.width,
      height: Get.height / 1.3,
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Text(
            "Disclaimer",
            style: poppinsMediumStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          Text(
            '“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” “Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”',
            style: poppinsRegularStyle(
              fontSize: 12,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: theme.primaryColor,
                  ),
                  child: SizedBox(
                    width: 25,
                    child: Checkbox(
                        activeColor: DynamicColor.lightRedClr,
                        value: acceptTerms.value,
                        onChanged: (v) {
                          acceptTerms.value = !acceptTerms.value;
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: SizedBox(
                  width: Get.width / 1.5,
                  child: Text(
                    'i have read and agree to the terms and conditions',
                    style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: CustomButton(
              heights: 35,
              onTap: onTap,
              widths: Get.width,
              text: "Accept",
              borderClr: Colors.transparent,
              backgroundClr: false,
              color2: DynamicColor.greenClr,
              color1: DynamicColor.greenClr,
            ),
          )
        ],
      ),
    );
  }
}

eventStatusWidget({
  theme,
  context,
  text,
  Color? color,
  Color? textClr,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: EdgeInsets.all(6),
        child: ImageIcon(
          AssetImage("assets/pin.png"),
          color: theme.primaryColor,
        ),
      ),
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
            image: color == null
                ? DecorationImage(
                    image: AssetImage("assets/topbtnGradent.png"),
                    fit: BoxFit.fill)
                : null,
            color: color),
        child: Center(
          child: Text(
            text ?? "Event Completed",
            style: poppinsRegularStyle(
              fontSize: 11,
              context: context,
              color: textClr ?? theme.scaffoldBackgroundColor,
            ),
          ),
        ),
      )
    ],
  );
}

eventOrganizer(
    {theme,
    context,
    GestureTapCallback? onTap,
    String? name,
    String? location,
    bool iconShow = false,
    Color? iconClr}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DynamicColor.blackClr,
              shape: BoxShape.circle,
              border: Border.all(color: DynamicColor.lightYellowClr),
            ),
            child: Image(
              image: AssetImage("assets/eventOrganizer.png"),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Townsquare',
                  style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: Get.width / 1.5,
                  child: Row(
                    children: [
                      iconShow == false
                          ? SizedBox.shrink()
                          : Icon(
                              Icons.location_on_sharp,
                              color: iconClr,
                              size: 18,
                            ),
                      Text(
                        location ?? 'Event Organizer',
                        style: poppinsRegularStyle(
                            fontSize: 12,
                            context: context,
                            color: DynamicColor.grayClr.withOpacity(0.6),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
