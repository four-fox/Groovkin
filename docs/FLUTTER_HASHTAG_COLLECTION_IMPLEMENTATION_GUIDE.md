# Flutter Hashtag Collection Implementation Guide

This guide is the source of truth for implementing the Event Organizer hashtag collection changes in the Flutter mobile application.

## Part A - Document Purpose
The Laravel backend now supports Event Organizer private named hashtag collections, manual event-only hashtags, event-level hashtag snapshots, and mandatory hashtag validation for submitted non-draft events.

The Flutter developer must implement the mobile UI, models, API calls, state management, validation, and tests needed for Event Organizers to:

- Create, update, list, filter, select, and remove private named collections.
- Enter manual event hashtags during event create/edit.
- Attach one or more collections to an event.
- Display collection hashtags as locked at event level.
- Display flattened public event hashtags.
- Preserve regular-user legacy Music Choice and Activity Choice screens.

This guide does not include backend implementation work, final regular-user preference matching, recommendation scoring, match reasons, or match percentages.

Intended Event Organizer workflow:

1. Open event create or edit.
2. Enter manual hashtags, select collections, or both.
3. Create a new collection from the picker if needed.
4. Submit the event only when non-draft hashtag validation passes.
5. Edit manual hashtags individually later.
6. Remove collection-origin hashtags only by removing the whole selected collection.

Intended regular-user behavior:

- Continue using existing global Music Choice and Activity Choice preference screens.
- Continue viewing flattened event hashtags.
- Do not see private organizer collection management UI.
- Do not see preference match scores because backend matching is not implemented.

Pending requirement:

Regular-user Music Choice / Activity Choice to Event Organizer hashtag matching is still pending client confirmation and is not implemented by the backend.

## Part B - Cursor Instructions For Studying The Flutter Project
Before implementing, inspect only relevant Flutter files and patterns. Identify:

- Existing API client and base response parsing.
- Authentication token handling.
- Active role handling.
- Event create flow.
- Event edit flow.
- Event details screen.
- Event models.
- Repository/service layer.
- State-management solution.
- Navigation system.
- Form validation conventions.
- Reusable chip/tag widgets.
- Loading and error widgets.
- Existing Music Choice and Activity Choice screens.
- Existing hashtag-related code.

Use targeted searches:

```text
event-tags
my-tags-collection
add-tag-collection
remove-tag-collection
create-event
update-event
recommended-for-you-events
hashtag
music_choice
activity_choice
event_owner
activeRole
EventModel
CreateEvent
UpdateEvent
```

Implementation constraints:

- Do not replace the existing state-management package.
- Do not introduce a new networking package.
- Do not rewrite unrelated event screens.
- Reuse current app architecture and naming conventions.
- Preserve existing working Music Choice and Activity Choice preference screens.
- Do not add code-generation packages unless the app already uses them.
- Do not change Flutter SDK constraints unless required by the existing project.

## Part C - Backend API Contract Summary
Base path: `/api`

Most endpoints use:

```json
{
  "status": true,
  "data": {},
  "message": "Message"
}
```

Some validation failures include:

```json
{
  "status": false,
  "data": "First validation message",
  "message": "Validation Failed",
  "errors": {
    "field": "Field validation message"
  }
}
```

### GET `/api/event-tags`
Purpose: list global admin-defined Music Choice and Activity Choice tags.

Allowed role: authenticated users.

Authentication: Sanctum bearer token.

Query parameters:

- `type`: usually `music_choice` or `activity_choice`.

Request fields: none.

Success response: existing global tag response with category items and user selection state. This endpoint was not converted to organizer private collections.

Empty response: `data` may be an empty array when no global tags exist for the filter.

Validation errors: not specifically added for this feature.

Authorization errors: standard `401` unauthenticated.

HTTP status codes: `200`, `401`, possible `500`.

Flutter action required: keep existing legacy/global Music Choice and Activity Choice code using this endpoint.

Backward compatibility: unchanged.

### GET `/api/my-tags-collection`
Purpose: list the authenticated user's tag collection. For active Event Organizers this returns private named collections. For regular users this preserves the legacy grouped global tag response.

Allowed role: authenticated users.

Authentication: Sanctum bearer token.

Query parameters:

- `type=music_choice`
- `type=activity_choice`

Request fields: none.

Event Organizer success response:

```json
{
  "status": true,
  "data": [
    {
      "id": 4,
      "title": "80s Rock Music",
      "type": "music_choice",
      "is_active": true,
      "hashtags_count": 3,
      "events_count": 2,
      "hashtags": [
        {
          "id": 15,
          "name": "BonJovi",
          "display_name": "#BonJovi"
        }
      ],
      "created_at": "2026-07-06T09:00:00.000000Z",
      "updated_at": "2026-07-06T09:00:00.000000Z"
    }
  ],
  "message": "Show Tags Collection successfully"
}
```

Empty response:

```json
{
  "status": true,
  "data": [],
  "message": "Show Tags Collection successfully"
}
```

Validation errors: none specific to this endpoint.

Authorization errors: `401` unauthenticated.

HTTP status codes: `200`, `401`, possible `500`.

Flutter action required: Event Organizer collection list and picker must use this endpoint. Regular-user preference screens should not be migrated to this collection UI.

Backward compatibility: regular users keep the legacy grouped global response shape.

### GET `/api/my-tags-collection-by-id/{id}`
Purpose: fetch one collection. For Event Organizers, `{id}` is a private collection ID. For regular users, legacy behavior is preserved.

Allowed role: authenticated users.

Authentication: Sanctum bearer token.

Path parameters:

- `id`: Event Organizer collection ID when active role is `event_owner`.

Request fields: none.

Event Organizer success response:

```json
{
  "status": true,
  "data": {
    "id": 4,
    "title": "80s Rock Music",
    "type": "music_choice",
    "is_active": true,
    "hashtags_count": 3,
    "events_count": 2,
    "hashtags": [
      {
        "id": 15,
        "name": "BonJovi",
        "display_name": "#BonJovi"
      }
    ],
    "created_at": "2026-07-06T09:00:00.000000Z",
    "updated_at": "2026-07-06T09:00:00.000000Z"
  },
  "message": "Show Tags Collection successfully"
}
```

Empty response: not applicable for Event Organizer detail. Missing or cross-organizer collection returns `404`.

Authorization errors:

```json
{
  "status": false,
  "data": "Collection not found.",
  "message": "Not Found"
}
```

HTTP status codes: `200`, `401`, `404`, possible `500`.

Flutter action required: use for edit collection screen if the list data is stale or incomplete.

Backward compatibility: regular-user legacy lookup remains.

### POST `/api/add-tag-collection`
Purpose: create or update one complete Event Organizer collection. The same endpoint is also used by regular-user legacy preference collection payloads.

Allowed role: active `event_owner` for collection fields. Regular users can still use the old `type` plus `event_tag_item_ids` payload.

Authentication: Sanctum bearer token.

Create request fields:

```json
{
  "title": "80s Rock Music",
  "type": "music_choice",
  "hashtags": ["BonJovi", "Hairbands", "Metallica"]
}
```

Update request fields:

```json
{
  "collection_id": 4,
  "title": "Classic 80s Rock",
  "type": "music_choice",
  "hashtags": ["BonJovi", "Metallica", "DefLeppard"]
}
```

Optional field:

```json
{
  "hashtags_text": "BonJovi, Hairbands, Metallica"
}
```

Canonical Flutter implementation should use `hashtags` array, not `hashtags_text`.

Required fields for organizer collection create/update:

- `title`: required string, max 160.
- `type`: required, `music_choice` or `activity_choice`.
- At least one valid hashtag from `hashtags` or `hashtags_text`.

Success response:

```json
{
  "status": true,
  "data": {
    "id": 4,
    "title": "Classic 80s Rock",
    "type": "music_choice",
    "is_active": true,
    "hashtags_count": 3,
    "events_count": 0,
    "hashtags": [
      {
        "id": 15,
        "name": "BonJovi",
        "display_name": "#BonJovi"
      }
    ],
    "created_at": "2026-07-06T09:00:00.000000Z",
    "updated_at": "2026-07-06T09:00:00.000000Z"
  },
  "message": "Collection updated successfully."
}
```

Create message: `Collection created successfully.`

Validation errors:

- Missing title: `422`, `message: "Validation Failed"`.
- Invalid type: `422`, `message: "Validation Failed"`.
- Empty hashtags:

```json
{
  "status": false,
  "data": "At least one hashtag is required.",
  "message": "Validation Failed",
  "errors": {
    "hashtags": "At least one hashtag is required."
  }
}
```

Wrong role:

```json
{
  "status": false,
  "data": "Only Event Organizers can manage organizer hashtags.",
  "message": "Forbidden"
}
```

Update another organizer's collection:

```json
{
  "status": false,
  "data": "Collection not found.",
  "message": "Not Found"
}
```

HTTP status codes: `200`, `401`, `403`, `404`, `422`, possible `500`.

Flutter action required: create and edit collection forms should call this endpoint.

Backward compatibility: regular-user legacy preference payloads still work:

```json
{
  "type": "music_choice",
  "event_tag_item_ids": [1, 2]
}
```

### POST `/api/remove-tag-collection`
Purpose: remove or deactivate whole Event Organizer collections. It does not remove one hashtag item from an event.

Allowed role: active `event_owner` for collection removal. Regular users can still use legacy removal by `event_tag_item_ids`.

Authentication: Sanctum bearer token.

Request fields:

```json
{
  "collection_ids": [4]
}
```

Single value is also supported:

```json
{
  "collection_id": 4
}
```

Success when unused collection is deleted:

```json
{
  "status": true,
  "data": {
    "deleted": 1,
    "deactivated": 0
  },
  "message": "Collection(s) deleted successfully."
}
```

Success when used collection is deactivated:

```json
{
  "status": true,
  "data": {
    "deleted": 0,
    "deactivated": 1
  },
  "message": "Used collection(s) were deactivated to preserve event history."
}
```

Validation error when no IDs:

```json
{
  "status": false,
  "data": "No collection IDs were provided.",
  "message": "Validation Failed"
}
```

Wrong owner or unknown ID:

```json
{
  "status": false,
  "data": "No matching collections were found.",
  "message": "Not Found"
}
```

HTTP status codes: `200`, `401`, `403`, `404`, `422`, possible `500`.

Flutter action required: call this from collection delete/remove UI; refresh list after success.

Backward compatibility: regular-user legacy removal remains:

```json
{
  "event_tag_item_ids": [10]
}
```

### POST `/api/create-event`
Purpose: create an event and optionally attach manual hashtags, selected collections, and deprecated legacy organizer private hashtags.

Allowed role: existing event create flow is for Event Organizers. Hashtag source fields require active `event_owner`.

Authentication: Sanctum bearer token.

Existing required event fields include title, featuring, about, dates, rate, rate type, payment schedule, and existing event flow fields. Non-draft create also requires the existing banner image validation.

New optional fields:

```json
{
  "manual_hashtags": ["FridayNight", "#Downtown"],
  "collection_ids": [4, 7]
}
```

Deprecated fields still accepted:

```json
{
  "hashtag_ids": [15]
}
```

Mandatory non-draft validation:

```text
manual_hashtags has at least one valid item
OR collection_ids has at least one active owned collection
OR deprecated hashtag_ids has at least one active owned legacy organizer hashtag
```

Draft behavior: `save_draft: "true"` may omit hashtag sources if the rest of the draft validation passes.

Success response: existing event object plus appended `hashtags`, `manual_hashtags`, and `hashtag_collections`.

Validation error for no hashtag source:

```json
{
  "status": false,
  "data": "Add at least one manual hashtag or select at least one hashtag collection before submitting this event.",
  "message": "Validation Failed",
  "errors": {
    "hashtags": "Add at least one manual hashtag or select at least one hashtag collection before submitting this event."
  }
}
```

Invalid collection selection:

```json
{
  "status": false,
  "data": "One or more selected collections do not belong to your account or are inactive.",
  "message": "Invalid collection selection.",
  "errors": {
    "collection_ids": "One or more selected collections do not belong to your account or are inactive."
  }
}
```

HTTP status codes: `200`, `401`, `403`, `422`, possible `500`.

Flutter action required: add `manual_hashtags` and `collection_ids` to event create payloads. Do not use deprecated legacy fields in new code.

Backward compatibility: old event create payloads are still supported where backend validation allows them, including drafts and deprecated organizer `hashtag_ids`.

### POST `/api/update-event`
Purpose: update an owned event and optionally replace manual hashtags or selected collections.

Allowed role: event owner of the event; hashtag source fields require active `event_owner`.

Authentication: Sanctum bearer token.

Required fields from current backend update validation:

- `event_id`
- `start_date_time`
- `end_date_time`
- `rate`
- `rate_type`
- `payment_schedule`

New fields:

```json
{
  "manual_hashtags": ["FridayNight"],
  "collection_ids": [4, 7]
}
```

Update semantics:

- Field omitted: preserve existing backend value for that source set.
- `manual_hashtags: []`: clear all manual hashtags.
- `collection_ids: []`: remove all selected collections.
- Non-empty `manual_hashtags`: replace manual hashtag set.
- Non-empty `collection_ids`: replace selected collection set and snapshot current collection items.
- Deprecated `hashtag_ids`: still accepted but must not be used by new Flutter code.

Mandatory validation: after applying omitted/empty/non-empty semantics, the event must still have at least one manual, collection, or deprecated legacy source.

Event ownership error:

```json
{
  "status": false,
  "data": "Event not found or you are not allowed to update it.",
  "message": "Not Found"
}
```

HTTP status codes: `200`, `401`, `403`, `404`, `422`, possible `500`.

Flutter action required: update event request builders must distinguish omitted fields from empty arrays.

Backward compatibility: existing update payload fields remain available. Legacy tag-choice payloads are still handled elsewhere in event update.

### GET `/api/recommended-for-you-events`
Purpose: return the existing regular-user recommendation feed.

Allowed role: authenticated user.

Authentication: Sanctum bearer token.

Query parameters:

- `latitude`
- `longitude`
- `radius` or `miles`

Backend behavior:

- Uses followed Event Organizers and followed Venue Managers.
- Applies public eligibility: `save_draft = false`, `status = accepted`, `accepted_by` is not null, `is_public = 1`, not expired.
- Excludes events reported by the viewer.
- Applies optional location radius when usable coordinates exist.

Success response: existing paginated event response with event objects and flattened `hashtags` appended by the `Event` model.

Flutter action required: do not display match percentage, match score, match reason, Music preference match, or Lifestyle preference match.

Backward compatibility: endpoint behavior is preserved.

## Part D - Flutter Data Models
Adapt these models to the project's existing model style. Use manual JSON parsing, `json_serializable`, Freezed, Equatable, Built Value, or existing custom base models according to what the app already uses. Do not add a new code-generation package just for this feature.

### Hashtag Collection
Fields:

```dart
int id;
String title;
String? type; // "music_choice", "activity_choice", or nullable for imported legacy collections
bool isActive;
int hashtagsCount;
int eventsCount;
List<HashtagCollectionItem> hashtags;
DateTime? createdAt;
DateTime? updatedAt;
```

JSON keys:

```text
id
title
type
is_active
hashtags_count
events_count
hashtags
created_at
updated_at
```

### Hashtag Collection Item
Fields:

```dart
int id;
String name;
String displayName;
```

JSON keys:

```text
id
name
display_name
```

### Event Hashtag
Public flattened hashtag fields:

```dart
String name;
String displayName;
```

The public `hashtags` array does not include `editable_at_event_level` and does not include `source_type`.

### Event Hashtag Collection
Organizer edit response fields:

```dart
int? id;
String? title;
String? type;
List<EventCollectionHashtag> hashtags;
```

Collection hashtag item in event-edit response:

```dart
String name;
String displayName;
bool editableAtEventLevel; // always false for collection-origin rows
```

The backend also currently includes `normalized_name` inside structured owner-only event hashtag rows. Flutter may parse it if useful for local duplicate checks, but it should not be required for display.

### Event Manual Hashtag
Organizer edit response fields:

```dart
String name;
String displayName;
bool editableAtEventLevel; // true for manual rows
```

Notes:

- Missing arrays default to empty lists.
- Nullable fields must be handled safely.
- Public responses may contain empty `hashtag_collections` and `manual_hashtags`.
- Organizer edit responses may contain structured source data.
- Flutter must not infer editability only from visual appearance.
- Use backend `editable_at_event_level` where available.
- Do not add `sourceType` to Flutter models unless the backend response actually returns `source_type`. Current event API response does not expose it.

## Part E - API Client And Repository Changes
Add API/repository methods equivalent to:

```dart
Future<List<HashtagCollection>> getHashtagCollections({
  String? type,
});

Future<HashtagCollection> getHashtagCollection(int id);

Future<HashtagCollection> createHashtagCollection(
  CreateHashtagCollectionRequest request,
);

Future<HashtagCollection> updateHashtagCollection(
  UpdateHashtagCollectionRequest request,
);

Future<CollectionRemovalResult> removeHashtagCollections(
  List<int> collectionIds,
);
```

Request model fields:

```dart
class CreateHashtagCollectionRequest {
  String title;
  String type; // music_choice or activity_choice
  List<String> hashtags;
}

class UpdateHashtagCollectionRequest {
  int collectionId;
  String title;
  String type;
  List<String> hashtags;
}
```

Event create/update request support:

```dart
List<String>? manualHashtags;
List<int>? collectionIds;
```

Critical update semantics:

- Field omitted: backend preserves existing value.
- Field sent as empty array: backend clears that source set.
- Non-empty array: backend replaces that source set.
- Deprecated `hashtag_ids`: do not use for the new Flutter implementation.

The future Cursor agent must verify how the current API client distinguishes omitted fields from fields sent as empty arrays. This distinction is critical for event updates.

Recommended serialization behavior:

- Event create: include `manual_hashtags` and `collection_ids` when the user has interacted with the hashtag step or when submitting non-draft.
- Event update: include a field only if that section changed, except when the user intentionally clears all values, in which case send `[]`.
- Never serialize `manual_hashtags: null` or `collection_ids: null` if the existing client treats null as an explicit field.

## Part F - Screens And User Flows
### 1. Event Hashtag Step
Event create/edit must provide:

```text
Manual Hashtags
Add a Collection
Selected Collections
```

Manual hashtag input:

- Use chip input if a reusable widget exists.
- Accept text with or without `#`.
- Add on comma, enter, or completed chip action according to existing UX.
- Trim spaces.
- Prevent duplicates locally using normalized comparison.
- Allow removal.
- Display validation errors.
- Do not save manual tags into a reusable collection.

Add a Collection opens the private collection picker.

### 2. Collection List And Picker Screen
Must include:

- Loading state.
- Error state.
- Empty state.
- Pull-to-refresh if consistent with the app.
- Music filter.
- Activity filter.
- All collections view if appropriate.
- Multiple selection checkboxes.
- Add New Collection action.
- Add to Event button.
- Existing event selections preselected during editing.

Empty state:

```text
No collections yet
Add New Collection
```

Each collection card should show:

- Title.
- Type.
- Hashtag preview.
- Hashtag count.
- Active/inactive state where returned.

Inactive collections must not be selectable for new event assignment.

### 3. Create Collection Screen
Required fields:

```text
Collection title
Collection type
Hashtag items
```

Collection type labels:

```text
Music
Activity
```

API values:

```text
music_choice
activity_choice
```

Input behavior:

- Support multiple hashtag items.
- Prefer a chip editor.
- Support comma-separated paste.
- Accept leading `#`.
- Prevent duplicates locally.
- Remove empty items.
- Display backend validation messages.

Submit canonical array format:

```json
{
  "title": "80s Rock Music",
  "type": "music_choice",
  "hashtags": [
    "BonJovi",
    "Hairbands",
    "Metallica"
  ]
}
```

After successful creation:

1. Return to collection picker.
2. Refresh the list.
3. Keep the new collection available for selection.
4. Automatically select it only if consistent with the desired UX.
5. Do not automatically submit the event.

### 4. Edit Collection Screen
Prefill:

- Collection title.
- Collection type.
- Collection hashtag items.

Submit through `/api/add-tag-collection` with `collection_id`.

Important: updating a collection does not update previously snapshotted event hashtags. Flutter must display event data returned by the event API and must not reconstruct old event hashtags from the current live collection.

### 5. Delete Or Deactivate Collection
Use `POST /api/remove-tag-collection`.

If backend returns:

```json
{
  "deleted": 0,
  "deactivated": 1
}
```

Flutter should:

- Show the backend message.
- Refresh collection state.
- Prevent the inactive collection from new selection.
- Not remove historical hashtags from old event displays.

### 6. Selected Collection Display On Event Form
Display each selected collection as a grouped block:

```text
80s Rock Music
#BonJovi #Hairbands #Metallica
```

Collection hashtags must be visually locked.

Allowed action:

```text
Remove Collection
```

Disallowed action:

```text
Remove only #BonJovi
```

Manual hashtags remain individually editable.

### 7. Event Edit Screen
When editing an event:

- Load `hashtag_collections`.
- Load `manual_hashtags`.
- Preselect collection IDs from `hashtag_collections[].id`.
- Prefill manual hashtag chips from `manual_hashtags`.
- Display collection items as locked.
- Allow removing an entire collection.
- Allow editing manual items.
- Submit replacement arrays only when those form sections changed.

Difference between no change and clear all:

- No change: omit `manual_hashtags` or `collection_ids`.
- Clear all: send `manual_hashtags: []` or `collection_ids: []`.

### 8. Public Event Cards And Details
Use flattened `hashtags`.

Do not render:

- Private collection management controls.
- Collection edit controls.
- Match percentages.
- Preference match reasons.

The public UI may render hashtags as chips or wrapped text according to existing design.

## Part G - Local Validation
Flutter should validate before calling the API.

For non-draft events:

```text
manual hashtags are not empty
OR selected collection IDs are not empty
```

For drafts:

- Allow missing hashtags if the current backend allows it.

Collection form validation:

- Collection title required.
- Valid collection type required.
- At least one hashtag item required.
- Duplicate hashtag prevention.
- Empty item removal.
- Inactive collections cannot be selected.

Ownership is always enforced by the backend. Backend errors must still be displayed even when local validation exists.

Local duplicate normalization should match backend intent:

- Trim whitespace.
- Remove leading `#`.
- Compare case-insensitively.
- Ignore spaces and punctuation for duplicate comparison where practical.

Examples considered duplicates:

```text
BonJovi
#BonJovi
bonjovi
BONJOVI
 BonJovi
```

## Part H - State Management
Use the existing project state-management architecture.

Required state categories:

```text
initial
loading
loaded
empty
submitting
success
validationError
authorizationError
networkError
unexpectedError
```

Keep separate logical states for:

- Collection list.
- Collection create/update.
- Collection removal.
- Event hashtag form state.
- Event submission.

Avoid mixing collection API loading with the entire event form loading when the app architecture supports independent state.

Preserve unsaved event form data when opening and returning from the collection picker.

## Part I - Error Handling
Handle:

```text
401 Unauthenticated
403 Wrong active role
404 Collection not found or not owned
422 Validation failure
500 Unexpected backend failure
network timeout
offline state
malformed response
```

Flutter should:

- Use the project's current error parser.
- Prefer `errors.*` messages.
- Fall back to `message`.
- Avoid displaying raw exception text.
- Keep unsaved form data after validation failure.
- Refresh authorization state when receiving `401`.
- Show a role-specific message for `403`.

Suggested role message:

```text
Only Event Organizers can manage hashtag collections. Switch to your Event Organizer profile and try again.
```

## Part J - Backward Compatibility
- Regular-user legacy Music Choice and Activity Choice screens remain unchanged.
- `GET /api/event-tags` remains global/legacy.
- Event Organizer collection screens use `GET /api/my-tags-collection`.
- New Flutter code must use `manual_hashtags` and `collection_ids`.
- Do not send deprecated `hashtag_ids`, `user_hash_tag_ids`, or `organizer_hashtag_ids`.
- Existing event models must preserve older tag fields where other screens still use them.
- Do not remove legacy parsing until all current production responses have been verified.

## Part K - Testing Requirements For Flutter
### Unit Tests
Cover:

- Collection JSON parsing.
- Collection item parsing.
- Event hashtag parsing.
- Empty-array defaults.
- Nullable fields.
- Request serialization.
- Omitted versus empty update fields.
- Type value mapping.
- Hashtag normalization helpers.
- Duplicate detection.

### Repository/API Tests
Cover:

- List all collections.
- Filter Music collections.
- Filter Activity collections.
- Get collection detail.
- Create collection.
- Update collection.
- Remove collection.
- `401` handling.
- `403` handling.
- `404` handling.
- `422` handling.

### State-Management Tests
Cover:

- Loading.
- Empty.
- Success.
- Validation error.
- API error.
- Refresh.
- Create and return to picker.
- Delete/deactivate and refresh.
- Preserving event form state.

### Widget Tests
Cover:

- Empty-state screen.
- Collection list.
- Collection filters.
- Multiple selection.
- Create collection form.
- Hashtag chip editor.
- Locked collection hashtags.
- Editable manual hashtags.
- Non-draft validation.
- Draft exception.
- Public event hashtag rendering.

### Integration Tests
First-time organizer flow:

```text
Open event creation
Open collections
See empty state
Create collection
Return to list
Select collection
Add to event
Submit event
```

Existing collection flow:

```text
Open event creation
Load collections
Select multiple collections
Add manual hashtag
Submit event
```

Event edit flow:

```text
Load existing event
Verify selected collections
Verify manual hashtags
Remove one collection
Edit manual hashtags
Submit update
Reload event
Verify response
```

Security and error flow:

- Wrong role.
- Expired token.
- Collection deleted or inactive.
- Cross-organizer collection ID returned by stale state.
- Network failure during submit.

## Part L - Acceptance Criteria
Flutter implementation is complete only when:

- Event Organizer can list private named collections.
- Event Organizer can filter Music and Activity collections.
- Empty-state UI is implemented.
- Event Organizer can create a collection.
- Event Organizer can edit a collection.
- Event Organizer can remove/deactivate a collection.
- Event Organizer can enter manual event hashtags.
- Event Organizer can select multiple collections.
- Collection hashtags appear individually.
- Collection hashtags are locked at event level.
- Entire collections can be removed from an event.
- Manual hashtags remain editable.
- Non-draft event submission requires a hashtag source.
- Draft event can omit hashtags where permitted.
- Event editing restores collections and manual hashtags.
- Public event cards display flattened hashtags.
- Deprecated organizer hashtag fields are no longer sent.
- Regular-user legacy preference screens continue working.
- No match percentage is displayed.
- Automated tests pass.
- Existing event flows are not broken.

## Part M - Recommended Flutter Implementation Order
1. Read this guide fully.
2. Inspect existing Flutter architecture using targeted searches.
3. Identify current hashtag and event files.
4. Write a short implementation plan.
5. Update response and request models.
6. Update API client methods.
7. Update repository/service methods.
8. Add collection state management.
9. Build collection list/picker.
10. Build collection create/edit form.
11. Integrate manual hashtag input.
12. Integrate collection selection into event create.
13. Integrate collection selection into event edit.
14. Add local mandatory validation.
15. Update public event hashtag rendering.
16. Preserve legacy regular-user behavior.
17. Add unit tests.
18. Add state-management tests.
19. Add widget tests.
20. Add integration tests where supported.
21. Run formatter, analyzer, and tests.
22. Fix confirmed errors.
23. Review the diff for unrelated changes.
24. Provide a completion report.

## Part N - Commands For The Future Flutter Agent
Use the project's existing Flutter version manager if present.

Typical commands:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

If FVM is used:

```bash
fvm flutter pub get
fvm dart format .
fvm flutter analyze
fvm flutter test
```

Do not add packages unnecessarily.

## Part O - Required Completion Report For Flutter Work
The future Cursor agent must report:

- Architecture found.
- State-management package used.
- Networking package used.
- Files created.
- Files modified.
- Models added or updated.
- API methods added or updated.
- Screens added or updated.
- Validation added.
- Deprecated fields removed from new requests.
- Tests added.
- Commands run.
- Tests passed.
- Tests failed.
- Remaining issues.
- Confirmation that unresolved preference matching was not implemented.
