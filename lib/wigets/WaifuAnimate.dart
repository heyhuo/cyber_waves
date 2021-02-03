import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:quiver/async.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class WaifuAnimate extends StatefulWidget {
  const WaifuAnimate({Key key, @required this.faces, this.rpx, this.imagePath})
      : super(key: key);
  final List<Face> faces;
  final double rpx;
  final imagePath;

  @override
  _WaifuAnimateState createState() => _WaifuAnimateState();
}

class _WaifuAnimateState extends State<WaifuAnimate> {
  GlobalKey animateWidgetKey = GlobalKey();

  List<Face> faces;
  double rpx;
  var imagePath;
  var imageName;
  var _imgBytes;
  List<Uint8List> images = List();
  int _time = 0;
  bool recording = false;

  requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.storage,
      Permission.microphone,
    ].request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
    // faces = widget.faces;
    // imagePath = widget.imagePath;
    requestPermissions();
    startTimer();
  }

  void startTimer() {
    CountdownTimer countdownTimer = new CountdownTimer(
        new Duration(seconds: 1000), new Duration(seconds: 1));

    var sub = countdownTimer.listen(null);
    sub.onData((data) {
      setState(() => _time++);
    });

    sub.onDone(() {
      print("ScreenRecord Done.");
      sub.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    faces = widget.faces;
    imageName = widget.imagePath;
    if (imageName != null)
      imagePath = "assets/poser_img/$imageName/$imageName-0-0-4.png";

    return Container(
      // padding: EdgeInsets.symmetric(vertical: 50*rpx,horizontal: 20*rpx),
      width: 750 * rpx,
      height: 600 * rpx,
      decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(20),
          color: Colors.black),
      child: Stack(
        children: [
          RepaintBoundary(
            key: animateWidgetKey,
            child: Stack(
              children: [
                /*背景板*/
                Container(
                  width: 750 * rpx,
                  height: 600 * rpx,
                  child: Image.asset(
                    "assets/images/bg2.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
                /*高斯模糊*/
                Container(
                  width: 750 * rpx,
                  height: 600 * rpx,
                  decoration: BoxDecoration(
                    color: (Color.fromRGBO(225, 225, 225, 1)).withOpacity(0.6),
                    // borderRadius: BorderRadius.circular(20),
                  ),
                ),
                /*waifu*/
                Positioned(
                  bottom: 0,
                  left: 160 * rpx,
                  child: Container(
                    width: 200 * rpx * 2,
                    height: 200 * rpx * 2,
                    child: imagePath == null
                        ? Center(
                            child: Container(
                            child: Text("左下角选个形象吧~"),
                          ))
                        : /*(faces == null || faces.length == 0)
                            ? Image.asset(imagePath)
                            : _setVp(),*/
                    ImagesAnimation(
                          w: 100,
                          h: 100,
                          entry: ImagesAnimationEntry(0, 4,
                              "assets/poser_img/$imageName/$imageName-%s-0-4.png"))
                  ),
                ),
              ],
            ),
          ),
          //
          // 截图录屏按钮
          // Positioned(
          //     bottom: 0,
          //     right: 10,
          //     child: CircleAvatar(
          //       child: IconButton(
          //           icon: Icon(Icons.play_arrow),
          //           color: Colors.black,
          //           onPressed: () {
          //             _capturePng();
          //           }),
          //     )),
          /*截图展示区域*/
          // Positioned(
          //     bottom: 0,
          //     left: 0,
          //     child: Container(
          //       // padding: EdgeInsets.symmetric(horizontal: 3),
          //       height: 110,
          //       width: 120,
          //       color: Colors.black.withOpacity(0.5),
          //       child:
          //           images.length > 0 ? Image.memory(images.last) : Text("das"),
          //     )),
        ],
      ),
    );
  }

  /* 获取截图 */
  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          animateWidgetKey.currentContext.findRenderObject();
      // boundary.
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      images.add(pngBytes);
      setState(() {});

      // Directory documentsDirectory = await getExternalStorageDirectory();
      // String path =
      //     join(documentsDirectory.path, Uuid().v4().toString() + ".png");
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

  _EuclideanDist(Offset p0, Offset p1) {
    var p = pow(p0.dx - p1.dx, 2) + pow(p0.dy - p1.dy, 2);
    return sqrt(p);
  }

  _getEAR(List<Offset> leftEye) {
    return (_EuclideanDist(leftEye[3], leftEye[13]) +
            _EuclideanDist(leftEye[4], leftEye[12]) +
            _EuclideanDist(leftEye[5], leftEye[11])) /
        (3 * _EuclideanDist(leftEye[0], leftEye[8]));
  }

  _getEyeIdx(EARThresh, leftEAR) {
    var e = (EARThresh - leftEAR) * 10;
    var idx; // [-∞,0.15)
    if (e < 0.15)
      idx = 0;
    else if (e >= 0.15) // [0.15,0.4)
      idx = 3;
    else if (e >= 0.4 && e < 0.65) // [0.4,0.65)
      idx = 6;
    else
      idx = 9; // [0.65,1]
    return idx;
  }

  _getMouthIdx(MAR) {
    var mouthIdx = 0;
    if (MAR < 0.2) // [-∞,0.2)
      mouthIdx = 0;
    else if (MAR >= 0.2 && MAR < 0.35) // [0.2,0.55)
      mouthIdx = 3;
    else if (MAR >= 0.35 && MAR < 0.55) // [0.55,0.85]
      mouthIdx = 6;
    else
      mouthIdx = 9;
    return mouthIdx;
  }

  _setVp() {
    var rightIdx = 0;
    var leftIdx = 0;
    var mouthIdx = 0;

    Face face = faces.first;

    final List<Offset> leftEye =
        face.getContour(FaceContourType.leftEye).positionsList;

    final List<Offset> rightEye =
        face.getContour(FaceContourType.rightEye).positionsList;

    final List<Offset> lowerLipTop =
        face.getContour(FaceContourType.lowerLipTop).positionsList;
    final List<Offset> upperLipBottom =
        face.getContour(FaceContourType.upperLipBottom).positionsList;

    final List<Offset> facePoints =
        face.getContour(FaceContourType.face).positionsList;

    // facePoints.length/2;

    /*
    * 眼睛纵横比  EAR = ||p3-p13|| + ||p4-p12|| / 2 * ||p0-p8||
    * 人眼纵横比阈值 0.3
    * 嘴巴纵横比：MAR =  (||lt4-ub4||+||lt5-ub5||)/(||lt0-lt8||+||ub0-ub8||)
    * */

    var EARThresh = 0.3;

    var leftEAR = _getEAR(leftEye);
    var rightEAR = _getEAR(rightEye);

    var MAR = (_EuclideanDist(lowerLipTop[4], upperLipBottom[4]) +
            _EuclideanDist(lowerLipTop[5], upperLipBottom[5])) /
        (_EuclideanDist(lowerLipTop[0], lowerLipTop[8]) +
            _EuclideanDist(upperLipBottom[0], upperLipBottom[8]));

    mouthIdx = _getMouthIdx(MAR);
    leftIdx = _getEyeIdx(EARThresh, leftEAR);
    rightIdx = _getEyeIdx(EARThresh, rightEAR);

    print(
        "MAR:${MAR}-${mouthIdx};left EAR:${0.3 - leftEAR}；leftCloseRate：${leftIdx}；rightCloseRate：${rightIdx}");

    // print("face len:${facePoints[0].dy - facePoints[18].dy}；"
    //     "left eye:${leftEyebrowBottom.first.dy - leftEyebrowTop.first.dy}");

    var imgName =
        "assets/poser_img/$imageName/$imageName-${rightIdx}-${leftIdx}-${mouthIdx}.png";

    return Image.asset(imgName);
  }
}

class ImagesAnimation extends StatefulWidget {
  const ImagesAnimation(
      {Key key, this.w: 80, this.h: 80, this.entry, this.durationSeconds: 300})
      : super(key: key);
  final double w;
  final double h;
  final ImagesAnimationEntry entry;
  final int durationSeconds;

  @override
  _ImagesAnimationState createState() => _ImagesAnimationState();
}

class _ImagesAnimationState extends State<ImagesAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.durationSeconds))
      ..repeat();
    _animation =
        IntTween(begin: widget.entry.lowIndex, end: widget.entry.highIndex)
            .animate(_controller);
    // _animation = ;
    //widget.entry.lowIndex 表示从第几下标开始，如0；widget.entry.highIndex表示最大下标：如7
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget child) {
          String frame = _animation.value.toString();
          return Image.asset(
            sprintf(widget.entry.basePath, [frame]), //根据传进来的参数拼接路径
            gaplessPlayback: true, //避免图片闪烁
            width: widget.w,
            height: widget.h,
          );
        });
  }
}

class ImagesAnimationEntry {
  int lowIndex = 0;
  int highIndex = 0;
  String basePath;

  ImagesAnimationEntry(this.lowIndex, this.highIndex, this.basePath);
}
