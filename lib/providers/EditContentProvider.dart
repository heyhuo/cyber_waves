import 'package:flutter/material.dart';

class EditContentProvider extends ChangeNotifier {
  var tagList = <Widget>[];
  var music;
  var friends;
  var content;
  var picList = List<String>();
  var video;
  var selPicIdx;
  bool tagTextField=false;
  bool friendsField=false;
  bool musicField=false;
  Color tagColor = Colors.white;

  EditContentProvider(this.picList);

  setSelPicIdx(idx){
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
}
