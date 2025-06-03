class FileModel {
  final String urlFile;
  final String fileName;
  final String id;

  FileModel({
    required this.urlFile,
    required this.fileName,
    required this.id,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      urlFile: json['urlFile'],
      fileName: json['FileName'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urlFile': urlFile,
      'FileName': fileName,
      '_id': id,
    };
  }
}
