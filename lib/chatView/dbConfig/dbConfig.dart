
import 'package:sqflite/sqflite.dart';

import 'initDb.dart';

abstract class DatabaseBaseConfig {
  Future<Database> initDatabase();
}

class UserChatItemDatabase implements DatabaseBaseConfig {
  static final UserChatItemDatabase chatSingletonClass =
  UserChatItemDatabase._internal();

  factory UserChatItemDatabase() {
    return chatSingletonClass;
  }

  Future<Database> get getDatabase {
    return initDatabase();
  }

  @override
  Future<Database> initDatabase() async {
    final path = await initDeleteDb('UserChat.db');

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS UserChat(id INTEGER PRIMARY KEY, sender_id INTEGER, receiver_id INTEGER, source_id TEXT, parent_id INTEGER, conversation_id TEXT, msg TEXT, media TEXT, file_type TEXT, reply TEXT, delete_by INTEGER, is_deleted INTEGER, is_seen INTEGER, is_event_request INTEGER, event_request_accepted TEXT, flagged_by INTEGER, created_at TEXT, updated_at TEXT, user TEXT, parent_chat TEXT, event TEXT)',
        );
        // }
      },
      version: 1,
    );
  }

  UserChatItemDatabase._internal();
}