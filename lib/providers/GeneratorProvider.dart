import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:cyber_waves/models/AnimeOriginalModel.dart';
import 'package:cyber_waves/tools/sqliteHelper.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:cyber_waves/pages/GeneratorPage.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

class GeneratorProvider extends ChangeNotifier {
  var imageBytes;
  var image;
  var imageBytesList = List();
  var jsonMap = {};
  var fileName = "roa";
  var imageName = "assets/waifus/roa.png";
  int epcho = 10;
  int selPicIdx;
  List<Asset> mulPicAssetList = List<Asset>();
  List<AnimeOriginalModel> picList;
  AnimeOriginalModel showModel;
  StorageBitmap storageBitmap = new StorageBitmap();
  SqliteHelper sqliteHelper = new SqliteHelper();
  bool isGenerating = false;

  GeneratorProvider({this.picList});

  setSelPicIdx(idx) {
    selPicIdx = idx;
    notifyListeners();
  }

  setGenerating() {
    isGenerating = !isGenerating;
    notifyListeners();
  }

  updateGenerateTag(userId, animeId) async {
    findImage(userId, "");
    sqliteHelper.updateAnimeGenerateTag(userId, animeId);
    notifyListeners();
  }

  setShowModel(AnimeOriginalModel model) {
    showModel = model;
    if (model.generateTag == 1) {
      readFile(model.userId, model.animeId);
    }
    notifyListeners();
  }

  /*多图选择*/
  Future multiImagePicker(mulPicAssetList) async {
    mulPicAssetList = mulPicAssetList;

    List<AnimeOriginalModel> modelList = List<AnimeOriginalModel>();
    // 上传照片时一张一张上传
    for (int i = 0; i < mulPicAssetList.length; i++) {
      // 获取 ByteData
      String animeName = await mulPicAssetList[i].name;
      // int width = mulPicAssetList[i].originalWidth;
      // int height = mulPicAssetList[i].originalHeight;
      // var byteData = await mulPicAssetList[i].getByteData();

      /*存文件到cache中后返回路径*/
      String path = await FlutterAbsolutePath.getAbsolutePath(
          mulPicAssetList[i].identifier);

      // List<int> imageData = byteData.buffer.asUint8List();

      // imageData = DecodeBitmapToImage()
      //     .convertBitmap(imageData, width: width, height: height);
      // String path =
      //     await storageBitmap.writeToImage(imageData, "heyhuo", animeName);
      modelList.add(AnimeOriginalModel(
          animeId: Uuid().v4().toString(),
          userId: "heyhuo",
          animeName: animeName,
          animePath: path,
          generateTag: 0,
          uploadDate: DateTime.now()));
    }
    sqliteHelper.addAnimeList(modelList);
    // picList=modelList;
    findImage("heyhuo", "");

    notifyListeners();
  }

  findImage(userId, animeId) async {
    picList = await sqliteHelper.findAnimeList(userId, animeId);
    notifyListeners();
  }

  setImage(_imageBytes) {
    imageBytes = _imageBytes;
    notifyListeners();
  }

  addOutImage(_imageByte) {
    imageBytesList.add(_imageByte);
    notifyListeners();
  }

  removePic(index, animeId, animePath) {
    storageBitmap.deleteFile(animePath);
    sqliteHelper.delAnime(animeId);
    this.picList.removeAt(index);
    notifyListeners();
  }

  addJsonStr(params, bitmap) {
    var json = {
      'leftEye': params[0],
      'rightEye': params[1],
      'mouth': params[2],
      'bitmap': DecodeBitmapToImage(imgBytes: bitmap)
          .decodeBitmap(isBuildToBitmap: true),
    };
    // String jsonStr = convert.jsonEncode(json);
    String key =
        (params[0] * 1000 + params[1] * 100 + params[2] * 10).toString();
    jsonMap[key] = json;

    notifyListeners();
  }

  writeFile(fileDir, fileName) async {
    var str = convert.jsonEncode(this.jsonMap);
    storageBitmap.writeToFile(str, fileDir, '$fileName.json');
    notifyListeners();
  }

  readFile(fileDir, fileName) async {
    imageBytesList.clear();
    String jsonStr = await storageBitmap.readBitmap(fileDir, '$fileName.json');
    Map<String, Object> map = convert.jsonDecode(jsonStr);
    map.forEach((key, value) {
      imageBytesList.add(value);
    });
    notifyListeners();
  }
}

class StorageBitmap {
  /*获取临时文件夹路径*/
  Future<String> get _localPath async {
    final _path = await getTemporaryDirectory();
    return _path.path;
  }

  /*创建指向文件位置的引用*/
  Future<File> _localFile(fileDir, fileName) async {
    final path = await _localPath;
    Directory usrDir = new Directory('$path/$fileDir');
    if (!usrDir.existsSync()) {
      usrDir.createSync();
      print('文档初始化成功，文件保存路径为 ${usrDir.path}');
    }
    File file = new File('${usrDir.path}/$fileName');
    if (!file.existsSync()) {
      file.createSync();
      print('${usrDir.path}/$fileName创建成功');
    }

    return file;
  }

  /*写入数据到文件内*/
  Future<File> writeToFile(json, fileDir, fileName) async {
    final jsonFile = await _localFile(fileDir, fileName);
    return jsonFile.writeAsString(json);
  }

  /*存图片到文件*/
  Future<String> writeToImage(bytes, fileDir, fileName) async {
    final file = await _localFile(fileDir, fileName);
    file.writeAsBytesSync(img.encodePng(img.decodeImage(bytes)));
    String path = await _localPath + "/$fileDir/$fileName";
    return path;
  }

  /*从文件读取数据*/
  Future<String> readBitmap(fileDir, fileName) async {
    try {
      final file = await _localFile(fileDir, fileName);
      String bitmap = await file.readAsString();
      return bitmap;
    } catch (e) {
      return "";
    }
  }

  deleteFile(path) async {
    File(path).deleteSync();
  }
}

class DecodeBitmapToImage {
  List imgBytes;
  bool isReshape;

  DecodeBitmapToImage({this.imgBytes, this.isReshape = true});

  Uint8List decodeBitmap({bool isBuildToBitmap = true}) {
    var inputSize = 256;
    var len = inputSize * inputSize;
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 4);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    int idx = 0;

    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var r, g, b, a;
        if (!isReshape) {
          r = imgBytes[pixelIndex];
          g = imgBytes[len + pixelIndex];
          b = imgBytes[len * 2 + pixelIndex];
          a = imgBytes[len * 3 + pixelIndex];
          pixelIndex++;
        } else {
          r = imgBytes[0][0][i][j];
          g = imgBytes[0][1][i][j];
          b = imgBytes[0][2][i][j];
          a = imgBytes[0][3][i][j];
        }
        var red = linearToSrgb(r, false);
        var green = linearToSrgb(g, false);
        var blue = linearToSrgb(b, false);
        var alpha = linearToSrgb(a, true);

        buffer[idx++] = red;
        buffer[idx++] = green;
        buffer[idx++] = blue;
        buffer[idx++] = alpha;
      }
    }

    var list = buffer.buffer.asUint8List();

    return isBuildToBitmap ? convertBitmap(list) : list;
  }

  Uint8List convertBitmap(list, {width = 256, height = 256}) {
    Bitmap bitmap = Bitmap.fromHeadless(width, height, list);
    Uint8List headedBitmap = bitmap.buildHeaded();
    return headedBitmap;
  }

  int linearToSrgb(pixel, bool isAlpha) {
    var x = pixel;
    if (!isAlpha) x = (x + 1.0) * 0.5;

    if (x < 0.0)
      x = 0;
    else if (x > 1.0) x = 1.0;

    if (!isAlpha) {
      if (x <= 0.003130804953560372) {
        x *= 12.92;
      } else {
        x = 1.055 * pow(x, 1.0 / 2.4) - 0.055;
      }
    }

    return (x * 255.0).toInt();
  }
}
