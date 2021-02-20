import 'dart:convert';
import 'dart:typed_data';

import 'package:cyber_waves/models/PostModel.dart';
import 'package:cyber_waves/pages/UploadPage.dart';
import 'package:cyber_waves/tools/Utils.dart';
import 'package:cyber_waves/tools/WebRequest.dart';
import 'package:flutter/material.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

class EditContentProvider extends ChangeNotifier {
  var tagList = <Widget>[];
  var musicPath, content, selPicIdx=0,thumbPath, latitude, longitude, location;
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

  EditContentProvider();

  setSelPicIdx(idx) {
    selPicIdx = idx;
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
    int idx=0;
    for (Asset pic in picList) {
      var picInfo = {
        "name": pic.name,
        "w": pic.originalWidth,
        "h": pic.originalHeight
      };
      postPicList.add(json.encode(picInfo));

      if(idx++==selPicIdx){
        thumbPath = pic.name;
      }

      ByteData byteData = await pic.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = new MultipartFile.fromBytes(imageData,
          filename: pic.name,
          contentType: Utils.getMediaType("." + pic.name.split('.')[1]));

      imageList.add(multipartFile);
      // print("图片数据：$imageData");
    }
    print("图片数量:${imageList.length}");

    var dateTimeNow = Utils.getFormatDateTimeNow(dateTimeRex);
    var userId = "admin";
    PostModel postModel = new PostModel(
        userId,
        Uuid().v4().toString(),
        content,
        "upload/$dateStr/$userId/",
        json.encode(postPicList),
        json.encode(tags),
        thumbPath,
        json.encode([]),
        musicPath,
        latitude,
        longitude,
        location,
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
  }
}
