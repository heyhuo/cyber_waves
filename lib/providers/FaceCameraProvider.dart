import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



class FaceCameraProvider extends State<StatefulWidget>
    with ChangeNotifier, TickerProviderStateMixin {

  int curCamera = 0; //后置
  CameraController cameraController;
  List<CameraDescription> cameras;

  changeCamera() {
    if (curCamera == 0) {
      curCamera = 1;
    } else {
      curCamera = 0;
    }
    cameraController =
        CameraController(cameras[curCamera], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}