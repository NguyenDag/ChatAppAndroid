import 'package:realm/realm.dart';

part 'message.realm.dart';

// Realm model for Message
@RealmModel()
class _Message {
  @PrimaryKey()
  late String id;

  late String friendId;

  late String? content;
  late List<_FileModel> files;
  late List<_FileModel> images;
  late int isSend;
  late DateTime createdAt;
  late int messageType;
}

// Realm model for File (image or file)
@RealmModel()
class _FileModel {
  @PrimaryKey()
  late String id;

  late String url;
  late String fileName;
}

// ------------------ FileModel JSON Helper ------------------

FileModel fileModelFromJson(Map<String, dynamic> json) {
  return FileModel(
    json['_id'] as String? ?? '',
    json['urlImage'] as String? ?? json['urlFile'] as String? ?? '',
    json['FileName'] as String? ?? '',
  );
}

Map<String, dynamic> fileModelToJson(FileModel file) {
  return {'_id': file.id, 'urlFile': file.url, 'FileName': file.fileName};
}

// ------------------ Message JSON Extension ------------------

extension MessageJson on Message {
  Map<String, dynamic> messageToJson() {
    return {
      'id': id,
      'Content': content,
      'Files': files.map(fileModelToJson).toList(),
      'Images': images.map(fileModelToJson).toList(),
      'isSend': isSend,
      'CreatedAt': createdAt.toIso8601String(),
      'MessageType': messageType,
    };
  }

  static DateTime formatDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

Message messageFromJson(Map<String, dynamic> json, String friendId) {
  final filesJson = json['Files'] as List<dynamic>? ?? [];
  final List<FileModel> tempFiles =
      filesJson
          .map((e) => fileModelFromJson(e as Map<String, dynamic>))
          .toList();

  final imagesJson = json['Images'] as List<dynamic>? ?? [];
  final List<FileModel> tempImages =
      imagesJson
          .map((e) => fileModelFromJson(e as Map<String, dynamic>))
          .toList();

  return Message(
    json['id'] as String? ?? '',
    friendId,
    json['isSend'] as int? ?? 0,
    DateTime.tryParse(json['CreatedAt'] ?? '') ?? DateTime.now(),
    json['MessageType'] as int? ?? 0,
    content: json['Content'] as String?,
    files: tempFiles,
    images: tempImages,
  );
}
