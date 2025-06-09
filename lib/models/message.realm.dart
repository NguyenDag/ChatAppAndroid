// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Message extends _Message with RealmEntity, RealmObjectBase, RealmObject {
  Message(
    String id,
    String friendId,
    int isSend,
    DateTime createdAt,
    int messageType, {
    String? content,
    Iterable<FileModel> files = const [],
    Iterable<FileModel> images = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'friendId', friendId);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set<RealmList<FileModel>>(
      this,
      'files',
      RealmList<FileModel>(files),
    );
    RealmObjectBase.set<RealmList<FileModel>>(
      this,
      'images',
      RealmList<FileModel>(images),
    );
    RealmObjectBase.set(this, 'isSend', isSend);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'messageType', messageType);
  }

  Message._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get friendId =>
      RealmObjectBase.get<String>(this, 'friendId') as String;
  @override
  set friendId(String value) => RealmObjectBase.set(this, 'friendId', value);

  @override
  String? get content =>
      RealmObjectBase.get<String>(this, 'content') as String?;
  @override
  set content(String? value) => RealmObjectBase.set(this, 'content', value);

  @override
  RealmList<FileModel> get files =>
      RealmObjectBase.get<FileModel>(this, 'files') as RealmList<FileModel>;
  @override
  set files(covariant RealmList<FileModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<FileModel> get images =>
      RealmObjectBase.get<FileModel>(this, 'images') as RealmList<FileModel>;
  @override
  set images(covariant RealmList<FileModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  int get isSend => RealmObjectBase.get<int>(this, 'isSend') as int;
  @override
  set isSend(int value) => RealmObjectBase.set(this, 'isSend', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  int get messageType => RealmObjectBase.get<int>(this, 'messageType') as int;
  @override
  set messageType(int value) => RealmObjectBase.set(this, 'messageType', value);

  @override
  Stream<RealmObjectChanges<Message>> get changes =>
      RealmObjectBase.getChanges<Message>(this);

  @override
  Stream<RealmObjectChanges<Message>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Message>(this, keyPaths);

  @override
  Message freeze() => RealmObjectBase.freezeObject<Message>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'friendId': friendId.toEJson(),
      'content': content.toEJson(),
      'files': files.toEJson(),
      'images': images.toEJson(),
      'isSend': isSend.toEJson(),
      'createdAt': createdAt.toEJson(),
      'messageType': messageType.toEJson(),
    };
  }

  static EJsonValue _toEJson(Message value) => value.toEJson();
  static Message _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'friendId': EJsonValue friendId,
        'isSend': EJsonValue isSend,
        'createdAt': EJsonValue createdAt,
        'messageType': EJsonValue messageType,
      } =>
        Message(
          fromEJson(id),
          fromEJson(friendId),
          fromEJson(isSend),
          fromEJson(createdAt),
          fromEJson(messageType),
          content: fromEJson(ejson['content']),
          files: fromEJson(ejson['files']),
          images: fromEJson(ejson['images']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Message._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Message, 'Message', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('friendId', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.string, optional: true),
      SchemaProperty(
        'files',
        RealmPropertyType.object,
        linkTarget: 'FileModel',
        collectionType: RealmCollectionType.list,
      ),
      SchemaProperty(
        'images',
        RealmPropertyType.object,
        linkTarget: 'FileModel',
        collectionType: RealmCollectionType.list,
      ),
      SchemaProperty('isSend', RealmPropertyType.int),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('messageType', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

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
