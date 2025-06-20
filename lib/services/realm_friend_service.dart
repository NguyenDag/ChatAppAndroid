import 'package:realm/realm.dart';

import '../models/opp_model.dart';

class RealmFriendService {
  static late Realm _realm;

  static void init() {
    if (true) {
      final config = Configuration.local([Friend.schema, FileModel.schema]);
      _realm = Realm(config);
    }
  }

  static Realm get realm {
    init();
    return _realm;
  }

  static List<Friend> getAllLocalFriends() {
    init();
    return _realm.all<Friend>().toList();
  }

  static void saveFriendsToLocal(List<Map<String, dynamic>> jsonList) {
    init();
    final friends = jsonList.map((e) => friendFromJson(e)).toList();

    _realm.write(() {
      for (final newFriend in friends) {
        final existingFriend = _realm.find<Friend>(newFriend.friendId);

        // Đảm bảo FileModel được add trước với update:true (tránh lỗi trùng key)
        for (var file in newFriend.files) {
          _realm.add(file, update: true);
        }
        for (var image in newFriend.images) {
          _realm.add(image, update: true);
        }

        if (existingFriend != null) {
          // Cập nhật thông tin từ API, giữ lại dữ liệu cục bộ
          existingFriend.fullName = newFriend.fullName;
          existingFriend.username = newFriend.username;
          existingFriend.isOnline = newFriend.isOnline;
          existingFriend.isSend = newFriend.isSend;
          existingFriend.content = newFriend.content;

          existingFriend.files
            ..clear()
            ..addAll(newFriend.files);

          existingFriend.images
            ..clear()
            ..addAll(newFriend.images);

          // Không đụng vào localNickname và color
        } else {
          // Nếu là bạn mới, thêm mới vào Realm
          _realm.add(newFriend);
        }
      }

      // for (var newFriend in friends) {
      //   final oldFriend = _realm.find<Friend>(newFriend.friendId);
      //
      //   if (oldFriend != null) {
      //     oldFriend.fullName = newFriend.fullName;
      //     oldFriend.username = newFriend.username;
      //     oldFriend.isOnline = newFriend.isOnline;
      //     oldFriend.isSend = newFriend.isSend;
      //     oldFriend.content = newFriend.content;
      //     oldFriend.files.clear();
      //     oldFriend.files.addAll(newFriend.files);
      //     oldFriend.images.clear();
      //     oldFriend.images.addAll(newFriend.images);
      //   } else {
      //     _realm.add(newFriend, update: true);
      //   }
      // }
    });
  }

  static void clearAllLocalFriends() {
    init();
    _realm.write(() => _realm.deleteAll<Friend>());
  }
}
