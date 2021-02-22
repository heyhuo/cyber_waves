// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MusicModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicModel _$MusicModelFromJson(Map<String, dynamic> json) {
  return MusicModel(
    musicId: json['musicId'] as String,
    musicName: json['musicName'] as String,
    artistId: json['artistId'] as String,
    artistName: json['artistName'] as String,
    albumId: json['albumId'] as String,
    albumName: json['albumName'] as String,
    albumPicUrl: json['albumPicUrl'] as String,
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
