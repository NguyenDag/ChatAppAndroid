import 'dart:convert';

import 'image_model.dart';

class Message {
  final String id;
  final String? content;
  final List<String> files;
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
      files: List<String>.from(json['Files'] ?? []),
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
      'Images': images.map((e) => e.toJson()).toList(),
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
              ? (jsonDecode(map['files']) as List<dynamic>).cast<String>()
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
      'images': jsonEncode(images.map((e) => e.toJson()).toList()),
      'isSend': isSend,
      'createdAt': createdAt.toIso8601String(),
      'messageType': messageType,
    };
  }

  static DateTime formatDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
