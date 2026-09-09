# Flutter Event Matching and Venue Picker Implementation Report

## 1. Existing Flutter Architecture Found

Groovkin uses GetX controllers, `GetBuilder`/reactive values, and named GetX
routes. Authenticated API traffic goes through the singleton Dio client in
`lib/Components/Network/API.dart`, which reads the Sanctum token from
`GetStorage` and sends it as a Bearer token.

Relevant ownership remains:

- `HomeController`: user feeds, Recommended for You, preference updates.
- `EventController`: event create/edit and the Event Organizer venue picker.
- `AuthController`: initial survey and follow/unfollow.
- `ManagerController`: Venue Manager venue CRUD and event-request response.
- `app_pages.dart`: named navigation.

## 2. Files Changed

Feature implementation files:

- `lib/Components/Network/backend_error.dart`: added safe multi-shape backend
  validation-message extraction.
- `lib/Components/Network/interceptors_service.dart`: uses the safe error
  extractor instead of assuming `data` is a string.
- `lib/Components/customEventWidget.dart`: supports an optional qualitative
  recommendation reason.
- `lib/Routes/app_pages.dart`: routes EO venue selection to the registered
  venue picker.
- `lib/View/authView/autController.dart`: invalidates recommendations after
  initial preferences and follow/unfollow.
- `lib/View/bottomNavigation/homeController.dart`: canonical recommendation
  query, pagination, deduplication, race protection, radius/location, refresh,
  and preference invalidation.
- `lib/View/GroovkinUser/UserBottomView/userHome.dart`: recommendation radius
  presets and reason display.
- `lib/View/GroovkinUser/UserBottomView/viewAllRecommendedEventScreen.dart`:
  safe pagination, refresh, legacy-list compatibility, and reason display.
- `lib/View/GroovkinUser/searchFilterScreen.dart`: propagates relevant
  location changes to recommendation invalidation.
- `lib/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart`:
  optional recommendation metadata and distance.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/venueDiscoveryModel.dart`:
  compact venue, paginator, marker, radius, and origin models.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/venueDiscoveryRepository.dart`:
  `discover-venues` and `discover-venues/markers` API integration.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/registeredVenuePickerScreen.dart`:
  EO list/map/radius/search/selection UI.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/commentsAndAttechment.dart`:
  removes Google Places from the active EO selection journey.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart`: venue
  picker state, location permissions, request safety, `venue_id` submission,
  draft publishing, stale venue handling, hashtag detach, and tag semantics.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/hashtagCollectionModel.dart`:
  fixes null-versus-empty multipart semantics.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/hashtagCollectionRepository.dart`:
  adds event-scoped hashtag detach.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/musicChoiceView/musicChoiceScreen.dart`:
  uses the safe async chip removal path.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/eventPreviewScreen.dart`:
  previews the selected compact venue and preserves legacy location fallback.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/confimationEvent.dart`:
  confirms the selected registered venue safely.
- `lib/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/pendingDetailsScreen.dart`:
  submits `declined`, displays declined state, and disables stale actions.
- `lib/View/bottomNavigation/homeTabs/upcomingScreen.dart`: identifies draft
  publishing so `update-event` can require/send a venue.
- `test/event_matching_and_venue_models_test.dart`: recommendation, distance,
  venue, marker, and error-envelope coverage.
- `test/venue_flow_source_regression_test.dart`: EO/VM separation, endpoint,
  and no-match-percentage regression coverage.

Existing uncommitted native icon, API-key, and payment work was preserved.

## 3. Recommended for You

Flutter calls `GET recommended-for-you-events` and preserves backend order. It
does not filter by follow state and performs no local scoring or ranking.
Queries send `page` and `radius`; valid non-zero current coordinates are added
when already available. Pagination continues while `current_page < last_page`
and appends unique event IDs.

Radius changes, pull-to-refresh, preference changes, follow changes, relevant
location changes, and event-tag edits fetch a fresh page 1. Generation counters
prevent an older response from replacing newer state.

## 4. Recommendation Models

`EventData.recommendation` is optional and parses:

- `reasons`
- `matched_music` as `MatchedPreference`
- `matched_activities` as `MatchedPreference`
- `matched_hashtags` as `MatchedHashtag`

Only the six documented reason enums are retained. Missing/null arrays and a
missing recommendation object are safe. Optional top-level numeric `distance`
is parsed without becoming required.

## 5. Preference Refresh Logic

Successful `create-quick-survey` and `update-quick-survey` calls invalidate and
refetch recommendations. Existing follow/unfollow calls do the same. The app
does not implement the legacy hashtag-preference save endpoints because the
audited Flutter application had no existing integration for them.

## 6. Hashtag Removal

Deleting a persisted manual hashtag from Event Edit calls:

`POST remove-event-hashtag`

with `event_id` and display `name`. The chip is removed only after HTTP 200.
HTTP 403 shows the authorization message without retry. HTTP 404 refreshes the
event. HTTP 422 keeps the chip and shows the backend validation message.
`remove-tag-collection` remains limited to organizer collection management.

## 7. Event Tag Update Semantics

For `manual_hashtags` and `collection_ids`:

- null/unchanged omits the key;
- a populated list sends repeated array fields;
- an intentional empty list sends an explicit empty-array value.

Music genre, music choice, and activity choice update keys are omitted when
untouched. Changed selections use the existing parallel-array update contract;
an intentional clear sends empty arrays. Create-event tag serialization remains
on its existing create contract.

## 8. Old EO Venue Flow

The active EO flow no longer opens `MapLocationPicker`, Places autocomplete,
typed address search, or arbitrary Google results. The registered picker does
not use `show-venues`, `show-venues-by-distance`, or `filter-venues`.

## 9. New Venue Picker

The GetX picker owns one canonical state for:

- permission/service state and device coordinates;
- 10/25/50-mile radius;
- debounced registered venue-name search;
- paginated compact list and non-paginated markers;
- list/map mode;
- one selected venue ID;
- loading, refresh, errors, truncation, and request generation.

List and map use the same query and selection. A pure view toggle does not
refetch. Radius/search/location changes reset page 1 and refresh both datasets.
Duplicate venue IDs are not appended.

When location is unavailable, the user can search registered venues by name
after two characters. Empty nearby results suggest increasing the radius.

## 10. Google Integration

For Event Organizers, Google Maps is visualization only. Marker candidates,
titles, coordinates, and identity all come from
`GET discover-venues/markers`.

Venue Manager add/edit continues using the existing `MapLocationPicker`,
geocoding, and `location`/`latitude`/`longitude` payloads. Google dependencies
were intentionally retained.

## 11. Event Submission

Non-draft `create-event` now requires the selected compact venue and sends:

`venue_id = selectedVenue.id`

The new EO path does not send a Google place ID, search-center coordinates, or
`venue_user_id` as venue identity. Existing dates, payment schedule, media,
services, hardware, tags, and hashtag fields remain in the request.

## 12. Draft Behavior

Draft save can omit `venue_id`; a selected venue is included. Draft publishing
uses `update-event`, accepts an already stored `venue_id`, otherwise opens the
registered picker, and sends `save_draft: false`. Published-event edit does not
offer or submit a venue change.

## 13. Venue Request Status

Create success states that the venue request was sent and is waiting for the
Venue Manager. Existing paid acceptance remains unchanged. Pending VM decline
actions send `status: declined` to `accept-event-request`; declined UI says
“Venue request declined.” No venue-request code uses `rejected`.

## 14. Error Handling

The implementation handles non-uniform validation envelopes by preferring a
specific field error, then string `data`, then `message`, then a generic
fallback. It covers invalid discovery input, location failures, radius errors,
hashtag 403/404/422 responses, network failures, and stale/unavailable venue
422 responses. A stale venue is cleared and discovery is refreshed; the same
ID is not retried automatically.

## 15. Backward Compatibility

Event list/detail/preview code tolerates a null registered venue and falls back
to the historical top-level event location. Non-recommendation APIs tolerate
missing recommendation metadata. VM geocoding and payment acceptance were not
replaced.

## 16. Automated Tests

Commands executed:

- `flutter test test/event_matching_and_venue_models_test.dart test/hashtag_collection_model_test.dart test/venue_flow_source_regression_test.dart`
- `flutter test`
- `flutter analyze`

Results:

- Focused recommendation/venue/hashtag tests: passed.
- Full Flutter suite: **94 tests passed**.
- Flutter analyzer: **No issues found**.
- `git diff --check`: passed.

## 17. Manual QA

Authenticated manual User/EO/VM E2E was not executed because no test accounts
or authenticated simulator session were supplied. The agreed QA approach was
automated verification with this limitation documented.

## 18. Remaining Issues

- Authenticated backend E2E remains to be run with suitable test accounts.
- Legacy EO venue-list classes/endpoints remain in source for compatibility,
  but no active event-create route uses them.

## 19. Backend Dependencies Found

There is no backend API for changing the venue on an already-published event.
Flutter therefore does not present a fake “Choose another venue” persistence
flow after decline or during published edit.
