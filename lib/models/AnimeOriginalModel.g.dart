// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnimeOriginalModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeOriginalModel _$AnimeOriginalModelFromJson(Map<String, dynamic> json) {
  return AnimeOriginalModel(
    animeId: json['animeId'] as String,
    userId: json['userId'] as String,
    animeName: json['animeName'] as String,
    animePath: json['animePath'] as String,
    generateTag: json['generateTag'] as int,
    uploadDate: json['uploadDate'] == null
        ? null
        : DateTime.parse(json['uploadDate'] as String),
  );
}

Map<String, dynamic> _$AnimeOriginalModelToJson(AnimeOriginalModel instance) =>
    <String, dynamic>{
      'animeId': instance.animeId,
      'userId': instance.userId,
      'animeName': instance.animeName,
      'animePath': instance.animePath,
      'generateTag': instance.generateTag,
      'uploadDate': instance.uploadDate?.toIso8601String(),
    };
