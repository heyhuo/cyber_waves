import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import 'package:cyber_waves/pages/SelectUploadModePage.dart';
import 'package:cyber_waves/providers/MusicProvider.dart';
import 'package:cyber_waves/providers/PostItemProvider.dart';
import 'package:cyber_waves/providers/UploadBtnProvider.dart';
import 'package:cyber_waves/wigets/BottomBar.dart';
import 'package:cyber_waves/wigets/MainWidget.dart';

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
