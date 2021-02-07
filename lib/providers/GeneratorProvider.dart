import 'package:flutter/material.dart';

class GeneratorProvider extends ChangeNotifier {
  var imageBytes;
  var image;
  var outImageBytesList = List();

  setImage(_imageBytes) {
    imageBytes = _imageBytes;
    notifyListeners();
  }

  addOutImage(_imageByte){
    outImageBytesList.add(_imageByte);
    notifyListeners();
  }
}
