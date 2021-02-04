import 'package:cyber_waves/pages/MakerPage.dart';
import 'package:cyber_waves/wigets/MakerMain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FaceCameraProvider.dart';

class UploadBtnProvider extends ChangeNotifier {
  bool visible = false;
  String heroTag;

  UploadBtnProvider(this.visible,this.heroTag);

  setVisible() {
    visible = !visible;
    notifyListeners();
  }

  setHeroTag(tag, context) {
    heroTag = tag;
    if ("sticker" == tag)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) {
                return MultiProvider(providers: [
                  ChangeNotifierProvider(create: (_) => FaceCameraProvider()),
                  ChangeNotifierProvider(
                      create: (_) => UploadBtnProvider(false,tag)),
                ], child: MakerPage());
              },
              fullscreenDialog: true));

    notifyListeners();
  }

  getHeroTag() {
    return heroTag;
  }
}
