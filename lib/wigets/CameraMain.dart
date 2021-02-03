import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cyber_waves/providers/CameraProvider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'package:vibrate/vibrate.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CameraMain(
        rpx: MediaQuery.of(context).size.width / 750,
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}

class CameraMain extends StatefulWidget {
  const CameraMain({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _CameraMainState createState() => _CameraMainState();
}

class _CameraMainState extends State<CameraMain> {
  CameraProvider provider;
  double rpx;
  double toTop;
  double outBox;
  double innerBox;
  CameraController _controller;
  bool findFace = false;
  var cameras;

  @override
  void initState() {
    super.initState();
    rpx = widget.rpx;
    toTop = 100 * rpx;
    outBox = 170 * rpx;
    innerBox = 130 * rpx;
  }

  getCameras() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras[1], ResolutionPreset.medium);

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller.startImageStream((CameraImage availableImage) {
        _controller.stopImageStream();
        _scanFrame(availableImage);
      });

      setState(() {});
    });
  }

  void _scanFrame(CameraImage availableImage) async {
    final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
        rawFormat: availableImage.format.raw,
        size: Size(
            availableImage.width.toDouble(), availableImage.height.toDouble()),
        planeData: availableImage.planes
            .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
            bytesPerRow: currentPlane.bytesPerRow,
            height: currentPlane.height,
            width: currentPlane.width))
            .toList(),
        rotation: ImageRotation.rotation90);
    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromBytes(availableImage.planes[0].bytes, metadata);
    final FaceDetector detector = FirebaseVision.instance.faceDetector();
    final List<Face> faces = await detector.processImage(visionImage);

    if (faces.length > 0) {
      setState(() {
        findFace = true;
        _controller.startImageStream((CameraImage availableImage) {
          _controller.stopImageStream();
          _scanFrame(availableImage);
        });
      });
    } else {
      setState(() {
        findFace = false;
        _controller.startImageStream((CameraImage availableImage) {
          _controller.stopImageStream();
          _scanFrame(availableImage);
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CameraProvider>(context);
    _controller = provider.cameraController;
    if (provider == null || _controller == null) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    bool ifMakeVideo = provider.ifMakeVideo;
    if (_controller == null || _controller?.value == null) {
      return Container(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;

    return _controller.value.isInitialized
        ? Stack(children: <Widget>[
      // Camera.open(cameraId),
      findFace
          ? Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 100,
            height: 100,
            color: Colors.red,
          ))
          : Container(),
      ClipRect(
          child: Transform.scale(
            scale: _controller.value.aspectRatio / size.aspectRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: CameraPreview(_controller),
              ),
            ),
          )),
      Positioned(
        //顶部关闭按钮
        top: toTop,
        left: 30 * rpx,
        child: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 60 * rpx,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Positioned(
        //选择音乐
        top: toTop,
        left: 250 * rpx,
        child: Container(
          width: 250 * rpx,
          child: FlatButton(
            onPressed: () {},
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10 * rpx,
                ),
                Text(
                  "选择音乐",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        //拍照按钮
        bottom: 160 * rpx,
        // left: (750*rpx-outBox)/2,
        child: Container(
            width: 750 * rpx,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  /* 底部贴纸弹窗 */
                  ifMakeVideo
                      ? Container(
                    width: 80 * rpx,
                  )
                      : FlatButton(
                    child: IconWithText(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.white,
                      ),
                      text: "Vup",
                    ),
                    padding: EdgeInsets.all(0),
                    onPressed: () {},
                  ),

                  /* 底部自制 */
                  ifMakeVideo
                      ? AnimVideoButton(
                    rpx: rpx,
                    outWidth: outBox,
                    innerWidth: innerBox - 30 * rpx,
                    provider: provider,
                  )
                      : CircleTakePhoto(
                    outBox: outBox,
                    innerBox: innerBox,
                  ),
                  ifMakeVideo
                      ? IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColorLight,
                      //Color.fromARGB(255, 219, 48, 85),
                      size: 80 * rpx,
                    ),
                    onPressed: () async {
                      provider.cameraController
                          .stopVideoRecording();
                      // await ImageGallerySaver.saveFile(
                      //     provider.fileName);
                      // File(provider.fileName).delete();
                    },
                  )
                      : IconWithText(
                      icon: Icon(
                        Icons.tonality_outlined,
                        color: Colors.white,
                      ),
                      text: "自制"),
                ])),
      ),
      !ifMakeVideo
          ? Positioned(
        bottom: 40 * rpx,
        child: ScrollBottomBar(
          rpx: rpx,
        ),
      )
          : Positioned(
        bottom: 40 * rpx,
        child: Container(),
      ),
      Positioned(
        right: 30 * rpx,
        top: 100 * rpx,
        child: IconButton(
            icon: Icon(
              Icons.cached_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              provider.changeCamera();
            }),
      )
    ])
        : Container();
  }
}

/*拍照*/
class CircleTakePhoto extends StatelessWidget {
  const CircleTakePhoto(
      {Key key, @required this.outBox, @required this.innerBox})
      : super(key: key);
  final double outBox;
  final double innerBox;

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    CameraProvider provider = Provider.of<CameraProvider>(context);

    // double outBox=160*rpx;
    // double innerBox=130*rpx;
    return Container(
      width: outBox,
      height: outBox,
      padding: EdgeInsets.all(10 * rpx),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(90 * rpx),
        border: Border.all(
          width: 10 * rpx,
          color: Theme.of(context)
              .primaryColor, //Color.fromARGB(128, 219, 48, 85),
        ),
      ),
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () async {
            // provider.changeFileName('png');
            // print(provider.fileName);
            // await provider.cameraController
            //     .takePicture(provider.fileName)
            //     .then((_) {
            //   // Navigator.push(context, MaterialPageRoute(fullscreenDialog: true,builder: (_){
            //   //   return Image.file(File(provider.fileName) );
            //   // }));
            //   ImagePickerSaver.saveFile(
            //       fileData: File(provider.fileName).readAsBytesSync());
            // });
            provider.changeFileName('mp4');
            provider.cameraController.startVideoRecording(provider.fileName);
            //
            provider.changePhotoWidget();
          },
          child: Container(
            width: innerBox,
            height: innerBox,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .primaryColorLight, //Color.fromARGB(255, 219, 48, 85),
                borderRadius: BorderRadius.circular(75 * rpx)),
          )),
    );
  }
}

class IconWithText extends StatelessWidget {
  const IconWithText({Key key, @required this.icon, @required this.text})
      : super(key: key);
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        icon,
        Text(
          text,
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}

class AnimVideoButton extends StatefulWidget {
  AnimVideoButton(
      {Key key,
        @required this.outWidth,
        @required this.innerWidth,
        @required this.rpx,
        @required this.provider})
      : super(key: key);
  final double outWidth;
  final double innerWidth;
  final double rpx;
  final CameraProvider provider;

  _AnimVideoButtonState createState() => _AnimVideoButtonState();
}

class _AnimVideoButtonState extends State<AnimVideoButton>
    with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double outWidth;
  double innerWidth;
  double outBorder;
  double rpx;
  double maxBorder;
  bool ifRecording;
  CameraProvider provider;
  double curBorder;

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ifRecording = true;
    provider = widget.provider;
    outWidth = widget.outWidth;
    innerWidth = widget.innerWidth;
    rpx = widget.rpx;
    outBorder = 5 * rpx;
    maxBorder = (outWidth - innerWidth) / 2 - 10 * rpx;
    curBorder = outBorder;
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation =
    Tween<double>(begin: outBorder, end: maxBorder).animate(controller)
      ..addListener(() {
        setState(() {
          curBorder = animation.value;
        });
      });
    controller.repeat(reverse: true);
  }

  pauseRecording() {
    controller.stop();
    provider.cameraController.pauseVideoRecording();
    setState(() {
      ifRecording = false;
    });
  }

  resumeRecording() {
    controller.repeat(reverse: true);
    provider.cameraController.resumeVideoRecording();
    setState(() {
      ifRecording = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: outWidth,
      height: outWidth,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            width: curBorder,
            color: Theme.of(context)
                .primaryColor, //Color.fromARGB(128, 219, 48, 85),
          )),
      child: Container(
        child: !ifRecording
            ? IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.play_arrow,
            size: innerWidth,
            color: Theme.of(context)
                .primaryColorLight, //Color.fromARGB(255, 219, 48, 85),
          ),
          onPressed: () {
            resumeRecording();
          },
        )
            : IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.pause,
            size: innerWidth,
            color: Theme.of(context)
                .primaryColorLight, //Color.fromARGB(255, 219, 48, 85),
          ),
          onPressed: () {
            pauseRecording();
          },
        ),
      ),
    );
  }
}

/*
 * 相机底部导航栏
 */
class ScrollBottomBar extends StatefulWidget {
  final double rpx;

  const ScrollBottomBar({Key key, @required this.rpx}) : super(key: key);

  @override
  _ScrollBottomBarState createState() => _ScrollBottomBarState();
}

// Listener->SingleChildScrollView->Row

class _ScrollBottomBarState extends State<ScrollBottomBar> {
  double rpx;
  double eachWidth;
  double eachSide;
  List<String> items; //权限
  ScrollController controller;
  double startX = 0;
  double finalX = 0;
  double minValue;
  double maxValue;
  double curX;
  int curIndex;

  @override
  void initState() {
    super.initState();
    rpx = widget.rpx;
    eachWidth = 130 * rpx;
    eachSide = (750 - eachWidth / rpx) / 2 * rpx;
    curIndex = 2;
    minValue = 0;

    items = ['拍照', '拍15秒', '拍60秒', '影集', '开直播'];
    maxValue = (items.length - 1) * eachWidth;
    curX = curIndex * eachWidth;
    controller = ScrollController(initialScrollOffset: curX);
  }

  moveToItem(index) async {
    curX = index * eachWidth;
    controller.animateTo(curX,
        duration: Duration(milliseconds: 200), curve: Curves.linear);
    // bool canVibrate =  await Vibrate.canVibrate;
    // print(canVibrate);
    // Vibrate.vibrate();
    setState(() {
      curX = curX;
      curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Listener(
          onPointerDown: (result) {
            setState(() {
              startX = result.position.dx;
            });
          },
          onPointerMove: (result) {
            double moveValue = result.position.dx;
            double moved = startX - moveValue;
            double afterMoved = min(max(curX + moved, minValue), maxValue);
            setState(() {
              curX = afterMoved;
              startX = result.position.dx;
            });
          },
          onPointerUp: (result) {
            int index = 0;
            double finalPosition = curX + eachWidth / 2;
            index = (finalPosition / eachWidth).floor();
            moveToItem(index);
          },
          child: Container(
            width: 750 * rpx,
            height: 100 * rpx,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: controller,
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: eachSide,
                    ),
                    Row(
                      children: List.generate(items.length, (index) {
                        return Container(
                          width: eachWidth,
                          child: FlatButton(
                            child: Text(
                              items[index],
                              style: TextStyle(
                                  color: curIndex == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5)),
                            ),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              moveToItem(index);
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      width: eachSide,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColorLight),
            width: 8 * rpx,
            height: 8 * rpx,
          ),
        )
      ],
    );
  }
}
