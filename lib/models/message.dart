import 'dart:convert';

import 'file_model.dart';

class Message {
  final String id;
  final String? content;
  final List<FileModel> files;
  final List<FileModel> images;
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
              ?.map((e) => fromJson(e))
              .toList() ??
          [],
      images:
          (json['Images'] as List<dynamic>?)
              ?.map((e) => fromJson(e))
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

  static DateTime formatDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

// import 'package:realm/realm.dart';
//
// import 'file_model.dart';
//
// @RealmModel()
// class _Message {
//   @PrimaryKey()
//   late String id;
//
//   late String? content;
//   late List<_FileModel> files;
//   late List<_FileModel> images;
//   late int isSend;
//   late DateTime createdAt;
//   late int messageType;
// }
