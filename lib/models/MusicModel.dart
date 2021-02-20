
import 'package:json_annotation/json_annotation.dart';

part 'MusicModel.g.dart';
@JsonSerializable()
class MusicModel extends Object {
 String musicId;
 String musicName;
 String artistId;
 String artistName;
 String albumId;
 String albumName;
 String albumPicUrl;


 MusicModel(this.musicId, this.musicName, this.artistId, this.artistName,
      this.albumId, this.albumName, this.albumPicUrl);

  factory MusicModel.fromJson(Map<String, dynamic> json) =>
      _$MusicModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusicModelToJson(this);
}
