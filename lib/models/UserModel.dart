import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable()
class UserModel extends Object{
  String userId;
  String userName;
  String phoneNum;
  int age;
  String userTag;
  DateTime birth;
  String userLevel;
  String avatarPath;
  String gender;
  String location;
  double latitude;
  double longitude;
  DateTime createTime;


  UserModel(
      this.userId,
      this.userName,
      this.birth,
      this.phoneNum,
      this.age,
      this.userTag,
      this.userLevel,
      this.avatarPath,
      this.gender,
      {this.createTime,this.location, this.latitude, this.longitude});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}