// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return PostModel(
    userId: json['userId'] as String,
    postId: json['postId'] as String,
    content: json['content'] as String,
    picBasePath: json['picBasePath'] as String,
    picPathList: json['picPathList'] as String,
    tagList: json['tagList'] as String,
    thumbPath: json['thumbPath'] as String,
    atUserList: json['atUserList'] as String,
    musicPath: json['musicPath'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    postsLocation: json['postsLocation'] as String,
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
