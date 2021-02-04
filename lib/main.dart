import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cyber_waves/pages/SelectUploadModePage.dart';
import 'package:cyber_waves/providers/UploadBtnProvider.dart';
import 'package:cyber_waves/wigets/BottomBar.dart';
import 'package:cyber_waves/wigets/MainWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
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
        primaryColorLight: Color(0xff78C2C4),
        primaryColor: Color(0xff3d6263),
      ),
      home: MyHomePage(),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var name = "assets/images/waifu_03_256.png";

  // var listName = "assets/poser_img/waifu-0..png";
  var list = new List<String>();
  double rpx;
  bool uploadBtnVisible = false;

  // final GlobalKey<_AnimationWidgetState> _key =
  // new GlobalKey<_AnimationWidgetState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   backgroundColor: Theme.of(context).primaryColorLight,
      // ),
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context) => UploadBtnProvider(false))
          ],
          child: Stack(
            children: [
              /*抬头tab*/
              Positioned(
                  child: Container(
                height: 100 * rpx,
                width: 750 * rpx,
                color: Colors.black.withOpacity(0.5),
              )),
              /*滚动列表*/
              Positioned(
                  child: Container(
                margin: EdgeInsets.only(top: 100 * rpx),
                width: 750 * rpx,
                height: MediaQuery.of(context).size.height,
                child: MainWidget(rpx: rpx),
              )),
              /*底部*/
              Positioned(
                bottom: 0,
                child: BtmBar(
                  rpx: rpx,
                  selectIndex: 0,
                ),
              ),
              // /*上传按钮选项遮罩*/
              SelectUploadPage(rpx: rpx)
            ],
          )),

      // bottomNavigationBar: BottomAppBar(
      //   notchMargin: 1,
      //   color: Theme.of(context).primaryColorLight,
      //   child: Container(
      //     // padding: EdgeInsets.only(top: 10),
      //     height: 50,
      //     decoration: BoxDecoration(
      //       color: Theme.of(context).primaryColorLight,
      //     ),
      //     child: BtmBar(
      //       selectIndex: 0,
      //     ),
      //   ),
      // ),
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

// // Copyright 2019 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.
//
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
//
// import 'package:cyber_waves/wigets/a.dart';
//
// void main() {
//   runApp(
//     MaterialApp(
//       theme: ThemeData.from(
//         colorScheme: const ColorScheme.light(),
//       ).copyWith(
//         pageTransitionsTheme: const PageTransitionsTheme(
//           builders: <TargetPlatform, PageTransitionsBuilder>{
//             TargetPlatform.android: ZoomPageTransitionsBuilder(),
//           },
//         ),
//       ),
//       home: _TransitionsHomePage(),
//     ),
//   );
// }
//
// class _TransitionsHomePage extends StatefulWidget {
//   @override
//   _TransitionsHomePageState createState() => _TransitionsHomePageState();
// }
//
// class _TransitionsHomePageState extends State<_TransitionsHomePage> {
//   bool _slowAnimations = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Material Transitions')),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView(
//               children: <Widget>[
//                 _TransitionListTile(
//                   title: 'Container transform',
//                   subtitle: 'OpenContainer',
//                   onTap: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute<void>(
//                         builder: (BuildContext context) {
//                           return OpenContainerTransformDemo();
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           const Divider(height: 0.0),
//           SafeArea(
//             child: SwitchListTile(
//               value: _slowAnimations,
//               onChanged: (bool value) async {
//                 setState(() {
//                   _slowAnimations = value;
//                 });
//                 // Wait until the Switch is done animating before actually slowing
//                 // down time.
//                 if (_slowAnimations) {
//                   await Future<void>.delayed(const Duration(milliseconds: 300));
//                 }
//                 timeDilation = _slowAnimations ? 20.0 : 1.0;
//               },
//               title: const Text('Slow animations'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TransitionListTile extends StatelessWidget {
//   const _TransitionListTile({
//     this.onTap,
//     @required this.title,
//     @required this.subtitle,
//   });
//
//   final GestureTapCallback onTap;
//   final String title;
//   final String subtitle;
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: 15.0,
//       ),
//       leading: Container(
//         width: 40.0,
//         height: 40.0,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20.0),
//           border: Border.all(
//             color: Colors.black54,
//           ),
//         ),
//         child: const Icon(
//           Icons.play_arrow,
//           size: 35,
//         ),
//       ),
//       onTap: onTap,
//       title: Text(title),
//       subtitle: Text(subtitle),
//     );
//   }
// }
