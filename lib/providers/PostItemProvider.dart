import 'package:cyber_waves/models/PostModel.dart';
import 'package:cyber_waves/tools/WebRequest.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostItemProvider with ChangeNotifier {
  var postList = List<PostModel>();
  Dio dio = new Dio();
  var baseUrl = "user";
  WebRequest webRequest = new WebRequest();
  int size = 5, page = 1;
  String ipPort;

  PostItemProvider();

  /* 获取动态数据 */
  Future getPostItemList({ifFront = false}) async {
    if(ipPort==null){
     var u= await webRequest.generate("");
     ipPort = u.toString();
    }
    var apiUrl = "$ipPort/$baseUrl/getPostItemList";
    var response = await dio.request(apiUrl,
        data: {"page": page, "size": this.size},
        options: Options(method: "POST"));
    // print(response);
    var list = List<PostModel>(); //List.castFrom(response.data["result"]);
    var t = response.data["result"];
    var idx = postList.length;
    for (var obj in t) {
      list.add(PostModel.fromJson(obj));
    }

    if (ifFront) {
      idx = 0;
    }
    postList.insertAll(idx, list);

    print(postList.length);
    notifyListeners();
  }
}
