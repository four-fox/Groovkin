import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:map_location_picker/map_location_picker.dart';

import 'eventController.dart';
import 'venueDiscoveryModel.dart';

class RegisteredVenuePickerScreen extends StatefulWidget {
  const RegisteredVenuePickerScreen({super.key});

  @override
  State<RegisteredVenuePickerScreen> createState() =>
      _RegisteredVenuePickerScreenState();
}

class _RegisteredVenuePickerScreenState
    extends State<RegisteredVenuePickerScreen> {
  final EventController controller = Get.find<EventController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.extentAfter < 250) {
        controller.loadMoreVenues();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeVenuePicker();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: 'Choose Venue'),
      body: GetBuilder<EventController>(
        builder: (state) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: TextField(
                onChanged: state.setVenueSearch,
                decoration: InputDecoration(
                  hintText: 'Search registered Groovkin venues',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            _LocationMessage(state: state),
            if (state.hasVenueLocation)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [10, 25, 50]
                      .map(
                        (radius) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: ChoiceChip(
                              label: Text('$radius mi'),
                              selected: state.venueRadius == radius,
                              onSelected: (_) => state.setVenueRadius(radius),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: SegmentedButton<VenuePickerViewMode>(
                segments: const [
                  ButtonSegment(
                    value: VenuePickerViewMode.list,
                    label: Text('List'),
                    icon: Icon(Icons.list),
                  ),
                  ButtonSegment(
                    value: VenuePickerViewMode.map,
                    label: Text('Map'),
                    icon: Icon(Icons.map_outlined),
                  ),
                ],
                selected: {state.venuePickerViewMode},
                onSelectionChanged: (selection) =>
                    state.setVenuePickerViewMode(selection.first),
              ),
            ),
            if (state.venueDiscoveryError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  state.venueDiscoveryError!,
                  style: TextStyle(color: DynamicColor.lightRedClr),
                ),
              ),
            Expanded(
              child: state.venuePickerViewMode == VenuePickerViewMode.list
                  ? _VenueList(
                      state: state,
                      scrollController: scrollController,
                    )
                  : _VenueMap(state: state),
            ),
            if (state.selectedVenue != null)
              _SelectedVenueBar(
                venue: state.selectedVenue!,
                onContinue: () => Get.toNamed(
                  Routes.eventPreview,
                  arguments: {'viewDetails': 1},
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationMessage extends StatelessWidget {
  const _LocationMessage({required this.state});

  final EventController state;

  @override
  Widget build(BuildContext context) {
    String? message;
    switch (state.venueLocationState) {
      case VenueLocationState.denied:
        message = 'Enable location to see nearby venues.';
        break;
      case VenueLocationState.deniedForever:
        message = 'Location permission is disabled in Settings.';
        break;
      case VenueLocationState.serviceDisabled:
        message = 'Location services are disabled.';
        break;
      case VenueLocationState.unavailable:
        message = 'Location is unavailable. Search venues by name.';
        break;
      default:
        message = null;
    }
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(message)),
          TextButton(
            onPressed:
                state.venueLocationState == VenueLocationState.deniedForever ||
                        state.venueLocationState ==
                            VenueLocationState.serviceDisabled
                    ? state.openVenueLocationSettings
                    : state.acquireVenueLocation,
            child: Text(
              state.venueLocationState == VenueLocationState.deniedForever
                  ? 'Settings'
                  : 'Enable Location',
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueList extends StatelessWidget {
  const _VenueList({required this.state, required this.scrollController});

  final EventController state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (state.venueListLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!state.canDiscoverVenues) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Enable location to see nearby venues, or enter at least two characters to search by venue name.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (state.discoveredVenues.isEmpty) {
      return Center(
        child: Text(
          state.hasVenueLocation
              ? 'No Groovkin venues found within ${state.venueRadius} miles.\nTry increasing the distance.'
              : 'No registered Groovkin venues found.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: state.refreshVenueDiscovery,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.discoveredVenues.length +
            (state.venuePaginationLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.discoveredVenues.length) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final venue = state.discoveredVenues[index];
          return _VenueCard(
            venue: venue,
            selected: state.selectedVenue?.id == venue.id,
            onSelect: () => state.selectVenue(venue),
          );
        },
      ),
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({
    required this.venue,
    required this.selected,
    required this.onSelect,
  });

  final CompactVenue venue;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final image = venue.image;
    final imageUrl = image == null
        ? null
        : image.startsWith('http')
            ? image
            : '${Url().imageUrl}$image';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        selected: selected,
        leading: CircleAvatar(
          backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl),
          child: imageUrl == null ? const Icon(Icons.location_city) : null,
        ),
        title: Text(venue.venueName ?? 'Groovkin venue'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (venue.addressLabel.isNotEmpty) Text(venue.addressLabel),
            if (venue.distance?.value != null)
              Text('${venue.distance!.value!.toStringAsFixed(1)} miles away'),
            if (venue.maxOccupancy != null)
              Text('Capacity: ${venue.maxOccupancy}'),
          ],
        ),
        trailing: FilledButton(
          onPressed: onSelect,
          child: Text(selected ? 'Selected' : 'Select'),
        ),
        onTap: onSelect,
      ),
    );
  }
}

class _VenueMap extends StatelessWidget {
  const _VenueMap({required this.state});

  final EventController state;

  @override
  Widget build(BuildContext context) {
    if (state.venueMapLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final fallback = state.venueMarkers.isNotEmpty
        ? LatLng(
            state.venueMarkers.first.latitude!,
            state.venueMarkers.first.longitude!,
          )
        : const LatLng(37.42796133580664, -122.085749655962);
    final center = state.hasVenueLocation
        ? LatLng(state.venueOriginLatitude!, state.venueOriginLongitude!)
        : fallback;
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: center, zoom: 10),
          myLocationEnabled: state.hasVenueLocation,
          myLocationButtonEnabled: state.hasVenueLocation,
          markers: state.venueMarkers
              .map(
                (venue) => Marker(
                  markerId: MarkerId(venue.id.toString()),
                  position: LatLng(venue.latitude!, venue.longitude!),
                  infoWindow: InfoWindow(title: venue.venueName ?? ''),
                  onTap: () => state.selectVenue(venue),
                ),
              )
              .toSet(),
        ),
        if (state.venueMarkersTruncated)
          const Positioned(
            top: 8,
            left: 12,
            right: 12,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'The map is showing the first 200 eligible venues. Use search or a smaller radius to narrow results.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SelectedVenueBar extends StatelessWidget {
  const _SelectedVenueBar({required this.venue, required this.onContinue});

  final CompactVenue venue;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black26,
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.venueName ?? 'Selected venue',
                    style: poppinsMediumStyle(
                      fontSize: 14,
                      context: context,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (venue.addressLabel.isNotEmpty) Text(venue.addressLabel),
                ],
              ),
            ),
            SizedBox(
              width: 140,
              child: CustomButton(
                text: 'Select Venue',
                borderClr: Colors.transparent,
                onTap: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
