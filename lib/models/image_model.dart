class ImageModel {
  final String urlImage;
  final String fileName;
  final String id;

  ImageModel({
    required this.urlImage,
    required this.fileName,
    required this.id,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      urlImage: json['urlImage'],
      fileName: json['FileName'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urlImage': urlImage,
      'FileName': fileName,
      '_id': id,
    };
  }
}
