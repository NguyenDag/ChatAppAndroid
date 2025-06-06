// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Friend extends _Friend with RealmEntity, RealmObjectBase, RealmObject {
  Friend(
    String friendId,
    String fullName,
    String username,
    bool isOnline,
    int isSend, {
    String? content,
    Iterable<String> files = const [],
    Iterable<String> images = const [],
  }) {
    RealmObjectBase.set(this, 'friendId', friendId);
    RealmObjectBase.set(this, 'fullName', fullName);
    RealmObjectBase.set(this, 'username', username);
    RealmObjectBase.set(this, 'content', content);
    RealmObjectBase.set<RealmList<String>>(
      this,
      'files',
      RealmList<String>(files),
    );
    RealmObjectBase.set<RealmList<String>>(
      this,
      'images',
      RealmList<String>(images),
    );
    RealmObjectBase.set(this, 'isOnline', isOnline);
    RealmObjectBase.set(this, 'isSend', isSend);
  }

  Friend._();

  @override
  String get friendId =>
      RealmObjectBase.get<String>(this, 'friendId') as String;
  @override
  set friendId(String value) => RealmObjectBase.set(this, 'friendId', value);

  @override
  String get fullName =>
      RealmObjectBase.get<String>(this, 'fullName') as String;
  @override
  set fullName(String value) => RealmObjectBase.set(this, 'fullName', value);

  @override
  String get username =>
      RealmObjectBase.get<String>(this, 'username') as String;
  @override
  set username(String value) => RealmObjectBase.set(this, 'username', value);

  @override
  String? get content =>
      RealmObjectBase.get<String>(this, 'content') as String?;
  @override
  set content(String? value) => RealmObjectBase.set(this, 'content', value);

  @override
  RealmList<String> get files =>
      RealmObjectBase.get<String>(this, 'files') as RealmList<String>;
  @override
  set files(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get images =>
      RealmObjectBase.get<String>(this, 'images') as RealmList<String>;
  @override
  set images(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool get isOnline => RealmObjectBase.get<bool>(this, 'isOnline') as bool;
  @override
  set isOnline(bool value) => RealmObjectBase.set(this, 'isOnline', value);

  @override
  int get isSend => RealmObjectBase.get<int>(this, 'isSend') as int;
  @override
  set isSend(int value) => RealmObjectBase.set(this, 'isSend', value);

  @override
  Stream<RealmObjectChanges<Friend>> get changes =>
      RealmObjectBase.getChanges<Friend>(this);

  @override
  Stream<RealmObjectChanges<Friend>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Friend>(this, keyPaths);

  @override
  Friend freeze() => RealmObjectBase.freezeObject<Friend>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'friendId': friendId.toEJson(),
      'fullName': fullName.toEJson(),
      'username': username.toEJson(),
      'content': content.toEJson(),
      'files': files.toEJson(),
      'images': images.toEJson(),
      'isOnline': isOnline.toEJson(),
      'isSend': isSend.toEJson(),
    };
  }

  static EJsonValue _toEJson(Friend value) => value.toEJson();
  static Friend _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'friendId': EJsonValue friendId,
        'fullName': EJsonValue fullName,
        'username': EJsonValue username,
        'isOnline': EJsonValue isOnline,
        'isSend': EJsonValue isSend,
      } =>
        Friend(
          fromEJson(friendId),
          fromEJson(fullName),
          fromEJson(username),
          fromEJson(isOnline),
          fromEJson(isSend),
          content: fromEJson(ejson['content']),
          files: fromEJson(ejson['files']),
          images: fromEJson(ejson['images']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Friend._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Friend, 'Friend', [
      SchemaProperty('friendId', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('fullName', RealmPropertyType.string),
      SchemaProperty('username', RealmPropertyType.string),
      SchemaProperty('content', RealmPropertyType.string, optional: true),
      SchemaProperty(
        'files',
        RealmPropertyType.string,
        collectionType: RealmCollectionType.list,
      ),
      SchemaProperty(
        'images',
        RealmPropertyType.string,
        collectionType: RealmCollectionType.list,
      ),
      SchemaProperty('isOnline', RealmPropertyType.bool),
      SchemaProperty('isSend', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
