import 'package:flutter_test/flutter_test.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/services/socket_session.dart';

void main() {
  test('production socket url has no legacy host or port', () {
    final url = Url().socketUrl;
    expect(url, 'https://groovkin.gologonow.app');
    expect(url.contains('72.62.79.55'), isFalse);
    expect(url.contains('9012'), isFalse);
    expect(socketCacheId(url), 'https://groovkin.gologonow.app:443');
  });

  test('handshake uses the raw sanctum token and websocket only', () {
    const token = '12|plainSanctumSecret';
    final options = buildSocketOptions(sanctumSocketToken('Bearer $token')!);

    expect(options['path'], '/socket.io/');
    expect(options['transports'], ['websocket']);
    expect(options['autoConnect'], isFalse);
    expect(options['forceNew'], isTrue);
    expect(options['force new connection'], isTrue);
    expect(options['auth'], {'token': token});
    expect(options.containsKey('query'), isFalse);
    expect(options.containsKey('extraHeaders'), isFalse);
    expect(options.toString().contains('user_id'), isFalse);
    expect(options.toString().contains('Bearer'), isFalse);
  });

  test('bearer prefix and empty tokens are not socket credentials', () {
    expect(sanctumSocketToken('Bearer abc'), 'abc');
    expect(sanctumSocketToken('bearer   abc'), 'abc');
    expect(sanctumSocketToken('  abc  '), 'abc');
    expect(sanctumSocketToken(null), isNull);
    expect(sanctumSocketToken(''), isNull);
    expect(sanctumSocketToken('null'), isNull);
    expect(shouldCloseSocket(null), isTrue);
    expect(shouldCloseSocket(''), isTrue);
    expect(shouldCloseSocket('abc'), isFalse);
  });

  test('token and profile changes replace the socket; auth rejection does not loop', () {
    expect(
      shouldOpenSocket(
        hasLiveSocket: false,
        authRejected: false,
        boundToken: null,
        boundUserId: null,
        nextToken: 'a',
        nextUserId: '1',
      ),
      isTrue,
    );
    expect(
      shouldOpenSocket(
        hasLiveSocket: true,
        authRejected: false,
        boundToken: 'a',
        boundUserId: '1',
        nextToken: 'a',
        nextUserId: '1',
      ),
      isFalse,
    );
    expect(
      shouldOpenSocket(
        hasLiveSocket: true,
        authRejected: false,
        boundToken: 'a',
        boundUserId: '1',
        nextToken: 'b',
        nextUserId: '1',
      ),
      isTrue,
    );
    expect(
      shouldOpenSocket(
        hasLiveSocket: true,
        authRejected: false,
        boundToken: 'a',
        boundUserId: '1',
        nextToken: 'a',
        nextUserId: '2',
      ),
      isTrue,
    );
    expect(
      shouldOpenSocket(
        hasLiveSocket: false,
        authRejected: true,
        boundToken: 'a',
        boundUserId: '1',
        nextToken: 'a',
        nextUserId: '1',
      ),
      isFalse,
    );
    expect(
      shouldOpenSocket(
        hasLiveSocket: false,
        authRejected: false,
        boundToken: null,
        boundUserId: null,
        nextToken: null,
        nextUserId: null,
      ),
      isFalse,
    );
  });

  test('auth failures are distinct from transport failures', () {
    expect(isSocketAuthFailure('Authentication error'), isTrue);
    expect(isSocketAuthFailure({'message': 'Unauthenticated.'}), isTrue);
    expect(isSocketAuthFailure('invalid token'), isTrue);
    expect(isSocketAuthFailure('token expired'), isTrue);
    expect(isSocketAuthFailure('websocket error'), isFalse);
    expect(isSocketAuthFailure('timeout'), isFalse);
    expect(isSocketAuthFailure({'reason': 'transport close'}), isFalse);
  });

  test('event payloads match the production contracts', () {
    expect(
      parseIncomingMessage({
        'message': {'id': 4, 'conversation_id': '1-2', 'msg': 'hidden'},
      }),
      containsPair('id', 4),
    );
    expect(parseIncomingMessage({'text': 'no message key'}), isNull);

    final count = parseNotificationCount({
      'receiverId': 9,
      'count': '3',
    });
    expect(count!.count, 3);
    expect(notificationCountForUser(count, '9'), isTrue);
    expect(notificationCountForUser(count, '4'), isFalse);
    expect(
      parseNotificationCount({'receiver_id': '9', 'count': 1})!.receiverId,
      '9',
    );

    expect(
      parseSeenMessageIds({
        'data': [
          {'id': 1},
          {'message_id': '2'},
        ],
      }),
      {1, 2},
    );
    expect(parseSeenMessageIds({'data': {'id': 8}}), {8});

    expect(
      parseDeleteEveryoneData({
        'data': {'id': 5, 'is_deleted': 1},
      })!['id'],
      5,
    );

    final typing = parseTypingEvent({
      'conversation_id': '1-2',
      'user_id': 7,
      'is_typing': 1,
    });
    expect(typing!.isTyping, isTrue);
    expect(typing.userId, '7');
    expect(parseTypingEvent({'typing': true, 'conversation_id': '1-2'}), isNull);

    expect(
      typingEmitPayload(conversationId: '1-2', userId: 7, isTyping: false),
      {
        'conversation_id': '1-2',
        'user_id': 7,
        'is_typing': false,
      },
    );
    expect(kTypingEmitEvent, 'typing');
  });
}
