// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return PostModel(
    json['userId'] as String,
    json['postId'] as String,
    json['content'] as String,
    json['picBasePath'] as String,
    json['picPathList'] as String,
    json['tagList'] as String,
    json['thumbPath'] as String,
    json['atUserList'] as String,
    json['musicPath'] as String,
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
    json['postsLocation'] as String,
    readNum: json['readNum'] as int,
    likeNum: json['likeNum'] as int,
    commentNum: json['commentNum'] as int,
    createTime: json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String),
    updateTime: json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String),
  );
}

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'postId': instance.postId,
      'content': instance.content,
      'picBasePath': instance.picBasePath,
      'picPathList': instance.picPathList,
      'thumbPath': instance.thumbPath,
      'tagList': instance.tagList,
      'atUserList': instance.atUserList,
      'musicPath': instance.musicPath,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'postsLocation': instance.postsLocation,
      'readNum': instance.readNum,
      'likeNum': instance.likeNum,
      'commentNum': instance.commentNum,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
    };
