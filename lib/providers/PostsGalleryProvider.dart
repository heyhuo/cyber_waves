// import 'dart:convert';
//
// import 'package:cyber_waves/models/PostsModel.dart';
// import 'package:cyber_waves/wigets/WebRequest.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
//
// class PostsGalleryProvider with ChangeNotifier {
//   List<PostsModel> model1 = List<PostsModel>();
//   List<PostsModel> model2 = List<PostsModel>();
//   double _len1 = 0;
//   double _len2 = 0;
//
//   List<PostsModel> posts = List<PostsModel>();
//
//   PostsGalleryProvider() {
//     getPosts(0, 0);
//     //notifyListeners();
//   }
//
//   dispose() {
//     super.dispose();
//   }
//
//   Future getPosts(orderType, ifRefresh) async {
//     Uri url = await WebRequest().generate("getAnimeList", {
//       /*"openId": "ol_BV4zcyVJaOBtOTD5AfpkFERww",
//       "dataFrom": "0",
//       "count": "30",
//       "refreshTime": DateTime.now().toString(),
//       "currentSel": "1",
//       "ulo": "0",
//       "ula": "0"*/
//     });
//     var response = await http.get(url);
//     setGalleryModel(response.body);
//     notifyListeners();
//   }
//
//
//   setGalleryModel(String items){
//     var result = List<PostsModel>();
//
//     var posts = json.decode(items)["result"];
//
//     for (var item in posts) {
//       result.add(PostsModel.fromJson(item));
//     }
//     for (var item in result) {
//       if (_len1 <= _len2) {
//         item.makerName="";
//         item.picsPath="";
//         item.postsLocation="";
//         item.postsReaded=0;
//         model1.add(item);
//         _len1 += item.picsRate;
//       } else {
//         model2.add(item);
//         _len2 += item.picsRate;
//       }
//     }
//   }
// }