import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'CloseBtn.dart';

class WrapPicList extends StatefulWidget {
  const WrapPicList(this.provider,
      {Key key, @required this.rpx, this.maxSize = 9, this.preview})
      : super(key: key);
  final double rpx;
  final int maxSize;
  final provider;
  final preview;

  @override
  _WrapPicListState createState() => _WrapPicListState();
}

class _WrapPicListState extends State<WrapPicList> {
  double rpx;
  List picList;
  var provider;
  int maxSize;
  bool preview;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
    maxSize = widget.maxSize;
    provider = widget.provider;
    preview = widget.preview;
  }

  /*Future getPicList() async {
    picList = await provider.findImage("heyhuo", "");
  }*/

  @override
  Widget build(BuildContext context) {
    picList = provider.picList;
    return Container(
      margin: EdgeInsets.only(top: 10 * rpx),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5 * rpx, //主轴上子控件的间距
        runSpacing: 2 * rpx, //交叉轴上子控件之间的间距
        children: _pictures(), //要显示的子控件集合
      ),
    );
  }

  Future<void> _loadAssets() async {
    List<Asset> mulPicAssetList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      mulPicAssetList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
        selectedAssets: provider.mulPicAssetList,
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
    provider.multiImagePicker(mulPicAssetList);
  }

  Widget addItem() {
    return /*添加图片*/
        Container(
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
    );
  }

  List<Widget> _pictures() {
    /*这里要延时加载  否则会抱The widget on which setState() or markNeedsBuild() was called was:错误*/
    /* Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        getPicList();
    });}*/

    if (picList == null) return [addItem()];

    var len = min(this.picList.length + 1, maxSize);
    // if (preview) picList = widget.provider.picList;

    return List.generate(len, (index) {
      if (this.picList.length < maxSize && index == len - 1) {
        return addItem(); /*添加图片*/
      } else {
        return PicItem(provider, rpx: rpx, index: index, preview: preview);
      }
    });
  }
}

class PicItem extends StatelessWidget {
  const PicItem(this.provider,
      {Key key, this.rpx, this.index, this.preview = true})
      : super(key: key);
  final double rpx;
  final int index;
  final provider;
  final bool preview;

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
                /*查看预览图*/
                if (preview) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              PicViewPage(path: picList[index], tag: index),
                          fullscreenDialog: true));
                }
                /*查看生成动画*/
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
                    image: DecorationImage(image: FileImage(File(picList[index].animePath))),
                  ),
                ),
              ),
            ),
            /*关闭按钮*/
            Positioned(
              top: 0 * rpx,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  provider.removePic(index,picList[index].animeId,picList[index].animePath);
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
            /*生成按钮*/
            Visibility(
              visible: picList[index].generateTag==0?false:true,
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
                    padding: EdgeInsets.only(bottom: 10 * rpx, right: 10 * rpx),
                    child: Icon(Icons.animation,color: Colors.white.withOpacity(0.8),)
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

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
