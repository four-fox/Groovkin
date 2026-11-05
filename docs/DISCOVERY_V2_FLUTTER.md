# Groovkin Flutter — Event Discovery V2

Discovery V2 is off unless the app is compiled with an explicit Dart define. Production builds keep calling the existing routes.

## Switch

Enable V2 for a build:

```bash
flutter run --dart-define=DISCOVERY_V2_ENABLED=true
flutter build apk --debug --dart-define=DISCOVERY_V2_ENABLED=true
```

The define is read by `DiscoveryConfig.compileTime` in `lib/discovery/discovery_config.dart`. The default is `false`.

When the define is true, the user home recommendations call `GET /api/v2/events/recommended` and user event search calls `GET /api/v2/events/search`. Both send the existing Sanctum bearer token through `API.getApi`.

## Rollback

1. Ship a build without `DISCOVERY_V2_ENABLED`, or set it to `false`.
2. That build never calls the V2 routes.
3. A V2 build that receives HTTP 403 with `error_code: discovery_v2_disabled` calls the matching old route once and remembers the disabled state until the user pulls to refresh.
4. Pull-to-refresh clears that memory and tries V2 one more time. A disabled response falls back again. It does not retry V2 in a loop inside one request.
5. HTTP 403 with any other `error_code` is shown as an error. It does not use the old route.

Old routes that remain in place:

- `GET /api/recommended-for-you-events`
- `GET /api/search-events`

The V1 fallback for search sends the text (or the ZIP text when that is all the user entered) as `search`. Activity ids, music ids, sort, and radius are not applied by the old route. The debug log records that those filters were dropped.

## What Flutter sends

Recommended query: `page`, `per_page` (12), `radius`, and `latitude`/`longitude` only when both coordinates are valid. `(0, 0)` and a single coordinate are omitted. The GET does not save the radius.

Radius changes are saved with the existing `POST /api/update-profile/{id}` body `search_radius_miles` only. ZIP and location fields are not sent with that request. If the save fails, the selected radius is used for the next recommendation request and the screen says it was not saved. The last successful value stays in storage.

Search query uses Dio query parameters, so `#hiphop` is encoded as `%23hiphop` and is not treated as a URL fragment. A value that starts with `#` is sent as `q`. A complete five-digit ZIP is sent as the string `postal_code`. `08` is not sent. Multiple activities are sent as repeated `activity_ids[]`. Music uses `music_genre_id` from the existing `music_genre` catalog, or `music` text when that catalog is empty. Activities use `activity_choice` item ids, not music survey ids.

Sort values are `relevance`, `nearest`, `soonest`, and `newest`. Nearest stays disabled until a valid location exists.

## Location

The app checks the current permission once per feed session. It does not ask again on every refresh and it does not track in the background. A denied permission leaves coordinates off the request so the backend can use a saved profile location. `location_status: unavailable` with an empty list shows a location message and a button that opens the existing permission flow. ZIP-only search does not claim a radius.

## Lists

Ordering is the order returned by the backend. Cards show `discovery.reason_labels[].label` or `search.reason_labels[].label`. `match_type: personalized` is labeled "For you". `match_type: discovery` is labeled "Explore nearby" and is not described as a preference match unless a backend label says so. `distance_miles: null` does not show `0 mi`.

`data.meta.next_page == null` stops pagination. A changed query replaces the list and ignores older responses. Typing is debounced by 600 ms. HTTP 429 shows a retry message and does not retry by itself.

`invalidate_lists` values `v2-events-recommended` and `v2-events-search` refresh the matching list when a mutation response includes them. The app does not add a new Socket.IO subscription. There is no socket handler in this repository that delivers those keys, so a cancelled event leaves the open list until the next refresh or a mutation response that contains the key. User-role mutations already refresh recommendations through the existing home invalidation.

## Tests

```bash
flutter test test/discovery_v2_test.dart
```

These tests use a scripted HTTP transport. They do not prove live backend ranking.

## Manual checks

Use a user with Hip-Hop and a Fitness lifestyle, an organizer event inside the selected radius, and `DISCOVERY_V2_ENABLED=true` against a backend with `DISCOVERY_V2_ENABLED=true`.

1. Music match shows the backend music label and distance.
2. A Jazz event with `#fitness` shows the interest label without requiring a music match.
3. An event with both signals shows each returned label.
4. A 100-mile event disappears at a 25-mile radius.
5. Raising the radius from 10 to 25 requests recommendations again. The profile save is only `search_radius_miles`.
6. `#hiphop` returns hashtag matches and does not label a title-only hit as a hashtag match.
7. An activity filter returns events for that activity.
8. ZIP `08861` is exact. The screen says no radius was applied.
9. ZIP plus coordinates plus radius sends all three.
10. After a cancel, refresh the list. The event is gone when the backend omits it.
11. A user with no preferences sees "Explore nearby", not "For you".
12. With the backend flag off, the home screen uses the old routes and does not loop.
13. Denied location still allows saved profile coordinates. Otherwise the location message is shown.
14. Login, registration, profile ZIP eligibility, event details, chat, booking, and payments are unchanged.
