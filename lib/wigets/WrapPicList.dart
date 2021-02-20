import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cyber_waves/providers/WrapPicListProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import 'CloseBtn.dart';

class WrapPicList extends StatefulWidget {
  const WrapPicList(this.wrapProvider, this.picProvider, this.rpx,
      {Key key, this.maxSize = 9})
      : super(key: key);
  final int maxSize;
  final wrapProvider;
  final rpx;
  final picProvider;

  @override
  _WrapPicListState createState() => _WrapPicListState();
}

class _WrapPicListState extends State<WrapPicList> {
  List mulPicAssetList;
  List picPathList;
  List picList;
  var wrapProvider;
  var picProvider;
  int maxSize;
  bool preview;
  double rpx;
  int selPicIdx;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maxSize = widget.maxSize;
    wrapProvider = widget.wrapProvider;
    picProvider = widget.picProvider;
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    // wrapProvider = Provider.of<WrapPicListProvider>(context);
    mulPicAssetList = wrapProvider.mulPicAssetList;
    selPicIdx = wrapProvider.selPicIdx;
    picPathList = wrapProvider.picPathList;
    picList = wrapProvider.picList;
    return Container(
      margin: EdgeInsets.only(top: 10 * rpx),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5 * rpx, //主轴上子控件的间距
        runSpacing: 2 * rpx, //交叉轴上子控件之间的间距
        children: _pictures()..add(addItem()), //要显示的子控件集合
      ),
    );
  }

  /*多图选择*/
  Future<void> _loadAssets() async {
    List<Asset> mulPicAssetList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      mulPicAssetList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
        selectedAssets: wrapProvider.mulPicAssetList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // 显示所有照片，值为 false 时显示相册
          startInAllView: true,
          actionBarColor: "#000000",
          actionBarTitle: "Example App",
          allViewTitle: "所有照片",
          useDetailsView: true,
          textOnNothingSelected: '没有选择照片',
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    wrapProvider.multiImagePicker(mulPicAssetList);
  }

  Widget addItem() {
    return /*添加图片*/
        Visibility(
          visible: maxSize==mulPicAssetList.length?false:true,
          child: Container(
      width: 200 * rpx,
      height: 200 * rpx,
      margin: EdgeInsets.only(top: 20 * rpx, left: 20 * rpx),
      decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.0 * rpx)),
      child: IconButton(
          onPressed: () {
            _loadAssets();
          },
          icon: Icon(Icons.add,
              size: 80 * rpx, color: Colors.white.withOpacity(0.5)),
      ),
    ),
        );
  }

  /*多图显示*/
  List<Widget> _pictures() {
    var list = List<Widget>();
    if (mulPicAssetList != null && mulPicAssetList.length > 0) {
      var len = this.mulPicAssetList.length;
      // var minLen = min(len, maxSize);
      list = List.generate(len, (index) {
        return _picItem(index);
      });
    }
    return list;
  }

  _picItem(index) {
    return Container(
        width: 220 * rpx,
        height: 220 * rpx,
        // padding: EdgeInsets.only(top: 20 * rpx, left: 20 * rpx),
        decoration: BoxDecoration(
            border: Border.all(
                style:
                    selPicIdx != index ? BorderStyle.none : BorderStyle.solid,
                width: 2,
                color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(20.0 * rpx)),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                wrapProvider.setPicIdx(index);
                // 查看预览图
                // if () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (_) =>
                //               PicViewPage(path: picList[index], tag: index),
                //           fullscreenDialog: true));
                // }
                // 查看生成动画
                // else {
                //   provider.setShowModel(picList[index]);
                //   // provider.readFile(picList[index].split('/')[2].split('.')[0]);
                // }
              },
              child: Hero(
                tag: index,
                child: Container(
                  margin: EdgeInsets.only(top: 20 * rpx, left: 20 * rpx),
                  width: 200 * rpx,
                  height: 200 * rpx,
                  decoration: BoxDecoration(
                    // color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20.0 * rpx),
                    // image: DecorationImage(
                    //     image:MemoryImage(picList[index])),//FileImage(File(picPathList[index])),fit: BoxFit.cover),//
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.yellow,
                      borderRadius: BorderRadius.circular(20.0 * rpx),),
                    child: AssetThumb(
                      asset: mulPicAssetList[index],
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
            ),
            // 关闭按钮
            Positioned(
              top: 0 * rpx,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  wrapProvider.removePic(index);
                },
                child: Container(
                  width: 60 * rpx,
                  height: 60 * rpx,
                  // color: Colors.red,
                  padding: EdgeInsets.only(bottom: 10 * rpx, right: 10 * rpx),
                  child: CloseBtn(
                    rpx: rpx,
                    radius: 20,
                    size: 30,
                    bgColor: Colors.white.withOpacity(0.6),
                    iconColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            // 生成按钮
            // Visibility(
            //   visible: picList[index].generateTag == 0 ? false : true,
            //   child: Positioned(
            //     top: 0,
            //     right: 0,
            //     child: GestureDetector(
            //       onTap: () {
            //         // provider.removePic(index,picList[index].animeId,picList[index].animePath);
            //       },
            //       child: Container(
            //           width: 60 * rpx,
            //           height: 60 * rpx,
            //           // color: Colors.red,
            //           padding:
            //               EdgeInsets.only(bottom: 10 * rpx, right: 10 * rpx),
            //           child: Icon(
            //             Icons.animation,
            //             color: Colors.white.withOpacity(0.8),
            //           )),
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}

/*class PicItem extends StatelessWidget {
  const PicItem(this.index,
      {Key key})
      : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    // EditContentProvider provider = Provider.of<EditContentProvider>(context);
    var picList = provider.picList;
    var selPicIdx = provider.selPicIdx;
    return Container(
        width: 220 * rpx,
        height: 220 * rpx,
        // padding: EdgeInsets.only(top: 20 * rpx, left: 20 * rpx),
        decoration: BoxDecoration(
            border: Border.all(
                style:
                    selPicIdx != index ? BorderStyle.none : BorderStyle.solid,
                width: 2,
                color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(20.0 * rpx)),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                provider.setSelPicIdx(index);
                 // 查看预览图
                if (preview) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              PicViewPage(path: picList[index], tag: index),
                          fullscreenDialog: true));
                }
                 // 查看生成动画
                else {
                  provider.setShowModel(picList[index]);
                  // provider.readFile(picList[index].split('/')[2].split('.')[0]);
                }
              },
              child: Hero(
                tag: index,
                child: Container(
                  margin: EdgeInsets.only(top: 20 * rpx, left: 20 * rpx),
                  width: 200 * rpx,
                  height: 200 * rpx,
                  decoration: BoxDecoration(
                    // color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20.0 * rpx),
                    image: DecorationImage(
                        image: FileImage(File(picList[index].animePath))),
                  ),
                ),
              ),
            ),
             // 关闭按钮
            Positioned(
              top: 0 * rpx,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  provider.removePic(
                      index, picList[index].animeId, picList[index].animePath);
                },
                child: Container(
                  width: 60 * rpx,
                  height: 60 * rpx,
                  // color: Colors.red,
                  padding: EdgeInsets.only(bottom: 10 * rpx, right: 10 * rpx),
                  child: CloseBtn(
                    rpx: rpx,
                    radius: 20,
                    size: 30,
                    bgColor: Colors.white.withOpacity(0.6),
                    iconColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
             // 生成按钮
            Visibility(
              visible: picList[index].generateTag == 0 ? false : true,
              child: Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // provider.removePic(index,picList[index].animeId,picList[index].animePath);
                  },
                  child: Container(
                      width: 60 * rpx,
                      height: 60 * rpx,
                      // color: Colors.red,
                      padding:
                          EdgeInsets.only(bottom: 10 * rpx, right: 10 * rpx),
                      child: Icon(
                        Icons.animation,
                        color: Colors.white.withOpacity(0.8),
                      )),
                ),
              ),
            ),
          ],
        ));
  }
}*/

class PicViewPage extends StatefulWidget {
  const PicViewPage({Key key, @required this.path, @required this.tag})
      : super(key: key);
  final String path;
  final tag;

  @override
  _PicViewPageState createState() => _PicViewPageState();
}

class _PicViewPageState extends State<PicViewPage> {
  @override
  Widget build(BuildContext context) {
    var rpx = MediaQuery.of(context).size.width / 750;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Hero(
        flightShuttleBuilder:
            (flightContext, animation, direction, fromContext, toContext) {
          return Image.asset(
            widget.path,
            fit: BoxFit.fitWidth,
          );
        },
        transitionOnUserGestures: true,
        tag: widget.tag,
        child: Container(
          width: 750 * rpx,
          // height: MediaQuery.of(context).size.height,
          // color: Colors.black,
          child: Image.asset(
            widget.path,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
