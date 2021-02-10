
import 'package:json_annotation/json_annotation.dart';

/*必须要加，不然不会自动生成*/
part 'AnimeOriginalModel.g.dart';

@JsonSerializable()
class AnimeOriginalModel extends Object {
  String animeId;
  String userId;
  String animeName;
  String animePath;
  int generateTag;
  DateTime uploadDate;


  AnimeOriginalModel(
      {this.animeId,
      this.userId,
      this.animeName,
      this.animePath,
        this.generateTag,
      this.uploadDate});


  factory AnimeOriginalModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeOriginalModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeOriginalModelToJson(this);
}
