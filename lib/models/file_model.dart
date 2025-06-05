class FileModel {
  final String url;
  final String fileName;
  final String id;

  FileModel({
    required this.url,
    required this.fileName,
    required this.id,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      url: json['urlImage'] as String? ?? json['urlFile'] as String? ?? '',
      fileName: json['FileName'] as String? ?? '',
      id: json['_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urlFile': url,
      'FileName': fileName,
      '_id': id,
    };
  }
}
