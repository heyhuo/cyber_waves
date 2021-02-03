
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






