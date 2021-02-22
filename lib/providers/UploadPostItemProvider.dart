import 'dart:convert';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:cyber_waves/models/PostModel.dart';
import 'package:cyber_waves/pages/UploadPage.dart';
import 'package:cyber_waves/tools/Utils.dart';
import 'package:cyber_waves/tools/WebRequest.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img; // for demo purposes

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

class UploadPostItemProvider extends ChangeNotifier {
  var tagList = <Widget>[];
  var musicPath,
      content,
      selPicIdx = 0,
      thumbPath,
      latitude,
      longitude,
      location;
  var picList = List<String>();
  var video;
  bool tagTextField = false;
  bool friendsField = false;
  bool musicField = false;
  Color tagColor = Colors.white;
  var ip = "10.2.12.125";
  Dio dio = Dio();
  var dateTimeRex = "yyyy-MM-dd HH:mm:ss";
  var dateRex = "yyyyMMdd";
  var isUploading=false;

  UploadPostItemProvider();

  setSelPicIdx(idx) {
    selPicIdx = idx;
    notifyListeners();
  }

  setIsUploading(){
    isUploading=!isUploading;
    notifyListeners();
  }

  setMusicPath(url) {
    this.musicPath = url;
    notifyListeners();
  }

  addTag(Widget tag) {
    tagList.add(tag);
    notifyListeners();
  }

  removeTag(tag) {
    tagList.remove(tag);
    notifyListeners();
  }

  setTagField() {
    tagTextField = !tagTextField;
    notifyListeners();
  }

  setFriendsField() {
    friendsField = !friendsField;
    notifyListeners();
  }

  setMusicField() {
    musicField = !musicField;
    notifyListeners();
  }

  setContent(content) {
    this.content = content;
    notifyListeners();
  }

  addPics(String picPath) {
    this.picList.add(picPath);
    notifyListeners();
  }

  removePic(int index) {
    this.picList.removeAt(index);
    notifyListeners();
  }

  /*发布动态*/
  Future postData(
    picList,
  ) async {
    setIsUploading();
    List<MultipartFile> imageList = new List<MultipartFile>();

    var dateStr = Utils.getFormatDateTimeNow(dateRex, type: "String");
    var apiUrl = await WebRequest().generate("user/postUserItem");
    // var apiUrl = "http://$ip:8088/user/postUserItem";
    var tags = List<String>();

    for (TagItem tag in tagList) {
      var tagInfo = {
        "name": tag.tagName,
        "color": "0x" + tag.tagColor.value.toRadixString(16)
      };
      tags.add(json.encode(tagInfo));
    }

    var postPicList = List<String>();
    int idx = 0;
    for (Asset pic in picList) {
      var fileType="." + pic.name.split('.')[1];
      var fileName = Uuid().v4().toString()+fileType;

      var picInfo = {
        "name": fileName,//pic.name,
        "w": pic.originalWidth,
        "h": pic.originalHeight
      };
      postPicList.add(json.encode(picInfo));

      ByteData byteData = await pic.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      if (idx++ == selPicIdx) {
        // thumbPath = pic.name;
        thumbPath = Utils.getImageBlurhash(imageData);
        print("blurHash:$thumbPath");
      }

      MultipartFile multipartFile = new MultipartFile.fromBytes(imageData,
          filename: fileName,//pic.name,
          contentType: Utils.getMediaType(fileType));

      imageList.add(multipartFile);
      // print("图片数据：$imageData");
    }
    print("图片数量:${imageList.length}");
    var musicPath = Utils.getMusicId(this.musicPath);
    var dateTimeNow = Utils.getFormatDateTimeNow(dateTimeRex);
    var userId = "admin";
    PostModel postModel = new PostModel(
        userId: userId,
        postId: Uuid().v4().toString(),
        content: content,
        picBasePath: "upload/$dateStr/$userId/",
        picPathList: json.encode(postPicList),
        tagList: json.encode(tags),
        thumbPath: thumbPath,
        atUserList: json.encode([]),
        musicPath: musicPath,
        latitude: latitude,
        longitude: longitude,
        postsLocation: location,
        createTime: dateTimeNow,
        updateTime: dateTimeNow);

    FormData formData = FormData.fromMap({
      "multipartFiles": imageList,
      "postModel": json.encode(postModel), //postModel.toJson()
    });

    Response response = await dio.post(apiUrl.toString(), data: formData,
        onSendProgress: (int sent, int total) {
      print("发送：$sent,总计：$total");
    });
    setIsUploading();
  }
}
