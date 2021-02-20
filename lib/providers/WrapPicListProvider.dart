import 'dart:typed_data';

import 'package:cyber_waves/providers/GeneratorProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class WrapPicListProvider extends ChangeNotifier {
  List<Asset> mulPicAssetList = List<Asset>();
  List<String> picPathList = List<String>();
  List<Uint8List> picList = List<Uint8List>();
  int selPicIdx;
  String tag;
  Uint8List selPic;
  StorageBitmap storageBitmap = new StorageBitmap();

  WrapPicListProvider(this.tag);

  getUint8List(idx, quality) async {
    var bytes = await this.mulPicAssetList[idx].getByteData(quality: quality);
    return bytes.buffer.asUint8List();
  }

  setPicIdx(idx) async {
    if (this.selPicIdx != idx) {
      this.selPicIdx = idx;
      selPic = await getUint8List(idx, 30);
    }
    notifyListeners();
  }

  removePic(index) async {
    if (index > 0) {
      this.selPicIdx = 0;
      this.selPic = await getUint8List(0, 30);
    } else {
      this.selPic = null;
    }
    this.mulPicAssetList.removeAt(index);
    // storageBitmap.deleteFile(this.picPathList[index]);
    // this.picPathList.removeAt(index);
    notifyListeners();
  }

  Future multiImagePicker(mulPicAssetList) async {
    // List<Uint8List> picList = List<Uint8List>();
    // for (var asset in mulPicAssetList) {
    //   var bytedata =  asset.getByteData();
    //   picList.add(bytedata.buffer.asUint8List());
    // }
    this.mulPicAssetList = mulPicAssetList;
    this.selPicIdx = 0;
    this.selPic = await getUint8List(0, 30);
    // this.picList = picList;
    /*List<String> picList = List<String>();
   for (int i = 0; i < mulPicAssetList.length; i++) {
      String animeName = await mulPicAssetList[i].name;
      */ /*存文件到cache中后返回路径*/ /*
      String path = await FlutterAbsolutePath.getAbsolutePath(
          mulPicAssetList[i].identifier);
      picList.add(path);
    }
    this.picPathList = picList;*/
    notifyListeners();
  }
}
