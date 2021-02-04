import 'package:flutter/material.dart';

class UploadBtnProvider extends ChangeNotifier {
  bool visible=false;

  UploadBtnProvider(this.visible);

  setVisible() {
    visible = !visible;
    notifyListeners();
  }
}
