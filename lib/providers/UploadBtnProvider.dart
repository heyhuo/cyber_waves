import 'package:cyber_waves/models/AnimeOriginalModel.dart';
import 'package:cyber_waves/pages/GeneratorPage.dart';
import 'package:cyber_waves/pages/MakerPage.dart';
import 'package:cyber_waves/pages/UploadPage.dart';
import 'package:cyber_waves/providers/MusicProvider.dart';
import 'package:cyber_waves/providers/UploadPostItemProvider.dart';
import 'package:cyber_waves/providers/GeneratorProvider.dart';
import 'package:cyber_waves/tools/sqliteHelper.dart';
import 'package:cyber_waves/wigets/MakerMain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FaceCameraProvider.dart';
import 'WrapPicListProvider.dart';

class UploadBtnProvider extends ChangeNotifier {
  bool visible = false;
  String heroTag;

  UploadBtnProvider(this.visible, this.heroTag);

  setVisible() {
    visible = !visible;
    notifyListeners();
  }

  setHeroTag(tag, context) async {
    heroTag = tag;
    if ("sticker" == tag)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) {
                return MultiProvider(providers: [
                  ChangeNotifierProvider(create: (_) => FaceCameraProvider()),
                  ChangeNotifierProvider(
                      create: (_) => UploadBtnProvider(false, tag)),
                ], child: MakerPage());
              },
              fullscreenDialog: true));
    else if ("picture" == tag) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UploadPostItemProvider()),
            ChangeNotifierProvider(create: (_) => MusicProvider()),
            ChangeNotifierProvider(create: (_) => WrapPicListProvider("uploader"))
          ],
          child: UploadPage(),
        );
      }));
    } else if ("video" == tag) {
      // await Future.delayed(Duration(seconds: 1));
      List<AnimeOriginalModel> picList =
          await SqliteHelper().findAnimeList("heyhuo", "");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) {
                return MultiProvider(providers: [
                  ChangeNotifierProvider(
                      create: (_) => GeneratorProvider(picList: picList)),
                ], child: GeneratorPage());
              },
              fullscreenDialog: true));
    }
    notifyListeners();
  }

  getHeroTag() {
    return heroTag;
  }
}
