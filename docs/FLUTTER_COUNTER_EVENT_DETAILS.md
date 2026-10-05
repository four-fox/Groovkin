# Flutter Counter + Event Details testing

Live screen: `PendingEventDetails` (`lib/View/bottomNavigation/homeTabs/eventsFlow/pendingEventFlow/pendingDetailsScreen.dart`)
Route: `Routes.pendingEventDetails` (`/PendingEventDetails`)

| Area | Result | Notes |
| --- | --- | --- |
| Event Details visual review | PASS | Hero, price summary, grouped info, single action bar |
| Duplicate button checks | PASS | Widget tests; EventActionBar is the only details CTA source |
| Counter API checks | PASS | Structured endpoints in `EventCounterEndpoints` |
| Lifecycle checks | PASS | Chip never labels lifecycle as Countered |
| Payment display checks | PASS | Backend minor units + no negative remaining |
| Invite regression | PASS | `test/invite_code_test.dart` `XXXX-XXXX` |
| Create Event empty choices | NOT RUN | Manual |
| Duplicate Event | PASS | Automated id/hashtag helpers; UI NOT RUN |
| EO Home | NOT RUN | Manual |
| VM Home | PASS | Automated endpoint map; UI NOT RUN |
| Manual E2E A–Q | NOT RUN / BLOCKED | No device session with EO+VM accounts in this run |
| Mark Complete before start | PASS (Flutter guard) | Hidden until event end. **Backend still needs a server-side completion time guard** |

Status vocabulary: PASS, FAIL, BLOCKED, NOT RUN.
