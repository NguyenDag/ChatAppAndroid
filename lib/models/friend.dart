class Friend {
  final String friendId;
  final String fullName;
  final String username;
  final String? avatar;
  final String content;
  final bool isOnline;
  final int isSend;

  Friend({
    required this.friendId,
    required this.fullName,
    required this.username,
    this.avatar,
    required this.content,
    required this.isOnline,
    required this.isSend,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      friendId: json['FriendID'],
      fullName: json['FullName'],
      username: json['Username'],
      avatar: json['Avatar'],
      content: json['Content'],
      isOnline: json['isOnline'] ?? false,
      isSend: json['isSend'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FriendID': friendId,
      'FullName': fullName,
      'Username': username,
      'Avatar': avatar,
      'Content': content,
      'isOnline': isOnline,
      'isSend': isSend,
    };
  }
}
