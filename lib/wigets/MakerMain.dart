import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:cyber_waves/providers/FaceCameraProvider.dart';
import 'package:cyber_waves/providers/UploadBtnProvider.dart';
import 'package:flutter/material.dart';

import 'package:cyber_waves/wigets/FaceDetectCamera.dart';
import 'package:provider/provider.dart';

class MakerMain extends StatefulWidget {
  const MakerMain({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _MakerMainState createState() => _MakerMainState();
}

class _MakerMainState extends State<MakerMain> {
  double rpx;
  bool _stickerVisible = false;
  FaceCameraProvider _cameraProvider;
  UploadBtnProvider _uploadBtnProvider;
  CameraController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
    // _controller=provider.cameraController;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cameraProvider = Provider.of<FaceCameraProvider>(context);
    _uploadBtnProvider = Provider.of<UploadBtnProvider>(context);
    if (_cameraProvider == null) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Column(
      children: [
        /*标题*/
        Container(
          margin: EdgeInsets.only(top: 30),
          height: 80 * rpx,
          color: Colors.black,
          // child:
          // ListTile(
          //   leading: Container(
          //     width: 10 * rpx,
          //   ),
          //   trailing: IconButton(
          //       icon: Icon(Icons.close),
          //       onPressed: () {
          //         // Navigator.pop(context);
          //       }),
          //   title: Center(
          //     child: Text("Waifu Animate"),
          //   ),
          // ),
        ),

        /*相机界面*/
        FaceCameraMain(size: Size(400 * rpx, 650 * rpx), rpx: rpx)
      ],
    );
  }
}
