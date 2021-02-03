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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: MainWidget(rpx:MediaQuery.of(context).size.width/750),

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
