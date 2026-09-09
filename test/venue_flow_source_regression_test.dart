import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  String source(String path) => File(path).readAsStringSync();

  test('EO venue entry no longer opens Google Places', () {
    final comments = source(
      'lib/View/bottomNavigation/homeTabs/eventsFlow/commentsAndAttechment.dart',
    );
    final continueSection = comments.substring(
      comments.indexOf('class _CommentsAndAttachmentState'),
      comments.indexOf('\nassetImage('),
    );

    expect(continueSection, isNot(contains('MapLocationPicker(')));
    expect(continueSection, contains('Routes.listOfVenuesScreen'));
  });

  test('registered picker uses only Groovkin discovery endpoints', () {
    final repository = source(
      'lib/View/bottomNavigation/homeTabs/eventsFlow/venueDiscoveryRepository.dart',
    );

    expect(repository, contains("'discover-venues'"));
    expect(repository, contains("'discover-venues/markers'"));
    expect(repository, isNot(contains('show-venues-by-distance')));
    expect(repository, isNot(contains('GooglePlace')));
  });

  test('VM add and edit geocoding remains available', () {
    final createUi =
        source('lib/View/GroovkinManager/createCompanyProfile.dart');
    final editUi =
        source('lib/View/GroovkinManager/venueDetailsManagerFlow.dart');
    final controller =
        source('lib/View/GroovkinManager/managerController.dart');

    expect(createUi, contains('MapLocationPicker('));
    expect(editUi, contains('MapLocationPicker('));
    expect(controller, contains('"add-venue"'));
    expect(controller, contains('"edit-venue/'));
    expect(controller, contains('"location": addressController.text'));
    expect(controller, contains('"latitude": double.parse(lat)'));
    expect(controller, contains('"longitude": double.parse(lng)'));
  });

  test('recommendation UI adds no match percentage', () {
    final home = source(
      'lib/View/GroovkinUser/UserBottomView/userHome.dart',
    );
    final all = source(
      'lib/View/GroovkinUser/UserBottomView/viewAllRecommendedEventScreen.dart',
    );

    expect(home, isNot(contains('match_percentage')));
    expect(home, isNot(contains('% Match')));
    expect(all, isNot(contains('match_percentage')));
    expect(all, isNot(contains('% Match')));
  });

  test('event submission uses registered venue identity and draft publish', () {
    final controller = source(
      'lib/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart',
    );
    final createStart = controller.indexOf('postEventFunction(');
    final editStart = controller.indexOf('editEventFunction()');
    final createSection = controller.substring(createStart, editStart);
    final editEnd = controller.indexOf('///delete image', editStart);
    final editSection = controller.substring(editStart, editEnd);

    expect(createSection, contains('"venue_id": selectedVenue!.id'));
    expect(createSection, isNot(contains('"venue_user_id"')));
    expect(editSection, contains('if (publishingDraft) "venue_id"'));
    expect(editSection, contains('if (publishingDraft) "save_draft": false'));
  });

  test('venue request decline uses declined and not rejected', () {
    final pending = source(
      'lib/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/pendingDetailsScreen.dart',
    );

    expect(pending, contains("status: 'declined'"));
    expect(pending, contains('Venue request declined'));
    expect(pending, isNot(contains("status: 'rejected'")));
  });
}
