import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:cyber_waves/providers/FaceCameraProvider.dart';
import 'package:cyber_waves/wigets/WaifuAnimate.dart';
import 'package:cyber_waves/wigets/video_timer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/async.dart';

class FaceCameraMain extends StatefulWidget {
  const FaceCameraMain(
      {Key key,
      @required this.size,
      @required this.rpx,
      @required this.provider})
      : super(key: key);
  final Size size;
  final double rpx;
  final FaceCameraProvider provider;

  @override
  _FaceCameraMainState createState() => _FaceCameraMainState();
}

class _FaceCameraMainState extends State<FaceCameraMain> {
  CameraController _camera;
  FaceCameraProvider provider;
  List<CameraDescription> cameras;
  double widthRate;
  Size size;
  bool isProcess = false;
  List<Face> faces;
  CustomPainter painter;
  bool cameraEnabled = true;
  bool _isDetecting = true;
  bool _ctrlBtnVisible = true;
  var cmIdx = 0; //0 后置
  var quality = ResolutionPreset.low;
  var _imagePath;
  FaceDetector detector;
  List<String> stickerList = List<String>();

  GlobalKey animateWidgetKey = GlobalKey();

  double rpx;
  bool _stickerVisible = false;
  bool _isRecording = false;
  final _timerKey = GlobalKey<VideoTimerState>();
  IconData _faceDetectIcon = Icons.face_unlock_outlined;
  IconData _cameraIcon = Icons.camera_rear_outlined;
  Color _faceDetectColor = Colors.white;
  Color _cameraColor = Colors.white;
  int _time = 0;

  requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.storage,
      Permission.microphone,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    size = widget.size;
    rpx = widget.rpx;
    provider = widget.provider;

    requestPermissions();
    startTimer();

    stickerList = ["haru", "rize", "sakura", "haru", "rize", "sakura"];

    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    // _camera = provider.cameraController;
    if (_camera == null || !_camera.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        /*虚拟预览*/
        WaifuAnimate(
          faces: faces,
          rpx: rpx,
          imagePath: _imagePath,
        ),
        /*贴纸列表*/
        Container(
          height: 929.3 * rpx,
          width: 750 * rpx,
          color: Colors.black,
          child: Stack(
            children: [
              /*面部轮廓预览界面*/
              Positioned(
                  child: Container(
                height: 650 * rpx,
                color: Colors.black.withOpacity(0.6),
                child: Stack(
                  children: [
                    /* 相机预览框 */
                    cameraEnabled
                        ? ClipRect(
                            child: Container(
                              // width: 750*rpx,
                              height: size.height,
                              child: Transform.scale(
                                  scale: 1,
                                  child: Center(
                                    child: AspectRatio(
                                      aspectRatio: _camera.value.aspectRatio,
                                      child: CameraPreview(_camera),
                                    ),
                                  )),
                            ),
                          )
                        : Container(
                            width: size.width,
                            height: size.height,
                            color: Colors.black,
                          ),

                    /* 人脸画框结构：FittedBox=>SizedBox=>CustomPaint */
                    _isDetecting
                        ? _facePainterBox()
                        : Center(
                            child: Container(
                              width: size.width * 1.25,
                              height: size.height,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),

                    /*相机功能按钮组件*/
                    Visibility(
                      visible: _ctrlBtnVisible,
                      child: Positioned(
                        top: 30 * rpx,
                        right: 10 * rpx,
                        // height: 350 * rpx,
                        child: Container(
                          width: 80 * rpx,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: () {
                                    // 相机切换
                                    _onCameraSwitch();
                                  },
                                  child: _getCameraIcon(
                                      _cameraIcon, "翻转", Colors.white)),
                              _getCameraIcon(
                                  Icons.aspect_ratio, "画幅", Colors.white),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      cameraEnabled = !cameraEnabled;
                                    });
                                  },
                                  child: _getCameraIcon(
                                      Icons.camera_enhance_outlined,
                                      "相机",
                                      Colors.white)),
                              _getCameraIcon(Icons.camera, "画质", Colors.white),
                              InkWell(
                                onTap: () {
                                  _detectFace();
                                  setState(() {
                                    _isDetecting = !_isDetecting;
                                    if (_isDetecting) {
                                      _faceDetectIcon =
                                          Icons.face_retouching_natural;
                                      _faceDetectColor = Colors.white;
                                    } else {
                                      _faceDetectIcon =
                                          Icons.face_unlock_rounded;
                                      _faceDetectColor = Colors.white38;
                                    }
                                  });
                                },
                                child: _getCameraIcon(
                                    _faceDetectIcon, "面捕", _faceDetectColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Image.asset("assets/images/color_camera.png"),
              )),

              /*时间*/
              Positioned(
                  top: 0,
                  child: VideoTimer(
                    key: _timerKey,
                  )),
              /*录制组件*/
              Positioned(
                bottom: 0,
                child: Container(
                  height: 300 * rpx,
                  width: 750 * rpx,
                  //color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              _stickerVisible = true;
                            });
                          },
                          child: _getCameraCtrlBtn(
                              Icons.emoji_emotions_outlined,
                              Colors.white,
                              35.0,
                              120,
                              120)),
                      /*开始录屏幕*/
                      InkWell(
                          onTap: () {
                            if (_imagePath != null) {
                              if (_isRecording) {
                                // 停止录屏
                                stopScreenRecord();
                              } else {
                                // 开始录屏
                                startScreenRecord(false);
                              }
                            }
                          },
                          child: _getCameraCtrlBtn(
                              _isRecording
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              _imagePath == null ? Colors.grey : Colors.white,
                              80.0,
                              160,
                              160)),
                      InkWell(
                          onTap: () {},
                          child: _getCameraCtrlBtn(Icons.photo_outlined,
                              Colors.white, 35.0, 120, 120)),
                    ],
                  ),
                ),
              ),

              /*贴纸列表组件*/
              Positioned(
                bottom: 0,
                child: Visibility(
                  visible: _stickerVisible,
                  child: Container(
                    width: 750 * rpx,
                    height: 929.3 * rpx,
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.black.withOpacity(0.8),
                    ),
                    //Theme.of(context).primaryColor.withOpacity(0.6)),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 750 * rpx,
                          height: 60 * rpx,
                          color: Colors.transparent,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _stickerVisible = false;
                                });
                              },
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 30.0,
                              )),
                          // color: Colors.white,
                        ),
                        Container(
                          width: 750 * rpx,
                          height: 820 * rpx,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                                child: _getStickerList(stickerList, 4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  /* 检测人脸 */
  Future<void> _detectFace() async {
    if (!_isDetecting) {
      faces = null;
      if (detector != null) detector.close();
    } else {
      _camera.startImageStream((CameraImage image) async {
        if (!isProcess && mounted && _isDetecting) {
          isProcess = false;
          // 创建检测器
          detector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
              enableContours: true, mode: FaceDetectorMode.fast));
          final visionImage = FirebaseVisionImage.fromBytes(
              concatenatePlanes(image.planes),
              buildMetaData(image, ImageRotation.rotation90));

          // detector._isClosed=false;

          detector.processImage(visionImage).then((value) {
            setState(() {
              faces = value;
            });
          });
        }
      });
    }
  }

  /* 切换前后置摄像头 */
  Future<void> _onCameraSwitch() async {
    CameraDescription cameraDescription;
    if (_camera.description == cameras[0]) {
      cameraDescription = cameras[1];
      _cameraIcon = Icons.camera_front_outlined;
    } else {
      cameraDescription = cameras[0];
      _cameraIcon = Icons.camera_rear_outlined;
    }

    if (_camera != null) {
      await _camera.dispose();
    }
    _camera = CameraController(cameraDescription, ResolutionPreset.medium);
    _camera.addListener(() {
      if (mounted) setState(() {});
      if (_camera.value.hasError) {
        showInSnackBar('Camera error ${_camera.value.errorDescription}');
      }
    });

    try {
      await _camera.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  /* 初始化摄像头 */
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    _camera = CameraController(cameras[cmIdx], quality);
    _camera.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  /* 开始录屏 */
  Future<void> startScreenRecord(bool audio) async {
    bool start = false;
    // await Future.delayed(const Duration(milliseconds: 1000));
    _timerKey.currentState.startTimer();

    if (audio) {
      start = await FlutterScreenRecording.startRecordScreenAndAudio(
        "AnimateWithAudio_${_time.toString()})",
      ); //titleNotification: "dsffad",messageNotification: "sdffd"
    } else {
      start = await FlutterScreenRecording.startRecordScreen(
          "Animate_${_time.toString()}"); //,titleNotification: "dsffad",messageNotification: "sdffd"
    }
    if (start) {
      setState(() {
        _isRecording = !_isRecording;
        _ctrlBtnVisible = false;
      });
    }
    return start;
  }

  /* 停止录屏 */
  stopScreenRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    _timerKey.currentState.stopTimer();
    setState(() {
      _isRecording = !_isRecording;
      _ctrlBtnVisible = true;
    });
    print("Opening video");
    print(path);
    OpenFile.open(path);
  }

  /* 获取当前时间戳 */
  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /*开始录制视频
  * 检查相机控制器是否已初始化。
  * 启动计时器以显示记录的视频时间。（可选的）
  * 构造目录并定义路径。
  * 使用摄像机控制器开始录制并将视频保存在定义的路径上。
  */
  Future<String> startVideoRecording() async {
    print("startVideoRecording");
    if (!_camera.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    _timerKey.currentState.startTimer();

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.mp4';

    if (_camera.value.isRecordingVideo) {
      return null;
    }

    try {
      await _camera.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  /* 停止录像
  * 检查相机控制器是否已初始化。
  * 停止计时器。
  * 使用相机控制器停止视频录制。*/
  Future<void> stopVideoRecording() async {
    if (!_camera.value.isRecordingVideo) {
      return null;
    }
    _timerKey.currentState.stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      await _camera.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  FirebaseVisionImageMetadata buildMetaData(
      CameraImage image, ImageRotation rotation) {
    return FirebaseVisionImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rawFormat: image.format.raw,
      rotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width);
        },
      ).toList(),
    );
  }

  concatenatePlanes(List<Plane> planes) {
    WriteBuffer buffers = WriteBuffer();
    planes.forEach((plane) {
      buffers.putUint8List(plane.bytes);
    });
    return buffers.done().buffer.asUint8List();
  }

  Widget _getSticker(imgName) {
    return InkWell(
      onTap: () {
        setState(() {
          _imagePath = imgName;
          _stickerVisible = false;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 12 * rpx, top: 10 * rpx),
        padding: EdgeInsets.only(top: 10),
        width: 170 * rpx,
        height: 200 * rpx,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //color: Theme.of(context).primaryColor.withOpacity(0.6),
        ),
        child: Image.asset("assets/poser_img/${imgName}/${imgName}-0-0-0.png"),
      ),
    );
  }

  Widget _getStickerList(List<String> stickerList, int rowSize) {
    List<Widget> rowColList = new List<Widget>();
    int colSize = (stickerList.length / rowSize).ceil();
    int idx = 0;
    for (var i = 0; i < colSize; i++) {
      int widgetSize = min(stickerList.length - idx, rowSize);
      rowColList.add(Row(
        children: List.generate(widgetSize, (index) {
          return _getSticker(stickerList[idx++]);
        }),
      ));
    }

    return Column(children: rowColList);
  }

  /* 相机配置按钮组件 */
  Widget _getCameraIcon(IconData iconData, txt, Color color) {
    Widget btn = Column(
      children: [
        Container(
          width: 100 * rpx,
          height: 50 * rpx,
          child: Icon(iconData, color: color),
        ),
        Text(txt, style: TextStyle(fontSize: 8, color: color)),
      ],
    );
    return btn;
  }

  /* 底部相机控制按钮 */
  Widget _getCameraCtrlBtn(icon, color, size, width, height) {
    return Visibility(
      // visible: _ctrlBtnVisible,
      child: Container(
        // color: Colors.yellow,
        width: width * rpx,
        height: height * rpx,
        child: Icon(icon, size: size, color: color),
      ),
    );
  }

  /* 脸部绘制 */
  Widget _facePainterBox() {
    return SafeArea(
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: SizedBox(
            width: size.width,
            height: size.height, //* _camera.value.aspectRatio,
            child: (faces != null)
                ? CustomPaint(
                    painter: FacePainter(
                        faces, _camera.value.previewSize, size, cmIdx),
                  )
                : Center(
                    child: Container(
                        // color: Colors.black.withOpacity(0.2),
                        ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}

/*
* 波浪线特效
* 横向：y=sin(x) cos(x)
* 纵向：x=sin(y)
* (0,0) y轴附近 -1，1
* a=>波浪的振幅，pi，1000pixel，每200pixel出现一次波峰
* x-pos(x) = a * sin(y-pos(y))
* sin(pi/2)=1, sin(f(200))=1, 200*x=pi/2, x=pi/400, f(x)=pi/400
* Canvas 渐变色的区域
* 1、画出sin图像
* matplotlib：1-100区间内画sin图像
* */
class RainbowPainter extends CustomPainter {
  RainbowPainter(this.faces, this.imgSize, this.origSize);

  final List<Face> faces;
  final Size imgSize; //图片大小
  final Size origSize; //屏幕大小
  // final List<Rect> rects;

  List<Offset> scalePointPosition(FaceContour contour) {
    double scale = origSize.width / imgSize.height;
    List<Offset> newContour = List<Offset>();
    for (var i = 0; i < contour.positionsList.length; i++) {
      Offset curPoint = contour.positionsList[i];
      newContour.add(Offset(curPoint.dx * scale, curPoint.dy * scale));
    }
    return newContour;
  }

  List<double> splitDouble(double begin, double end, int count) {
    List<double> result = List<double>();
    double each = (end - begin) / count;

    for (var i = 0; i < count; i++) {
      result.add(begin + each * i);
    }
    return result;
  }

  getEyeClosePos(FaceContour up, FaceContour down) {
    var closePos = down.positionsList[2].dy - up.positionsList[2].dy;
    return closePos;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 2
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;
    Path path = Path();

    for (var face in faces) {
      // var leftEyeUp = face.getContour(FaceContourType.leftEyebrowTop);
      // var leftEyeDown = face.getContour(FaceContourType.leftEyebrowBottom);
      // var closePos = getEyeClosePos(leftEyeUp, leftEyeDown);

      print("detect faces left ");
      List<Offset> upperBottom =
          face.getContour(FaceContourType.upperLipBottom).positionsList;

      List<Offset> bottomUpper =
          face.getContour(FaceContourType.lowerLipTop).positionsList;

      double leftX = upperBottom.first.dx;
      double leftY = upperBottom.first.dy;

      double rightX = upperBottom.last.dx;
      double rightY = upperBottom.last.dy;

      double mounthWidth = rightX - leftX;

      int midPosition = (upperBottom.length / 2).floor();

      double mouthHeight =
          bottomUpper[midPosition].dy - upperBottom[midPosition].dy;

      double scale = origSize.width / imgSize.height;

      if (mouthHeight >= 0) {
        // mounthWidth / 2

        path = path..moveTo(leftX * scale, leftY * scale);

        double waves = 5.0;
        double imageHeight = imgSize.width;
        //左嘴角的y值->图片底部
        List<double> ys = splitDouble(leftY, imageHeight, 2000);
        List<double> xs = List<double>();

        ys.forEach((y) {
          double curX = leftX +
              (1 / 4 * mounthWidth) *
                  sin((y - leftY) * pi / ((imageHeight - leftY) / waves));
          xs.add(curX);
          path = path..lineTo(curX * scale, y * scale);
        });
        path = path..lineTo(xs.last * scale, (ys.last + mounthWidth) * scale);
        xs = xs.reversed.toList();
        ys = ys.reversed.toList();
        for (var i = 0; i < xs.length; i++) {
          path..lineTo(xs[i] * scale, ys[i] * scale);
        }
        path.lineTo(leftX * scale, leftY * scale);
        // canvas.drawPath(path, paint);

        canvas.drawPoints(
            PointMode.points,
            scalePointPosition(face.getContour(FaceContourType.allPoints)),
            paint);
      }

      /*  canvas.drawPoints(
          PointMode.points,
          scalePointPosition(face.getContour(FaceContourType.allPoints)),
          paint);*/
    }
  }

  @override
  bool shouldRepaint(RainbowPainter oldDelegate) =>
      oldDelegate.faces != faces; //&& faces.length > 0)

// @override
// bool shouldRebuildSemantics(RainbowPainter oldDelegate) => false;
}

class FacePainter extends CustomPainter {
  FacePainter(
    this.faces,
    this.imageSize,
    this.widgetSize,
    this.cmIdx,
  );

  final Size imageSize; //图片大小
  final Size widgetSize; //屏幕大小
  final List<Face> faces;
  final cmIdx;
  double strokeWidth = 2.0;

  Rect _scaleRect({
    @required Rect rect,
    @required Size imageSize,
    @required Size widgetSize,
  }) {
    final double scaleX = widgetSize.width / imageSize.width;
    final double scaleY = widgetSize.height / imageSize.height;

    if (cmIdx == 1) {
      print("qui");
      return Rect.fromLTRB(
        widgetSize.width - rect.left.toDouble() * scaleX,
        rect.top.toDouble() * scaleY,
        widgetSize.width - rect.right.toDouble() * scaleX,
        rect.bottom.toDouble() * scaleY,
      );
    }

    return Rect.fromLTRB(
      rect.left.toDouble() * scaleX,
      rect.top.toDouble() * scaleY,
      rect.right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.red;

    for (var i = 0; i < faces.length; i++) {
      // print("face detect!!!!!!!!!");
      final rect = _scaleRect(
        rect: faces[i].boundingBox,
        imageSize: imageSize,
        widgetSize: widgetSize,
      );

      final List<Offset> facePoints =
          faces[i].getContour(FaceContourType.face).positionsList;
      final List<Offset> lowerLipBottom =
          faces[i].getContour(FaceContourType.lowerLipBottom).positionsList;
      final List<Offset> lowerLipTop =
          faces[i].getContour(FaceContourType.lowerLipTop).positionsList;
      final List<Offset> upperLipBottom =
          faces[i].getContour(FaceContourType.upperLipBottom).positionsList;
      final List<Offset> upperLipTop =
          faces[i].getContour(FaceContourType.upperLipTop).positionsList;
      final List<Offset> leftEyebrowBottom =
          faces[i].getContour(FaceContourType.leftEyebrowBottom).positionsList;
      final List<Offset> leftEyebrowTop =
          faces[i].getContour(FaceContourType.leftEyebrowTop).positionsList;
      final List<Offset> rightEyebrowBottom =
          faces[i].getContour(FaceContourType.rightEyebrowBottom).positionsList;
      final List<Offset> rightEyebrowTop =
          faces[i].getContour(FaceContourType.rightEyebrowTop).positionsList;
      final List<Offset> leftEye =
          faces[i].getContour(FaceContourType.leftEye).positionsList;
      final List<Offset> rightEye =
          faces[i].getContour(FaceContourType.rightEye).positionsList;
      final List<Offset> noseBottom =
          faces[i].getContour(FaceContourType.noseBottom).positionsList;
      final List<Offset> noseBridge =
          faces[i].getContour(FaceContourType.noseBridge).positionsList;

      final lipPaint = Paint()
        ..strokeWidth = strokeWidth
        ..color = Colors.pink;

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: lowerLipBottom,
              imageSize: imageSize,
              widgetSize: widgetSize),
          lipPaint);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: lowerLipTop, imageSize: imageSize, widgetSize: size),
          lipPaint);

      List<Offset> ub = List<Offset>();
      ub.add(upperLipBottom[4]);
      ub.add(lowerLipTop[4]);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(offsets: ub, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.redAccent);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: upperLipBottom, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.green);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: upperLipTop, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.green);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: leftEyebrowBottom,
              imageSize: imageSize,
              widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.brown);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: leftEyebrowTop, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.brown);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: rightEyebrowBottom,
              imageSize: imageSize,
              widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.brown);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: rightEyebrowTop, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.brown);

      List<Offset> lup = List<Offset>();
      lup.add(leftEye[3]);
      lup.add(leftEye[13]);

      List<Offset> rup = List<Offset>();
      rup.add(leftEye[4]);
      rup.add(leftEye[12]);

      List<Offset> rrup = List<Offset>();
      rrup.add(leftEye[5]);
      rrup.add(leftEye[11]);

      List<Offset> hup = List<Offset>();
      hup.add(leftEye[0]);
      hup.add(leftEye[8]);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(offsets: lup, imageSize: imageSize, widgetSize: size),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = Colors.blue);
      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(offsets: rup, imageSize: imageSize, widgetSize: size),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = Colors.greenAccent);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(offsets: rrup, imageSize: imageSize, widgetSize: size),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..color = Colors.yellowAccent);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(offsets: hup, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.pinkAccent);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: rightEye, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.blue);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: noseBottom, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.greenAccent);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: noseBridge, imageSize: imageSize, widgetSize: size),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.greenAccent);

      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: facePoints,
              imageSize: imageSize,
              widgetSize: widgetSize),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.white);

      /*List<Offset> fa=new List<Offset>();
      fa.add(facePoints[0]);
      fa.add(facePoints[18]);
      canvas.drawPoints(
          PointMode.polygon,
          _scalePoints(
              offsets: fa,
              imageSize: imageSize,
              widgetSize: widgetSize),
          Paint()
            ..strokeWidth = strokeWidth
            ..color = Colors.pinkAccent);*/

      // canvas.drawRect(scaleRect(size, rect), paint);
    }
  }

  Offset _scalePoint({
    Offset offset,
    @required Size imageSize,
    @required Size widgetSize,
  }) {
    final double scaleX = widgetSize.width / imageSize.width;
    final double scaleY = widgetSize.height / imageSize.height;

    // if(cameraLensDirection == CameraLensDirection.front){
    //   return Offset(widgetSize.width - (offset.dx * scaleX), offset.dy * scaleY);
    // }
    return Offset(offset.dx * scaleX, offset.dy * scaleY);
  }

  List<Offset> _scalePoints({
    List<Offset> offsets,
    @required Size imageSize,
    @required Size widgetSize,
  }) {
    final double scaleX = widgetSize.width / imageSize.height;
    final double scaleY = scaleX; //widgetSize.height / imageSize.height;

    if (cmIdx == 1) {
      return offsets
          .map((offset) => Offset(
              widgetSize.width - (offset.dx * scaleX), offset.dy * scaleY))
          .toList();
    }
    return offsets.map((offset) {
      var xs = offset.dx * scaleX;
      var ys = offset.dy * scaleY;
      return Offset(xs, ys);
    }).toList();
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return imageSize != oldDelegate.imageSize || faces != oldDelegate.faces;
  }
}
