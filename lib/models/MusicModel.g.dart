// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MusicModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicModel _$MusicModelFromJson(Map<String, dynamic> json) {
  return MusicModel(
    json['musicId'] as String,
    json['musicName'] as String,
    json['artistId'] as String,
    json['artistName'] as String,
    json['albumId'] as String,
    json['albumName'] as String,
    json['albumPicUrl'] as String,
  );
}

Map<String, dynamic> _$MusicModelToJson(MusicModel instance) =>
    <String, dynamic>{
      'musicId': instance.musicId,
      'musicName': instance.musicName,
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'albumId': instance.albumId,
      'albumName': instance.albumName,
      'albumPicUrl': instance.albumPicUrl,
    };
