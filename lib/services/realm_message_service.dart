import 'package:realm/realm.dart';

import '../models/message.dart';

class RealmMessageService {
  static late Realm _realm;

  static void init() {
    if (true) {
      final config = Configuration.local([Message.schema, FileModel.schema]);
      _realm = Realm(config);
    }
  }

  static List<Message> getAllMessages() {
    init();
    return _realm.all<Message>().toList();
  }

  static List<Message> getMessagesForFriend(String friendId) {
    init();
    final messages = _realm.query<Message>("friendId == '${friendId}'").toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return messages;
  }

  static void saveMessagesToLocal(String friendId, List<Map<String, dynamic>> jsonList) {
    init();
    final messages = jsonList.map((e) => messageFromJson(e, friendId)).toList();

    _realm.write(() {
      for (var message in messages) {
        _realm.add(message, update: true);
      }
    });
  }

  static void clearAllMessages() {
    init();
    _realm.write(() => _realm.deleteAll<Message>());
  }
}
