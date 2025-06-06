// class FileModel {
//   final String url;
//   final String fileName;
//   final String id;
//
//   FileModel({
//     required this.url,
//     required this.fileName,
//     required this.id,
//   });
//
//   factory FileModel.fromJson(Map<String, dynamic> json) {
//     return FileModel(
//       url: json['urlImage'] as String? ?? json['urlFile'] as String? ?? '',
//       fileName: json['FileName'] as String? ?? '',
//       id: json['_id'] as String? ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'urlFile': url,
//       'FileName': fileName,
//       '_id': id,
//     };
//   }
// }

import 'package:realm/realm.dart';

part 'file_model.realm.dart';

@RealmModel()
class _FileModel {
  @PrimaryKey()
  late String id;

  late String url;
  late String fileName;
}

FileModel fromJson(Map<String, dynamic> json) {
  return FileModel(
    json['_id'] as String? ?? '',
    json['urlImage'] as String? ?? json['urlFile'] as String? ?? '',
    json['FileName'] as String? ?? '',
  );
}

Map<String, dynamic> toJson(FileModel file) {
  return {
    '_id': file.id,
    'urlFile': file.url,
    'FileName': file.fileName,
  };
}
//
// extension FileModelExtension on FileModel {
//   static FileModel fromJson(Map<String, dynamic> json) {
//     return FileModel(
//       id: json['_id'] as String? ?? '',
//       url: json['urlImage'] as String? ?? json['urlFile'] as String? ?? '',
//       fileName: json['FileName'] as String? ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'urlFile': url,
//       'FileName': fileName,
//     };
//   }
// }

