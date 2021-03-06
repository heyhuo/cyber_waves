import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cyber_waves/models/MusicModel.dart';
import 'package:cyber_waves/tools/Utils.dart';
import 'package:cyber_waves/tools/WebRequest.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MusicProvider with ChangeNotifier {
  var playMusicApi = 'https://music.163.com/song/media/outer/url?id=';
  var songId;
  var dio = new Dio();
  MusicModel musicModel;
  bool isGetInfo=false;
  var api = "https://api.imjad.cn/cloudmusic/";

  MusicProvider();

  AudioPlayer audioPlayer = AudioPlayer();

  clearMusicModel(){
    musicModel=null;
    notifyListeners();
  }

  play(songId) async {
    var url = playMusicApi + songId;
    int result = await audioPlayer.play(url);
    if (result == 1) {
      print("success play music");
    }
  }

  setIsGetInfo(){
    isGetInfo=!isGetInfo;
    notifyListeners();
  }

  getMusicInfo(String url) async {
    setIsGetInfo();
    var musicId=Utils.getMusicId(url);
    var params = {"type": "detail", "id": musicId};
    url = WebRequest.joinUrlParams(api, params);
    var response = await dio.get(url);
    var data = response.data;
    var songInfo = data["songs"][0];
    var artistInfo = songInfo["ar"][0];
    var albumInfo = songInfo["al"];
    musicModel = new MusicModel(
       musicId: songInfo["id"].toString(),
        musicName:songInfo["name"],
        artistId:artistInfo["id"].toString(),
        artistName:artistInfo["name"],
        albumId:albumInfo["id"].toString(),
        albumName:albumInfo["name"],
        albumPicUrl:albumInfo["picUrl"]);
    print("解析地址：${musicModel.toJson()}");
    setIsGetInfo();
/*
   musicModel =new MusicModel(
    musicId: songId,musicName: "测试",albumName: "专辑",
     albumPicUrl: "",artistName: "歌手"
    );*/
    notifyListeners();
  }
}
