import 'package:realm/realm.dart';

part 'friend.realm.dart';

@RealmModel()
class _Friend {
  @PrimaryKey()
  late String friendId;

  late String fullName;
  late String username;
  late String? content;
  late List<String> files;
  late List<String> images;
  late bool isOnline;
  late int isSend;
}

extension FriendJson on Friend {
  Map<String, dynamic> friendToJson() => {
    'FriendID': friendId,
    'FullName': fullName,
    'Username': username,
    'Content': content,
    'Files': files.map((e) => e.toString()).toList(),
    'Images': images.map((e) => e.toString()).toList(),
    'isOnline': isOnline,
    'isSend': isSend,
  };
}

Friend friendFromJson(Map<String, dynamic> json) {
  return Friend(
    json['FriendID'] as String,
    json['FullName'] as String,
    json['Username'] as String,
    json['isOnline'] as bool? ?? false,
    json['isSend'] as int? ?? 0,
    content: json['Content'] as String?,
    files: List<String>.from((json['Files'] ?? []).map((e) => e.toString())),
    images: List<String>.from((json['Images'] ?? []).map((e) => e.toString())),
  );
}

