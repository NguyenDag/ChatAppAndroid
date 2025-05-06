import 'image_model.dart';

class Message {
  final String id;
  final String? content;
  final List<String> files;
  final List<ImageModel> images;
  final int isSend;
  final String createdAt;
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
      images: (json['Images'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromJson(e))
          .toList() ??
          [],
      isSend: json['isSend'],
      createdAt: json['CreatedAt'],
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
      'CreatedAt': createdAt,
      'MessageType': messageType,
    };
  }
}
