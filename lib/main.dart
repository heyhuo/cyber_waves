import 'dart:io';
import 'dart:typed_data';

import 'package:cyber_waves/pages/SelectUploadModePage.dart';
import 'package:cyber_waves/providers/MusicProvider.dart';
import 'package:cyber_waves/providers/PostItemProvider.dart';
import 'package:cyber_waves/providers/UploadBtnProvider.dart';
import 'package:cyber_waves/wigets/BottomBar.dart';
import 'package:cyber_waves/wigets/MainWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  var andIp="192.168.123.206";
  // var andIp="10.2.12.150";

  prefs.setBool("ifIOS", Platform.isIOS);
  prefs.setBool("ifPrd", false);
  prefs.setBool("ifReal_d", false);

  prefs.setString("urlPath_real_d", "10.2.12.154");
  prefs.setString("scheme_real_d", "http");
  prefs.setInt("ports_real_d", 8088);

  prefs.setString("urlPath_ios_d", "127.0.0.1");
  prefs.setString("scheme_ios_d", "http");
  prefs.setInt("ports_ios_d", 5000);

  prefs.setString("urlPath_and_d", andIp); //10.0.2.2
  prefs.setString("scheme_and_d", "http");
  prefs.setInt("ports_and_d", 8088);

  prefs.setString("urlPath_p", "118.26.177.76");
  prefs.setString("scheme_p", "http");
  prefs.setInt("ports_p", 80);

  prefs.setString("picsServer", "www.heyhuo.com");

  //_loadModel(false);

  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primaryColorDark: Color(0xff566C73),  //綪御纳户
        primaryColorDark: Color(0xff3d6263), //綪御纳户566C73
        primaryColorLight: Color(0xff78C2C4),
        primaryColor: Color(0xffffffff),

      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var list = new List<String>();
  double rpx;
  bool uploadBtnVisible = false;

  @override
  void initState() {
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
                create: (context) => UploadBtnProvider(false, "")),
            ChangeNotifierProvider(
                create: (context) => PostItemProvider()),
            ChangeNotifierProvider(
                create: (context) => MusicProvider())
          ],
          child: Stack(
            children: [
              /*抬头tab*/
              Positioned(
                  child: Container(
                height: 80 * rpx,
                width: 750 * rpx,
                color: Theme.of(context).primaryColorLight,
              )),
              /*滚动列表*/
              Positioned(
                  child: Container(
                    // color: Colors.black.w,
                margin: EdgeInsets.only(top: 80 * rpx),
                width: 750 * rpx,
                height: MediaQuery.of(context).size.height-180*rpx,
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
