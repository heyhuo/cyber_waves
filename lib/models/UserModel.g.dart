// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['userId'] as String,
    json['userName'] as String,
    json['birth'] == null ? null : DateTime.parse(json['birth'] as String),
    json['phoneNum'] as String,
    json['age'] as int,
    json['userTag'] as String,
    json['userLevel'] as String,
    json['avatarPath'] as String,
    json['gender'] as String,
    createTime: json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String),
    location: json['location'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'phoneNum': instance.phoneNum,
      'age': instance.age,
      'userTag': instance.userTag,
      'birth': instance.birth?.toIso8601String(),
      'userLevel': instance.userLevel,
      'avatarPath': instance.avatarPath,
      'gender': instance.gender,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createTime': instance.createTime?.toIso8601String(),
    };
