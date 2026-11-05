# Safety Point — Flutter Integration Handoff

**Source:** Cursor Grok backend implementation and verification report supplied October 29, 2026.  
**Status:** Reported as verified against isolated MySQL database `safety_point_audit_test_20261029`; **not yet verified on production after this latest set of changes**.  
**Backend:** NestJS, Knex/Objection, MySQL, Socket.IO.  
**Mobile:** Flutter.

## API fundamentals

- Base URL: `https://safety-point.gologonow.app`
- REST authentication: `Authorization: Bearer <token>`.
- Existing success envelope remains `{ "data": ..., "statusCode": 200, "message": "success" }`.
- Keep existing response field names, event names, routes, HTTP methods, and field types. Newly supplied friend-action flags are additive.
- Existing pagination `links.next` is the authoritative next-page link. Backend now reports public HTTPS origin, `perPage` and `limit` parameters, and `meta.itemCount` = count in the returned page.

## Friends: authoritative action permissions

| Viewer/state | UI action | Flags |
|---|---|---|
| Sender, pending | Pending; Cancel if supported | `can_accept=false`, `can_reject=false`, `can_cancel=true` |
| Receiver, pending | Accept and Reject | `can_accept=true`, `can_reject=true`, `can_cancel=false` |
| Either, accepted | Friend state; no pending actions | All action flags false |

**Never render Accept/Reject based only on `status == 'requested'`.** Follow `can_accept`, `can_reject`, and `can_cancel`. Use `is_sender`, `is_receiver` and `sender_id`/`receiver_id` to distinguish roles. On `POST /api/users/get-by-id`, `is_friend` now also supplies these five booleans: `is_sender`, `is_receiver`, `can_accept`, `can_reject`, `can_cancel`.

### Endpoints

| Method | Path | Request / meaning |
|---|---|---|
| POST | `/api/friends/add-friend` | Body `user_id` (target); backend uses authenticated sender |
| GET | `/api/friends/my-sent-request` | Query `page`, `perPage`; pending outgoing requests only |
| GET | `/api/friends/my-received-request` | Query `page`, `perPage`; pending incoming requests only |
| POST | `/api/friends/request-response` | Body `friend_id`, `status: 'accept'` or `'reject'` (also accepts `accepted`/`rejected` on backend); receiver only |
| POST | `/api/friends/cancel-request` | Body `is_friend_id`, `user_id` (receiver); sender only |
| GET | `/api/friends/my-friends` | Query `page`, `perPage`; accepted friendships |
| POST | `/api/friends/un-friend` | Body `friend_id`, `user_id` |
| POST | `/api/friends/block-user` | Body `user_id`; toggles block and removes pair |
| GET | `/api/friends/friend-count` | Accepted-friend count |
| POST | `/api/users/get-by-id` | Response `is_friend` contains friend status and action flags |

Stored statuses are `requested` (pending) and `accept` (accepted); rejection removes the pending row and does **not** persist a `rejected` row. After accept/reject/cancel/unfriend/block, invalidate and refresh affected sent, received, friends, count, and profile states; remove stale pending rows immediately or show loading until refreshed. Do not continue to show Accept/Reject after a successful accept. Never show receiver-only controls to sender.

Expected friend errors: sender accept/reject -> HTTP 422; receiver cancel -> HTTP 422; duplicate or reversed pending -> 422 `already requested`; already friends -> 422 `already friend`; blocked -> 410; self or nonexistent user -> 422. Parse existing error envelope without changing its shape.

## Reporting: multipart and media

- Create: `POST /api/reporting/add-report`, multipart form data.
- Edit: `POST /api/reporting/edit-report`, multipart form data; edit additionally requires `id` and `location`.
- Required create fields: `is_public`, `longitude`, `latitude`, `incident_id`, `location`.
- Optional fields: `text`, `priority`, `parent_id`.
- Single file accepted under **`image` OR `images`**; if both are supplied, backend stores `images`. Prefer one agreed field and do not send duplicates.
- Max file size: 25MB (`UPLOAD_MAX_BYTES` on backend). Allowed extensions: jpg, jpeg, png, gif, svg, webp, heic, heif, mp4, avi, mov, webm, pdf. MIME/type must pass backend matching rules; do not silently force `application/octet-stream` unless necessary.
- Stored media JSON retains `{ "path": "report/<filename>", "file_id": "<uuid>" }`; videos additionally include `thumbnail`.
- Display URL: `https://safety-point.gologonow.app/public/` + stored `path` (avoid duplicate slashes).
- HTTP 400 indicates validation errors. HTTP 500 with `message[0] = "The server could not store the uploaded file"` signals a server/storage failure; inform the user appropriately rather than treating it as a missing form field. Preserve backend error structure.

## Chat and Socket.IO

- Inbox: `GET /api/chat/get-inboxes`.
- Send: `POST /api/chat/sent-message` with `receiver_id`, `message`, `file_type`; optional `parent_id`, optional `media` (up to 20).
- History: `POST /api/chat/user-wish-chats`.
- `conversation_id`: canonical `<smallerUserId>-<largerUserId>`, unless an existing legacy conversation ID for that user pair is reused. **Use server-returned ID, not a freshly recomputed one**, when navigating/chatting.
- Backend creates one inbox row per participant and rejects unintended self-send.
- Socket namespace: `/safetypoint`.
- Handshake headers: `user_id` (current authenticated user) and `Authorization: Bearer <token>`. Report states the backend still accepts connections without token for backward compatibility; Flutter should send both.
- Existing events: `new-message-receiver-<id>`, `message-receiver-<id>`, `message-receiver-<id>-conversation-<conversationId>`, `all-seen-message-<senderId>`, `user-connected`, `user-dis-connected`, `user-online-<id>`, `typing-<conversationId>`, client emits `message-acknowledged`.
- `user-offline-<id>` now carries `status: 0`; update UI accordingly.
- Avoid duplicate subscriptions across reconnects and duplicate message/inbox items when socket events and HTTP responses arrive for the same record. Preserve message JSON contracts.

## Frontend acceptance tests (must run in Flutter repository)

1. User A sends request to B. A sees Pending/Cancel, no Accept/Reject. B sees Accept/Reject.
2. B accepts; both pending lists stop showing the row, and both friends lists show the relationship. Profile actions match flags.
3. Reject/cancel/block/unfriend and re-request flows update all related screens and counters.
4. Multipart report with a valid incident and one `image` or `images` file succeeds; invalid incident and server-storage error display correct messaging; public media loads.
5. Two users exchange messages in both directions: one conversation entry per user; correct history and last message; no duplicate UI entries.
6. Reconnect sockets; receive events once; offline event marks user offline; pagination loads additional data without localhost URLs.
7. Test token expiry, 410/422 responses, slow networks, and failed mutations without stale optimistic state.

## Evidence and remaining limits

Reported checks: 95 registered routes exercised, 17 unit suites / 74 tests passed, 8 real-MySQL E2E tests passed, Socket.IO connect/send/reconnect/offline scenario passed. Reporting multipart file existence + public GET was verified on isolated DB.

**Not verified in the report:** production host's directory ownership, live Apple/Google identity-provider flows, live Firebase and SMTP delivery, chat/comment/profile/contact attachments, video thumbnail generation, socket `typing` and `message-acknowledged` scenarios. These require separate verification; do not mark them passed.

**Deployment note:** Latest backend changes were **not deployed to production** at the time of the source report. Backend deployment and server upload-directory checks must precede final production Flutter acceptance tests.
