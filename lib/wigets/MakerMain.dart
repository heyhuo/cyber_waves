import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:cyber_waves/providers/FaceCameraProvider.dart';
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
  FaceCameraProvider provider;
  CameraController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
    // _controller=provider.cameraController;
  }

  /*_getWaifuList(imgList){
    Column(
        children: [List.generate(imgList.length, (index){
          return Row(children: [List.],);
        })]);
    Row(
      children: [
        _getWaifu("sakura.png"),
        _getWaifu("sakura.png"),
      ],
    )
  }*/
  // _getWaifu(imgName) {
  //   return Container(
  //     margin: EdgeInsets.only(left: 12 * rpx, top: 10 * rpx),
  //     padding: EdgeInsets.only(top: 10),
  //     width: 355 * rpx,
  //     height: 320 * rpx,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       //color: Theme.of(context).primaryColor.withOpacity(0.6),
  //     ),
  //     child: Image.asset("assets/waifus/${imgName}"),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<FaceCameraProvider>(context);
    if (provider == null) {
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
          child: ListTile(
            leading: Container(
              width: 10 * rpx,
            ),
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // Navigator.pop(context);
                }),
            title: Center(
              child: Text("Waifu Animate"),
            ),
          ),
        ),

        /*相机界面*/
        FaceCameraMain(
            size: Size(400 * rpx, 650 * rpx), rpx: rpx, provider: provider)
      ],
    );
  }
}
