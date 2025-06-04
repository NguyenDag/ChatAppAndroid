import 'dart:convert';

import 'file_model.dart';
import 'image_model.dart';

class Message {
  final String id;
  final String? content;
  final List<FileModel> files;
  final List<ImageModel> images;
  final int isSend;
  final DateTime createdAt;
  final int messageType;

  Message({
    required this.id,
    this.content,
    required this.files,
    required this.images,
    required this.isSend,
    required this.createdAt,
    required this.messageType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['Content'],
      files:
          (json['Files'] as List<dynamic>?)
              ?.map((e) => FileModel.fromJson(e))
              .toList() ??
          [],
      images:
          (json['Images'] as List<dynamic>?)
              ?.map((e) => ImageModel.fromJson(e))
              .toList() ??
          [],
      isSend: json['isSend'],
      createdAt: DateTime.tryParse(json['CreatedAt'] ?? '') ?? DateTime.now(),
      messageType: json['MessageType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Content': content,
      'Files': files,
      'Images': images,
      'isSend': isSend,
      'CreatedAt': createdAt.toIso8601String(),
      'MessageType': messageType,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      content: map['content'],
      files:
          (map['files'] as String).isNotEmpty
              ? (jsonDecode(map['files']) as List)
                  .map((e) => FileModel.fromJson(e))
                  .toList()
              : [],
      images:
          (map['images'] as String).isNotEmpty
              ? (jsonDecode(map['images']) as List)
                  .map((e) => ImageModel.fromJson(e))
                  .toList()
              : [],
      isSend: map['isSend'],
      createdAt: DateTime.parse(map['createdAt']),
      messageType: map['messageType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'files': jsonEncode(files),
      'images': jsonEncode(images),
      'isSend': isSend,
      'createdAt': createdAt.toIso8601String(),
      'messageType': messageType,
    };
  }

  static DateTime formatDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
