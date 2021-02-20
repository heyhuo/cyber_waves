import 'package:json_annotation/json_annotation.dart';

part 'PostModel.g.dart';

@JsonSerializable()
class PostModel extends Object {
  String userId;
  String postId;
  String content;
  String picBasePath;
  String picPathList;
  String thumbPath;
  String tagList;
  String atUserList;
  String musicPath;
  double latitude;
  double longitude;
  String postsLocation;
  int readNum;
  int likeNum;
  int commentNum;
  DateTime createTime;
  DateTime updateTime;

  PostModel(
      this.userId,
      this.postId,
      this.content,
      this.picBasePath,
      this.picPathList,
      this.tagList,
      this.thumbPath,
      this.atUserList,
      this.musicPath,
      this.latitude,
      this.longitude,
      this.postsLocation,
      {this.readNum = 0,
      this.likeNum = 0,
      this.commentNum = 0,
      this.createTime,
      this.updateTime});

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
