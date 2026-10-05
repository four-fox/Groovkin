# Groovkin Flutter Testing Checklist

This checklist covers Flutter integration of the Laravel event / invite / negotiation contract. Use a real backend environment. Do not mark a manual test PASS unless it was actually executed.

## A. Environment preparation

- [ ] Flutter SDK installed and matches the project (`>=3.0.0 <4.0.0`)
- [ ] `flutter pub get` succeeds
- [ ] App points at the intended Laravel API (`lib/Components/Network/Url.dart`)
- [ ] Valid Sanctum login works
- [ ] Device or simulator can receive push notifications if notification tests will run
- [ ] Stripe / payment test method is available for VM Accept
- [ ] SMTP may succeed or fail; both paths must still create invites

## B. Required test accounts

| Account | Role | Notes |
| ------- | ---- | ----- |
| Regular User | `user` | Existing user registration / login |
| Event Organizer | `event_owner` | Can create events and invites |
| VM Venue A | `venue_manager` | Assigned to Venue A |
| VM Venue B | `venue_manager` | Assigned only to an unrelated venue |

Backend must already own these roles. Do not grant roles locally.

---

## C. Invite test cases

### C1. EO sees two invite actions

- **Preconditions:** Logged in as Event Organizer
- **Account/role:** Event Organizer / `event_owner`
- **Steps:** Open Settings → Groovkin Invites
- **Expected API:** none required yet
- **Expected UI:** Regular User Invite and Venue Manager Invite are both visible. No unrestricted role dropdown.
- **Pass/Fail:** [ ]

### C2. Regular User invite with email

- **Preconditions:** EO invite screen open
- **Account/role:** Event Organizer
- **Steps:** Choose Regular User Invite, enter an email, Create Invite
- **Expected API:** `POST /api/invites/regular-user` with optional email, `status=true`
- **Expected UI:** Code shown, Copy Code, Copy Invite Text, email delivery status
- **Pass/Fail:** [ ]

### C3. Regular User invite SMTP failure

- **Preconditions:** Backend returns `status=true`, `email_sent=false`
- **Account/role:** Event Organizer
- **Steps:** Create Regular User invite
- **Expected API:** Invite created; SMTP failure is not a create failure
- **Expected UI:** Success with code/share text and a separate email-failure explanation
- **Pass/Fail:** [ ]

### C4. Venue Manager invite

- **Preconditions:** EO invite screen open
- **Account/role:** Event Organizer
- **Steps:** Choose Venue Manager Invite, enter `venue.manager@example.com`, Create Invite
- **Expected API:** `POST /api/invites/venue-manager` with required email
- **Expected UI:** Code visible, role/type/email match, copy/share available
- **Pass/Fail:** [ ]

### C5. Regular User cannot create VM invite

- **Preconditions:** Logged in as Regular User
- **Account/role:** Regular User / `user`
- **Steps:** Open Groovkin Invite if present
- **Expected API:** No VM invite endpoint call from this UI
- **Expected UI:** No Venue Manager Invite action
- **Pass/Fail:** [ ]

### C6. Canonical invite format (XXXX-XXXX)

- **Expected:** Invite input accepts `9AXG-8JXL` style codes (letters + digits), not numeric-only 8-digit codes
- **Pass/Fail:** [ ]

### C7. Lowercase and hyphen UX

- **Steps:** Type `nauk-ckz9` or `naukckz9` at VM registration
- **Expected:** Normalizes/displays `NAUK-CKZ9`. Hyphen is preserved or auto-inserted. Unhyphenated value is never submitted.
- **Pass/Fail:** [ ]

### C8. Old long code rejected

- **Steps:** Enter `1E1A-540D-C658-5E10`
- **Expected:** Local rejection (`validation_error` / format message) or backend `validation_error`. No crash.
- **Pass/Fail:** [ ]

### C9. Backend-returned code is unchanged

- **Steps:** Create VM invite, copy code, validate, register
- **Expected:** Displayed, copied, validated, and registered code is the exact backend `code` string (e.g. `9AXG-8JXL`)
- **Pass/Fail:** [ ]

---

## D. Registration test cases

### D1. VM invite validates against the issued email

- **Preconditions:** Active VM invite exists
- **Account/role:** Unauthenticated VM registration
- **Steps:** Choose Venue Manager, enter the same email and code, continue registration
- **Expected API:** `POST /api/validate-invite-code` then `POST /api/register` with `role=venue_manager` and `invite_code`
- **Expected UI:** Validation succeeds and registration continues
- **Pass/Fail:** [ ]

### D2. Wrong VM email

- **Expected API / UI:** `invite_email_mismatch`
- **Pass/Fail:** [ ]

### D3. Wrong invite code

- **Expected API / UI:** `invite_invalid`
- **Pass/Fail:** [ ]

### D4. VM invite used with user role

- **Expected API / UI:** `invite_role_mismatch`
- **Pass/Fail:** [ ]

### D5. Reused code after successful registration

- **Expected API / UI:** `invite_used`
- **Pass/Fail:** [ ]

### D6. Expired code

- **Expected API / UI:** `invite_expired`
- **Pass/Fail:** [ ]

### D7. No VM code

- **Expected API / UI:** `invite_required`
- **Pass/Fail:** [ ]

### D8. Regular User registration still works

- **Expected API:** `POST /api/register` with `role=user`
- **Expected UI:** Existing Regular User path still works
- **Pass/Fail:** [ ]

---

## E. New Event tests

### E1. Create Event starts with empty event-specific choices

- **Preconditions:** EO profile already has services/music/activities
- **Account/role:** Event Organizer
- **Steps:** Open Create Event
- **Expected API:** `GET /api/event-form-defaults` and catalogs with `context=event_create`
- **Expected UI:** Services, Music Choices, and Activities start unselected
- **Pass/Fail:** [ ]

### E2. Stale create-event selections do not carry over

- **Steps:** Select values, leave without submitting, open Create Event again
- **Expected UI:** Selections are empty again
- **Pass/Fail:** [ ]

---

## F. Duplicate Event tests

### F1. Duplicate creates an independent event

- **Preconditions:** Source event has hashtags, services, music, activities
- **Account/role:** Event Organizer
- **Steps:** Duplicate the event
- **Expected API:** `POST /api/duplicate-event/{sourceId}` returns a **new** event id
- **Expected UI:** General fields prefilled; services/music/activities empty
- **Pass/Fail:** [ ]

---

## G. Manual hashtag tests

### G1. Copied manual hashtag can be removed from the duplicate

- **Expected API:** `POST /api/remove-event-hashtag` with the **new** event id and hashtag name
- **Expected UI:** Chip removed from duplicate only
- **Pass/Fail:** [ ]

### G2. Source event hashtag remains unchanged

- **Expected API:** Source event is never sent as `event_id` for the delete
- **Expected UI:** Original event still has the hashtag
- **Pass/Fail:** [ ]

---

## H. Structured Counter and Event Details

### H1. Pending VM — one Accept Event, one Counter, one Decline Event

- **Expected API:** `GET /api/event-details/{id}` and/or `GET /api/events/{id}/counters` with `data.counter.can_accept_event`, `can_counter`, `can_decline_event`
- **Expected UI:** Event Details (`PendingEventDetails`) shows each action once in `EventActionBar`. Lifecycle chip is Pending, not Countered.
- **Pass/Fail:** PASS (widget tests + code audit). Manual device: NOT RUN

### H2. Chat does not control Counter

- **Expected API:** `POST /api/send-message` `type=message` only
- **Expected UI:** Messages screen is chat. Counter uses `POST /api/events/{id}/counters`
- **Pass/Fail:** PASS (code). Manual: NOT RUN

### H3. Create Counter uses minor units

- **Steps:** Counter → proposed `2700.00` → Submit Counter
- **Expected API:** `POST /api/events/{id}/counters` `{proposed_principal_minor: 270000}`
- **Pass/Fail:** PASS (unit conversion tests). Manual API: NOT RUN

### H4. Accept / Reject / Counter Again

- **Expected API:** `POST /api/counters/{id}/accept|reject|counter`
- **Expected UI:** Max one of each action. Accept Counter does not accept the event or charge final payment.
- **Pass/Fail:** PASS (widget tests + controller). Manual: NOT RUN

### H5. Duplicate button regression

- **Expected UI:** Pending VM / counter recipient / completion VM never render two copies of the same action
- **Pass/Fail:** PASS (`test/event_counter_test.dart`)

---


## I. EO Revise / Resubmit tests

### I1. EO sees counter and can revise the same event

- **Account/role:** Event Organizer
- **Steps:** Open the countered event, change rate, submit
- **Expected API:** `POST /api/update-event` with the **same** `event_id`
- **Expected UI:** status becomes pending / resubmitted; old counter banner does not remain current after refresh
- **Pass/Fail:** [ ]

### I2. EO can resubmit without edits

- **Expected API:** `POST /api/resubmit-event-request` `{event_id}`
- **Expected UI:** status pending; VM still sees it in Requests
- **Pass/Fail:** [ ]

---

## J. Approval tests

### J1. VM can Counter again after resubmission

- **Expected API:** `can_counter_request=1` then another `status=countered`
- **Expected UI:** Repeated negotiation works
- **Pass/Fail:** [ ]

### J2. VM Accept with existing payment flow

- **Expected API:** `POST /api/accept-event-request` `status=accepted` plus existing payment requirements
- **Expected UI:** Leaves VM Requests immediately; appears in VM Scheduled and EO Upcoming if start is in the future
- **Pass/Fail:** [ ]

### J3. VM Decline

- **Expected API:** `status=declined`
- **Expected UI:** Removed from Requests; EO Requested updates
- **Pass/Fail:** [ ]

---

## K. EO Home tests

### K1. Upcoming

- **Expected API:** `GET /api/upcoming-events`
- **Expected UI:** Accepted/scheduled future events appear without app restart
- **Pass/Fail:** [ ]

### K2. Happening Now / Ongoing

- **Expected API:** `GET /api/on-going-events`
- **Expected UI:** Accepted event whose current time is between start/end appears here
- **Pass/Fail:** [ ]

### K3. Requested includes countered

- **Expected API:** `GET /api/show-requested-events`
- **Expected UI:** pending / requested / countered remain discoverable
- **Pass/Fail:** [ ]

---

## L. VM Scheduled tests

- **Expected API:** `GET /api/show-venue-my-events?section=scheduled`
- **Expected UI:** Venue A VM sees Venue A future accepted events. Venue B VM does not.
- **Pass/Fail:** [ ]

---

## M. VM Requests tests

- **Expected API:** `GET /api/show-venue-requested-events`
- **Expected UI:** pending visible, countered visible, accepted not visible after approval
- **Pass/Fail:** [ ]

---

## N. VM History tests

- **Expected API:** `GET /api/show-venue-my-events?section=history`
- **Expected UI:** past approved/completed events shown; declined/cancelled/unrelated venues not shown in this section
- **Pass/Fail:** [ ]

---

## O. Venue access-control tests

- **Steps:** Venue B VM opens a protected Venue A request by event id
- **Expected API:** `403` with `event_forbidden` or `venue_access_denied`
- **Expected UI:** Error shown; protected event data is not displayed
- **Pass/Fail:** [ ]

---

## P. Cache / list refresh tests

Verify lists update immediately after submit, counter, revise, resubmit, accept, decline, and completion. App restart must not be required.

- **Pass/Fail:** [ ]

---

## Q. Notification tests

| Type | Opens correct event | Home lists also correct without relying on the notification |
| ---- | ------------------- | ----------------------------------------------------------- |
| `event_created` | [ ] | [ ] |
| `event_countered` | [ ] | [ ] |
| `event_resubmitted` | [ ] | [ ] |
| `event_accept` | [ ] | [ ] |
| `event_declined` | [ ] | [ ] |

---

## R. Closure Counter regression tests

These must keep using completion APIs, not pre-approval Counter.

- [ ] Completion request
- [ ] Completion Counter
- [ ] Revise completion Counter
- [ ] Accept completion Counter
- [ ] Reject completion Counter
- [ ] Completion history/status

---

## S. Regular User regression tests

- [ ] Regular User registration
- [ ] Regular User login
- [ ] Optional Regular User invite from EO still works
- [ ] User cannot create VM invite
- [ ] User cannot become VM by local role selection alone
- [ ] User cannot access EO/VM protected actions

---

## T. Role switching

- **Expected API:** `POST /api/switch-profile`
- **Expected UI:** `active_role` comes from backend. Failed switch does not change local role. Home endpoints follow the current role.
- **Pass/Fail:** [ ]

---

## U. Event visibility and event-specific hashtags

Manual device cases stay `NOT RUN` until executed on a logged-in build.

- [ ] Edit Music Choices loads event-specific selections — NOT RUN
- [ ] Edit Activity Choices loads event-specific selections — NOT RUN
- [ ] Profile preference is not selected unless event selected it — NOT RUN
- [ ] Main VM heading is My Events — NOT RUN
- [ ] Future accepted event visible in My Events — NOT RUN
- [ ] Ongoing event visible in My Events — NOT RUN
- [ ] Completed-before-end visible in My Events — NOT RUN
- [ ] Completed-before-end absent from History — NOT RUN
- [ ] Past completed visible in History — NOT RUN
- [ ] Past accepted visible in History — NOT RUN
- [ ] Pending remains Requests — NOT RUN
- [ ] Counter does not change list classification incorrectly — NOT RUN
- [ ] Completion Counter before end does not move event to History — NOT RUN

Automated coverage in `test/event_visibility_test.dart` checks catalog `status` 1/0, empty new-event catalog, server-bucket retention, and the My Events heading/endpoints.

---

## Test results table

Statuses: `PASS`, `FAIL`, `NOT RUN`, `BLOCKED`

| ID | Area | Test | Expected | Result | Notes |
| -- | ---- | ---- | -------- | ------ | ----- |
| C1 | Invites | EO two invite actions | Regular User + Venue Manager | NOT RUN | Requires EO login on device |
| C2 | Invites | Regular User invite | Code + copy/share + email status | NOT RUN | Requires backend |
| C3 | Invites | SMTP failure still created | Success with manual share | PASS | Automated parse: `status=true`, `email_sent=false` |
| C4 | Invites | VM invite | Canonical `XXXX-XXXX` + required email | NOT RUN | Requires backend |
| C5 | Invites | User cannot create VM invite | No VM action | NOT RUN | Requires user account |
| C6 | Invites | Canonical format | Letters+digits `XXXX-XXXX` | PASS | `test/invite_code_test.dart` |
| C7 | Invites | Lowercase / hyphen | `nauk-ckz9` → `NAUK-CKZ9` | PASS | Automated normalize/format |
| C8 | Invites | Old long code | Rejected locally | PASS | Automated; paste of 16-char format rejected |
| C9 | Invites | Returned code unchanged | Display/copy/validate/register same string | NOT RUN | Device + backend |
| D1 | Registration | Valid VM invite | Validate then register | NOT RUN | Requires unused VM invite |
| D2 | Registration | Wrong email | `invite_email_mismatch` | NOT RUN | |
| D3 | Registration | Wrong code | `invite_invalid` | NOT RUN | |
| D4 | Registration | Role mismatch | `invite_role_mismatch` | NOT RUN | |
| D5 | Registration | Used code | `invite_used` | NOT RUN | |
| D6 | Registration | Expired code | `invite_expired` | NOT RUN | |
| D7 | Registration | Missing code | `invite_required` | NOT RUN | |
| D8 | Registration | Regular User signup | Existing path works | NOT RUN | |
| E1 | Create Event | Empty choices | Services/music/activities empty | NOT RUN | |
| E2 | Create Event | No stale carry-over | Second create is empty | NOT RUN | |
| F1 | Duplicate | New independent event | New id, empty choices | PASS | Automated id parse only; UI NOT RUN |
| G1 | Hashtags | Delete duplicate hashtag | Uses new event id | PASS | Automated `eventIdForHashtagDeletion` |
| G2 | Hashtags | Source unchanged | Source id never used | PASS | Automated; live source check NOT RUN |
| H1 | Counter | Server `can_counter` | One Counter in EventActionBar | PASS | Widget + flags |
| H2 | Counter | Chat is messages only | No `counter_message` | PASS | Code audit |
| H3 | Counter | Submit price | `proposed_principal_minor` | PASS | `dollarsToMinorUnits` |
| H4 | Counter | Accept/Reject/Again | Structured counter routes | PASS | Endpoint tests; UI NOT RUN |
| H5 | Event Details | Duplicate actions | Each action max once | PASS | `test/event_counter_test.dart` |
| I1 | Revise | Same event update | pending/resubmitted | PASS | Automated payload parse; UI NOT RUN |
| I2 | Resubmit | No field changes | `resubmit-event-request` | NOT RUN | |
| J1 | Approval | Counter again | Repeated negotiation | NOT RUN | |
| J2 | Approval | Accept + payment | Lists update immediately | NOT RUN | Needs Stripe |
| J3 | Approval | Decline | Requests/requested refresh | NOT RUN | |
| K1 | EO Home | Upcoming | `upcoming-events` | NOT RUN | |
| K2 | EO Home | Happening Now | `on-going-events` | NOT RUN | Needs in-progress event |
| K3 | EO Home | Requested | Countered remains | NOT RUN | |
| L1 | VM Home | Scheduled | Venue-scoped scheduled | PASS | Automated endpoint map; UI NOT RUN |
| M1 | VM Home | Requests | pending + countered | PASS | Automated endpoint map; UI NOT RUN |
| N1 | VM Home | History | Past approved/completed | PASS | Automated endpoint map; UI NOT RUN |
| O1 | Security | Unrelated VM | 403 / no protected data | NOT RUN | |
| P1 | Cache | Mutation refresh | No restart required | PASS | Automated `invalidate_lists` parse |
| Q1 | Notifications | Navigation + Home | Both work | NOT RUN | Needs device |
| R1 | Closure | Completion counters | Still completion APIs | NOT RUN | |
| S1 | Regression | Regular User | Existing user flow | NOT RUN | |
| T1 | Roles | Switch profile | Backend `active_role` | PASS | Automated role mapping |
| U1 | Hashtags | Edit music/activity status | `status` 1 selected, 0 not | PASS | `test/event_visibility_test.dart`; device NOT RUN |
| U2 | VM lists | My Events heading + buckets | Server lists, no local History move | PASS | Automated; device flows NOT RUN |

Automated tests live in `test/invite_code_test.dart`, `test/backend_contract_test.dart`, `test/event_counter_test.dart`, `test/event_visibility_test.dart`, and `test/profile_and_event_contract_test.dart`.

`flutter analyze`: PASS (no issues).

`flutter test`: PASS — 138 tests, 0 failed. Device flows in section U remain NOT RUN.

`flutter build apk --debug`: PASS — `build/app/outputs/flutter-apk/app-debug.apk`.

iOS debug build was not run.
