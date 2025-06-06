// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class FileModel extends _FileModel
    with RealmEntity, RealmObjectBase, RealmObject {
  FileModel(String id, String url, String fileName) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'url', url);
    RealmObjectBase.set(this, 'fileName', fileName);
  }

  FileModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get url => RealmObjectBase.get<String>(this, 'url') as String;
  @override
  set url(String value) => RealmObjectBase.set(this, 'url', value);

  @override
  String get fileName =>
      RealmObjectBase.get<String>(this, 'fileName') as String;
  @override
  set fileName(String value) => RealmObjectBase.set(this, 'fileName', value);

  @override
  Stream<RealmObjectChanges<FileModel>> get changes =>
      RealmObjectBase.getChanges<FileModel>(this);

  @override
  Stream<RealmObjectChanges<FileModel>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<FileModel>(this, keyPaths);

  @override
  FileModel freeze() => RealmObjectBase.freezeObject<FileModel>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'url': url.toEJson(),
      'fileName': fileName.toEJson(),
    };
  }

  static EJsonValue _toEJson(FileModel value) => value.toEJson();
  static FileModel _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'url': EJsonValue url,
        'fileName': EJsonValue fileName,
      } =>
        FileModel(fromEJson(id), fromEJson(url), fromEJson(fileName)),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(FileModel._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, FileModel, 'FileModel', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('url', RealmPropertyType.string),
      SchemaProperty('fileName', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
