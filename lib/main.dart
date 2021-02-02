// // import 'package:flutter/material.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         // This is the theme of your application.
// //         //
// //         // Try running your application with "flutter run". You'll see the
// //         // application has a blue toolbar. Then, without quitting the app, try
// //         // changing the primarySwatch below to Colors.green and then invoke
// //         // "hot reload" (press "r" in the console where you ran "flutter run",
// //         // or simply save your changes to "hot reload" in a Flutter IDE).
// //         // Notice that the counter didn't reset back to zero; the application
// //         // is not restarted.
// //         primarySwatch: Colors.blue,
// //         // This makes the visual density adapt to the platform that you run
// //         // the app on. For desktop platforms, the controls will be smaller and
// //         // closer together (more dense) than on mobile platforms.
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: MyHomePage(title: 'Flutter Demo Home Page'),
// //     );
// //   }
// // }
// //
// // class MyHomePage extends StatefulWidget {
// //   MyHomePage({Key key, this.title}) : super(key: key);
// //
// //   // This widget is the home page of your application. It is stateful, meaning
// //   // that it has a State object (defined below) that contains fields that affect
// //   // how it looks.
// //
// //   // This class is the configuration for the state. It holds the values (in this
// //   // case the title) provided by the parent (in this case the App widget) and
// //   // used by the build method of the State. Fields in a Widget subclass are
// //   // always marked "final".
// //
// //   final String title;
// //
// //   @override
// //   _MyHomePageState createState() => _MyHomePageState();
// // }
// //
// // class _MyHomePageState extends State<MyHomePage> {
// //   int _counter = 0;
// //
// //   void _incrementCounter() {
// //     setState(() {
// //       // This call to setState tells the Flutter framework that something has
// //       // changed in this State, which causes it to rerun the build method below
// //       // so that the display can reflect the updated values. If we changed
// //       // _counter without calling setState(), then the build method would not be
// //       // called again, and so nothing would appear to happen.
// //       _counter++;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // This method is rerun every time setState is called, for instance as done
// //     // by the _incrementCounter method above.
// //     //
// //     // The Flutter framework has been optimized to make rerunning build methods
// //     // fast, so that you can just rebuild anything that needs updating rather
// //     // than having to individually change instances of widgets.
// //     return Scaffold(
// //       appBar: AppBar(
// //         // Here we take the value from the MyHomePage object that was created by
// //         // the App.build method, and use it to set our appbar title.
// //         title: Text(widget.title),
// //       ),
// //       body: Center(
// //         // Center is a layout widget. It takes a single child and positions it
// //         // in the middle of the parent.
// //         child: Column(
// //           // Column is also a layout widget. It takes a list of children and
// //           // arranges them vertically. By default, it sizes itself to fit its
// //           // children horizontally, and tries to be as tall as its parent.
// //           //
// //           // Invoke "debug painting" (press "p" in the console, choose the
// //           // "Toggle Debug Paint" action from the Flutter Inspector in Android
// //           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
// //           // to see the wireframe for each widget.
// //           //
// //           // Column has various properties to control how it sizes itself and
// //           // how it positions its children. Here we use mainAxisAlignment to
// //           // center the children vertically; the main axis here is the vertical
// //           // axis because Columns are vertical (the cross axis would be
// //           // horizontal).
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text(
// //               'You have pushed the button this many times:',
// //             ),
// //             Text(
// //               '$_counter',
// //               style: Theme.of(context).textTheme.headline4,
// //             ),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _incrementCounter,
// //         tooltip: 'Increment',
// //         child: Icon(Icons.add),
// //       ), // This trailing comma makes auto-formatting nicer for build methods.
// //     );
// //   }
// // }
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file/open_file.dart';
// import 'package:quiver/async.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool recording = false;
//   int _time = 0;
//
//   requestPermissions() async {
//     await PermissionHandler().requestPermissions([
//       PermissionGroup.storage,
//       PermissionGroup.photos,
//       PermissionGroup.microphone,
//     ]);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//     startTimer();
//   }
//
//   void startTimer() {
//     CountdownTimer countDownTimer = new CountdownTimer(
//       new Duration(seconds: 1000),
//       new Duration(seconds: 1),
//     );
//
//     var sub = countDownTimer.listen(null);
//     sub.onData((duration) {
//       setState(() => _time++);
//     });
//
//     sub.onDone(() {
//       print("Done");
//       sub.cancel();
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter Screen Recording'),
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Time: $_time\n'),
//             !recording
//                 ? Center(
//               child: RaisedButton(
//                 child: Text("Record Screen"),
//                 onPressed: () => startScreenRecord(false),
//               ),
//             )
//                 : Container(),
//             !recording
//                 ? Center(
//               child: RaisedButton(
//                 child: Text("Record Screen & audio"),
//                 onPressed: () => startScreenRecord(true),
//               ),
//             )
//                 : Center(
//               child: RaisedButton(
//                 child: Text("Stop Record"),
//                 onPressed: () => stopScreenRecord(),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   startScreenRecord(bool audio) async {
//     bool start = false;
//     await Future.delayed(const Duration(milliseconds: 1000));
//
//     if (audio) {
//       start = await FlutterScreenRecording.startRecordScreenAndAudio("Title" + _time.toString(),  titleNotification:"dsffad", messageNotification: "sdffd");
//     } else {
//       start = await FlutterScreenRecording.startRecordScreen("Title", titleNotification:"dsffad", messageNotification: "sdffd");
//     }
//
//     if (start) {
//       setState(() => recording = !recording);
//     }
//
//     return start;
//   }
//
//   stopScreenRecord() async {
//     String path = await FlutterScreenRecording.stopRecordScreen;
//     setState(() {
//       recording = !recording;
//     });
//     print("Opening video");
//     print(path);
//     OpenFile.open(path);
//   }
// }


import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cyber_waves/wigets/BottomBar.dart';
import 'package:cyber_waves/wigets/MainWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  prefs.setBool("ifIOS", Platform.isIOS);
  prefs.setBool("ifPrd", false);
  prefs.setBool("ifReal_d", false);

  prefs.setString("urlPath_real_d", "10.2.12.154");
  prefs.setString("scheme_real_d", "http");
  prefs.setInt("ports_real_d", 8088);

  prefs.setString("urlPath_ios_d", "127.0.0.1");
  prefs.setString("scheme_ios_d", "http");
  prefs.setInt("ports_ios_d", 5000);

  prefs.setString("urlPath_and_d", "10.0.2.2"); //10.0.2.2
  prefs.setString("scheme_and_d", "http");
  prefs.setInt("ports_and_d", 8088);

  prefs.setString("urlPath_p", "118.26.177.76");
  prefs.setString("scheme_p", "http");
  prefs.setInt("ports_p", 80);

  prefs.setString("picsServer", "www.heyhuo.com");

  //_loadModel(false);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primaryColorDark: Color(0xff566C73),  //綪御纳户
        primaryColorDark: Color(0xffffffff), //綪御纳户566C73
        primaryColorLight: Color(0xff78C2C4).withOpacity(0.3),
        primaryColor: Color(0xff3d6263),
      ),
      home: MyHomePage(title: 'Cyber Wave 🌊'),
    );
  }
}

// Future _loadModel(useGpu) async {
//   // 模型文件的名称
//   final _modelFile = 'morpher_gpu_32.tflite';
//
//   // final gpuDelegateV2 = GpuDelegateV2(
//   //     options: GpuDelegateOptionsV2(
//   //   false,
//   //   TfLiteGpuInferenceUsage.preferenceSustainSpeed,
//   //   TfLiteGpuInferencePriority.minLatency,
//   //   TfLiteGpuInferencePriority.auto,
//   //   TfLiteGpuInferencePriority.auto,
//   // ));
//
//   Interpreter _interpreter;
//   if (useGpu) {
//     // var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegateV2);
//     // var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
//
//     // TensorFlow Lite 解释器对象
//     // _interpreter =
//     // await Interpreter.fromAsset(_modelFile, options: interpreterOptions);
//   } else {
//     var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
//     _interpreter = await Interpreter.fromAsset(_modelFile,
//         options: InterpreterOptions()..threads = 3);
//   }
//
//   print('Interpreter loaded successfully');
//
//   // 加载张量
//   _interpreter.allocateTensors();
//   // 打印 input tensor 列表
//   print(_interpreter.getInputTensors());
//   // 打印 output tensor 列表
//   print(_interpreter.getOutputTensors());
//
//   var name = "assets/images/waifu_03_256.png";
//   var imageBytes = (await rootBundle.load(name)).buffer.asUint8List();
//   img.Image image = img.decodePng(imageBytes);
//
//   print(image.length);
//   var imgBytes = imageToByte(image, 256).reshape([1, 4, 256, 256]);
//   var morParam = [
//     [0.5, 0.5, 0.5]
//   ];
//
//   // input: List<Object>
//   var inputs = [imgBytes, morParam];
//
//   var output0 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
//   var output1 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
//   // output: Map<int, Object>
//   var outputs = {0: output0, 1: output1};
//
//   for (var i = 0; i < 10; i++) {
//     int startTime = new DateTime.now().millisecondsSinceEpoch;
//     // inference
//     _interpreter.runForMultipleInputs(inputs, outputs);
//     int endTime = new DateTime.now().millisecondsSinceEpoch;
//     print("Inference took ${endTime - startTime}");
//     // print outputs
//     print(outputs);
//   }
//
//   // print(imageBytes);
// }

Float32List imageToByte(img.Image image, int inputSize) {
  var float32list = Float32List(inputSize * inputSize * 4);
  var buffer = Float32List.view(float32list.buffer);
  int pidx = 0;
  double mean = 0, std = 255.0;
  for (var i = 0; i < inputSize; i++) {
    for (var j = 0; j < inputSize; j++) {
      var pixel = image.getPixel(j, i);

      buffer[256 * i + j] = (img.getRed(pixel) - mean) / std;
      buffer[256 * i + j + 256] = (img.getGreen(pixel) - mean) / std;
      buffer[256 * i + j + 512] = (img.getBlue(pixel) - mean) / std;
      buffer[256 * i + j + 768] = (img.getAlpha(pixel) - mean) / std;
    }
  }

  var imgBytes = float32list.buffer.asFloat32List();
  print(imgBytes[25700]);
  return imgBytes;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var name = "assets/images/waifu_03_256.png";

  // var listName = "assets/poser_img/waifu-0..png";
  var list = new List<String>();

  // final GlobalKey<_AnimationWidgetState> _key =
  // new GlobalKey<_AnimationWidgetState>();

  @override
  Widget build(BuildContext context) {
    // for (var i = 0; i < 4; i++) {
    //   for (var j = 0; j < 4; j++) {
    //     for (var k = 0; k < 4; k++) {
    //       list.add(
    //           "assets/poser_img/sakura-0.${i * 3}-0.${j * 3}-0.${k * 3}.png");
    //       // list[i] = ;
    //     }
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: MainWidget(rpx:MediaQuery.of(context).size.width/750),
      // body: Column(
      //   children: [
      //     /*相机预览界面*/
      //     Container(
      //       width: 850,
      //       height: 734,
      //       color: Theme.of(context).primaryColorDark,
      //       child:MainWidget(rpx:MediaQuery.of(context).size.width/750),
      //     ),
      //   ],
      // ),

      /*Container(
        color: Theme.of(context).primaryColorDark,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              child: AnimationWidget(
                _key,
                list,
                width: 200,
                height: 200,
                interval: 150,
                start: true,
              ),
              //Image.asset(name),
              width: 256 * 2.5,
              height: 256,
            ),
            RaisedButton(
              onPressed: _getDecodeImg,
              child: Text("load"),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: //Temp(),
                  CameraMain(
                size:  MediaQuery.of(context).size,//Size(400.0,400.0),
                    */ /*context
                        ?.findRenderObject()
                        ?.paintBounds
                        ?.size,*/ /*
              ),
              */ /*FlareActor("assets/riv/Anime.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "buiteful_gril"),*/ /*
              width: 256 * 2.5,
              height: 430,
              decoration: BoxDecoration(
                color: Color(0xff1E88A8),
              ),
            ),
          ]),
        ),
      ),*/
      bottomNavigationBar: BottomAppBar(
        notchMargin: 1,
        color: Theme.of(context).primaryColorLight,
        child: Container(
          // padding: EdgeInsets.only(top: 10),
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
          ),
          child: BtmBar(
            selectIndex: 0,
          ),
        ),
      ),
      /*  floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /*图片空间*/
  Uint8List _bytes;
  Image _ss;

  Widget _ImgeView() {
    if (_bytes == null) {
      return Center(
        child: Text("图片加载中。。。"),
      );
    } else {
      return Image.memory(_bytes); //Image.memory(_bytes);
    }
  }

  _getDecodeImg() async {
    // File im = File(name);
    // img.Image.f
    var imageBytes = (await rootBundle.load(name)).buffer.asUint8List();
    // var bImage = img.Image.fromBytes(256, 256, imageBytes, format: img.Format.argb);

    img.Image image = img.decodePng(imageBytes);
    //
    print(image.length);
    var imgBytes = imageToByte(image, 256);

    setState(() {
      // setState_bytes = imgBytes;
      // _ss = bImage;
    });
  }

  Container _getCont(double _height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      width: 190,
      height: _height,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0,
        ),
      ], borderRadius: BorderRadius.circular(15.0), color: Colors.white),
    );
  }
}

// class AnimationWidget extends StatefulWidget {
//   final List<String> _assetList;
//   final double width;
//   final double height;
//   bool start = true;
//   int interval = 50;
//
//   AnimationWidget(Key key, this._assetList,
//       {this.width, this.height, this.interval, this.start})
//       : super(key: key);
//
//   @override
//   _AnimationWidgetState createState() => _AnimationWidgetState();
// }
//
// class _AnimationWidgetState extends State<AnimationWidget>
//     with SingleTickerProviderStateMixin<AnimationWidget> {
//   // 动画控制
//   AnimationController _controller;
//   Animation<double> _animation;
//   int i = 0;
//   int interval = 1000;
//
//   @override
//   // TODO: implement widget
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.interval != null) {
//       interval = widget.interval;
//     }
//     final int imageCount = widget._assetList.length;
//     final int maxTime = interval * imageCount;
//
//     // 动画管理类
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: maxTime),
//     );
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         // _controller.reverse();
//         // _controller.forward(from: 0.0); // 完成后重新开始
//       }
//     });
//     _animation = new Tween<double>(begin: 0, end: imageCount.toDouble())
//         .animate(_controller)
//       ..addListener(() {
//         setState(() {
//           // the state that has changed here is the animation object’s value
//         });
//       });
//     if (widget.start) {
//       _controller.forward();
//     }
//   }
//
//   void _update(AnimationStatus status) {
//     setState(() {
//       if (status == AnimationStatus.completed) {
//         _controller.forward(from: 0.0); // 完成后重新开始
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int ix = _animation.value.floor() % widget._assetList.length;
//
//     List<Widget> images = [];
//     // 把所有图片都加载进内容，否则每一帧加载时会卡顿
//     for (int i = 0; i < widget._assetList.length; ++i) {
//       if (i != ix) {
//         images.add(Image.asset(
//           widget._assetList[i],
//           width: 0,
//           height: 0,
//         ));
//       }
//     }
//
//     images.add(Image.asset(
//       widget._assetList[ix],
//       width: widget.width,
//       height: widget.height,
//     ));
//
//     return Stack(alignment: AlignmentDirectional.center, children: images);
//   }
// }

