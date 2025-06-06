import 'package:realm/realm.dart';

import '../models/friend.dart';

class RealmFriendService {
  static late Realm _realm;

  static void init() {
    if (true) {
      final config = Configuration.local([Friend.schema]);
      _realm = Realm(config);
    }
  }

  static List<Friend> getAllLocalFriends() {
    init();
    return _realm.all<Friend>().toList();
  }

  static void saveFriendsToLocal(List<Map<String, dynamic>> jsonList) {
    init();
    final friends = jsonList.map((e) => friendFromJson(e)).toList();

    _realm.write(() {
      _realm.deleteAll<Friend>();
      for (var f in friends) {
        _realm.add(f, update: true);
      }
    });
  }

  static void clearAllLocalFriends() {
    init();
    _realm.write(() => _realm.deleteAll<Friend>());
  }
}
