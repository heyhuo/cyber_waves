import 'package:flutter/material.dart';

class GeneratorProvider extends ChangeNotifier {
  var imageBytes;
  var image;

  setImage(_imageBytes) {
    imageBytes = _imageBytes;
    notifyListeners();
  }
}
