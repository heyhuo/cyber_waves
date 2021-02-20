import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cyber_waves/providers/UploadPostItemProvider.dart';
import 'package:cyber_waves/providers/WrapPicListProvider.dart';
import 'package:cyber_waves/wigets/CloseBtn.dart';
import 'package:cyber_waves/wigets/WrapPicList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class VideoUploadPage extends StatefulWidget {
  const VideoUploadPage({Key key}) : super(key: key);

  @override
  _VideoUploadPageState createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘
      body: VideoUpload(
        rpx: MediaQuery.of(context).size.width / 750,
      ),
      // bottomSheet: ,
    );
  }
}

class VideoUpload extends StatefulWidget {
  const VideoUpload({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _VideoUploadState createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUpload> {
  double rpx;
  double screenHeight;
  var tagList = <Widget>[];
  var picList = List<String>();
  bool tagEditFlag;
  Uint8List selPic;
  EditContentProvider picProvider;
  WrapPicListProvider wrapProvider;
  ScrollController tagListscrollController = ScrollController();

  // Color screenPickerColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    picProvider = Provider.of<EditContentProvider>(context);
    wrapProvider = Provider.of<WrapPicListProvider>(context);
    tagList = picProvider.tagList;
    tagEditFlag = picProvider.tagTextField;
    screenHeight = MediaQuery.of(context).size.height;
    picList = picProvider.picList;
    selPic = wrapProvider.selPic;

    return Stack(
      children: [
        /*背景图*/
        Container(
          height: screenHeight, //MediaQuery.of(context).size.height,
          child: selPic == null
              ? Text("")
              : Image.memory(
                  selPic,
                  fit: BoxFit.fitHeight,
                ),
        ),
        /*编辑*/
        Container(
          height: screenHeight, //MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.7),
          child: Column(
            children: [
              /*标题栏*/
              Container(
                height: 160 * rpx,
                // color: Colors.black.withOpacity(0.5),
                // margin: EdgeInsets.only(top: 30),
                child: Container(
                  margin: EdgeInsets.only(top: 45 * rpx),
                  child: ListTile(
                    title: Center(
                        child: Text(
                      "",
                      style: TextStyle(color: Colors.white),
                    )),
                    leading: Container(
                      width: 200 * rpx,
                      height: 70 * rpx,
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            // color: Colors.yellow,
                            width: 60 * rpx,
                            child: IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.grey.shade400),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          Container(
                            width: 140 * rpx,
                            // color: Colors.yellow,
                            child: Text(
                              "返回编辑",
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    trailing: Container(
                      width: 160 * rpx,
                      height: 74 * rpx,
                      decoration: BoxDecoration(
                          color: Colors.green.shade600.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 60 * rpx,
                            // height: 80*rpx,
                            // color: Colors.red,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_circle_up_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              picProvider.postData(wrapProvider.mulPicAssetList);
                            },
                            child: Container(
                                width: 80 * rpx,
                                // margin: EdgeInsets.only(left: 0),
                                // color: Colors.yellow,
                                child: Text(
                                  "发布",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              /*内容栏*/
              Container(
                width: 750 * rpx,
                // color: Colors.black.withOpacity(0.5),
                child: Column(
                  children: [
                    /*功能栏*/
                    Container(
                      width: 700 * rpx,
                      height: 100 * rpx,
                      // color: Colors.brown,
                      child: Row(
                        children: [
                          /*添加标签*/
                          _tagBtn(Color(0xffdb4d6d), Icons.tag, "标签", 120),
                          _tagBtn(Color(0xff0089a7), Icons.alternate_email,
                              "召唤好友", 170),
                          _tagBtn(Color(0xff6a4c9c), Icons.music_note_outlined,
                              "添加音乐", 170),
                          _tagBtn(Color(0xffe98b2a), Icons.place_outlined, "位置",
                              120),
                        ],
                      ),
                    ),
                    /*内容编辑*/
                    Container(
                      width: 700 * rpx,
                      padding: EdgeInsets.all(10 * rpx),
                      // color: Colors.brown,
                      child: ContentField(
                        tag: "content",
                        rpx: rpx,
                        hintText: "写下让人感同身受的文字吧~",
                        hintSize: 14.0,
                        hintColor: Colors.grey.shade600,
                        conSize: 14.0,
                        minLine: 4,
                        maxLine: 6,
                        maxLength: 256,
                      ),
                    ),
                    /*标签编辑栏*/
                    _tagEditor(),
                    /*好友栏*/
                    SingleChildScrollView(
                      child: Container(
                          width: 680 * rpx,
                          margin: EdgeInsets.only(top: 10 * rpx),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  _atUser(
                                      "assets/images/avatar1.jpeg", "张三阿紫哈"),
                                  _atUser(
                                      "assets/images/avatar2.jpeg", "你猜猜我是谁"),
                                  _atUser(
                                      "assets/images/furen.png", "富士山下的樱花⛰"),
                                  _atUser("assets/images/fushi.png", "骑着我的小摩托"),
                                ],
                              ),
                            ],
                          )),
                    ),
                    /*音乐栏*/
                    MusicCtn(
                      rpx: rpx,
                    ),
                  ],
                ),
              ),

              /*图片栏*/
              WrapPicList(wrapProvider, picProvider, rpx),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tagEditor() {
    return Visibility(
      visible: tagEditFlag,
      child: Container(
        width: 670 * rpx,
        height: 150 * rpx,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.0 * rpx)),
        child: Column(
          children: [
            Container(
              // decoration: BoxDecoration(border:),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "#",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 500 * rpx,
                    height: 70 * rpx,
                    // color: Colors.brown,
                    child: ContentField(
                      tag: "tag",
                      rpx: rpx,
                      hintText: "写下标签吧~",
                      hintColor: Colors.grey.shade400,
                      hintSize: 12.0,
                      conSize: 12.0,
                      minLine: 1,
                      maxLine: 1,
                      maxLength: 20,
                    ),
                  ),
                  Container(
                    width: 40 * rpx,
                    // color: Colors.black,
                    child: Icon(
                      Icons.color_lens_outlined,
                      color: picProvider.tagColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      picProvider.setTagField();
                    },
                    child: CloseBtn(
                      rpx: rpx,
                      radius: 20,
                      size: 25,
                      bgColor: Colors.black54,
                      iconColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            /*标签展示*/
            _tagList(tagList),
          ],
        ),
      ),
    );
  }

  Widget _tagList(tagList) {
    bool visible = tagList.length == 0 ? false : true;
    Widget tagScrollList = Container(
      height: 80 * rpx,
      width: 650 * rpx,
      padding: EdgeInsets.symmetric(horizontal: 5 * rpx),
      // color: Colors.yellow,
      child: visible
          ? SingleChildScrollView(
              controller: tagListscrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tagList,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.animation,
                  color: Colors.white30,
                  size: 28.0 * rpx,
                ),
                Text(
                  "  标签展示在这里，右滑查看更多→",
                  style: TextStyle(fontSize: 10.0, color: Colors.white30),
                )
              ],
            ),
    );
    if (visible && tagList.length > 1) {
      tagListscrollController.animateTo(
          tagListscrollController.position.maxScrollExtent + 100 * rpx,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate);
    }
    return tagScrollList;
  }

  Widget _tagBtn(color, icon, txt, width) {
    return GestureDetector(
      onTap: () {
        if ("标签" == txt) {
          picProvider.setTagField();
        } else if ("召唤好友" == txt) {
          picProvider.setFriendsField();
        } else if ("添加音乐" == txt) {
          picProvider.setMusicField();
        }
      },
      child: Container(
        width: width * rpx,
        height: 50 * rpx,
        padding: EdgeInsets.only(left: 2.0, right: 5.0),
        margin: EdgeInsets.only(right: 10 * rpx),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: color.withOpacity(0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20.0,
            ),
            Text(
              txt,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }



  _picCtn(imgPath) {
    return Hero(
      tag: imgPath,
      child: Container(
        width: 230 * rpx,
        height: 250 * rpx,
        // color: Colors.yellow,
        child: Stack(
          children: [
            /*图片*/
            Container(
              width: 210 * rpx,
              height: 210 * rpx,
              // color: Colors.white,
              margin: EdgeInsets.only(left: 10 * rpx, top: 20 * rpx),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10 * rpx),
                image: DecorationImage(
                    image: AssetImage(imgPath), scale: 0.1, fit: BoxFit.fill),
              ),
              // child: Image.asset(imgPath),
            ),
            /*清除*/
            Positioned(
                top: 0,
                left: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.6),
                  radius: 20 * rpx,
                  child: Icon(
                    Icons.close,
                    size: 30 * rpx,
                    color: Colors.black.withOpacity(0.6),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _atUser(avatarPath, userName) {
    bool flag = picProvider.friendsField;
    return !flag
        ? Container()
        : Container(
            width: 160 * rpx,
            height: 120 * rpx,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5.0 * rpx)),

            // padding: EdgeInsets.symmetric(vertical: 2*rpx,horizontal: 2*rpx),
            margin: EdgeInsets.only(left: 10 * rpx),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*@ 头像 x*/
                Row(
                  children: [
                    /*@*/
                    Container(
                      width: 30 * rpx,
                      height: 30 * rpx,
                      margin: EdgeInsets.only(left: 6 * rpx),
                      // color: Colors.brown,
                      child: Text(
                        "@",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    /*头像*/
                    CircleAvatar(
                      backgroundImage: AssetImage(avatarPath),
                    ),
                    /*x*/
                    CloseBtn(
                        rpx: rpx,
                        radius: 15,
                        size: 20,
                        bgColor: Colors.black54,
                        iconColor: Colors.grey.shade600)
                  ],
                ),
                /*昵称*/
                Container(
                    width: 150 * rpx,
                    // color: Colors.yellow,
                    child: Text(
                      userName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ))
              ],
            ),
          );
  }
}

/*标签项*/
class TagItem extends StatelessWidget {
  const TagItem({Key key, this.rpx, this.tagName, this.tagColor, this.provider})
      : super(key: key);
  final double rpx;
  final String tagName;
  final Color tagColor;
  final EditContentProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50 * rpx,
      margin: EdgeInsets.only(right: 10 * rpx),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(3.0)),
      padding: EdgeInsets.symmetric(horizontal: 10 * rpx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
// color: Colors.yellow,
            child: Text(
              "#",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10 * rpx),
            // padding: EdgeInsets.only(top: 15*rpx),
            height: 35 * rpx,
            // width: 160 * rpx,
// color: Colors.yellow,
            child: Text(
              tagName,
              style: TextStyle(
                  color: tagColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          /*删除按钮*/
          GestureDetector(
            onTap: () {
              provider.removeTag(this);
            },
            child: CloseBtn(
                rpx: rpx,
                radius: 15,
                size: 20,
                bgColor: Colors.black.withOpacity(0.6),
                iconColor: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class ContentField extends StatefulWidget {
  const ContentField(
      {Key key,
      this.tag,
      this.rpx,
      this.hintText,
      this.hintSize,
      this.hintColor,
      this.conSize,
      this.minLine,
      this.maxLine,
      this.maxLength})
      : super(key: key);
  final double rpx;
  final double hintSize;
  final double conSize;
  final String hintText;
  final String tag;
  final Color hintColor;
  final int minLine;
  final int maxLine;
  final int maxLength;

  @override
  _ContentFieldState createState() => _ContentFieldState();
}

class _ContentFieldState extends State<ContentField> {
// 输入框的焦点实例
  FocusNode _focusNode;

  var _keyword;

// 当前键盘是否是激活状态
  bool isKeyboardActived = false;
  var controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditContentProvider provider = Provider.of<EditContentProvider>(context);
    controller = TextEditingController.fromValue(TextEditingValue(
        text: '${(this._keyword == null) ? "" : this._keyword}', //判断keyword是否为空
        // 保持光标在最后
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: '${this._keyword}'.length))));
    // 输入框的焦点实例
    FocusNode _focusNode;
    Widget txtField = TextField(
      keyboardType: TextInputType.text,
      // autofocus: true,
      // controller: controller,
      controller: controller,
      minLines: widget.minLine,
      maxLines: widget.maxLine,
      // maxLength ==0: maxLength,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.grey.shade600),
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle:
              TextStyle(color: widget.hintColor, fontSize: widget.hintSize)),
      style: TextStyle(
        color: Colors.white,
        // fontStyle: FontStyle.italic,
        letterSpacing: 4 * widget.rpx,
        fontSize: widget.conSize,
        height: 2.5 * widget.rpx,
      ),
      onChanged: (value) {
        this._keyword = value;
        if ("content" == widget.tag) {
          provider.setContent(this._keyword);
          print(provider.content);
        }
      },
      onEditingComplete: () {
        if ("tag" == widget.tag) {
          provider.addTag(TagItem(
            rpx: widget.rpx,
            tagName: this._keyword,
            tagColor: Color(0xff78C2C4),
            provider: provider,
          ));
          this._keyword == "";
        } else if ("content" == widget.tag) {
          // controller.se();
          provider.setContent(this._keyword);
        }
        print(this._keyword);
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      focusNode: _focusNode,
      // textInputAction: TextInputAction.next,
    );

    return txtField;
  }
}

class MusicCtn extends StatelessWidget {
  const MusicCtn({Key key, this.rpx}) : super(key: key);
  final double rpx;

  @override
  Widget build(BuildContext context) {
    EditContentProvider provider = Provider.of<EditContentProvider>(context);
    bool flag = provider.musicField;
    return !flag
        ? Container()
        : Container(
            width: 650 * rpx,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11 * rpx),
                border:
                    Border.all(width: 1, color: Colors.white.withOpacity(0.3))),
            margin: EdgeInsets.only(top: 10 * rpx),
            child: Row(
              children: [
                /*封面*/
                Container(
                  height: 100 * rpx,
                  width: 100 * rpx,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 * rpx),
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg1.jpg"))),
                  child: Stack(
                    children: [
// Image.asset("assets/images/bg1.jpg"),
                      Container(
                        color: Colors.black.withOpacity(0.2),
                        child: Center(
                            child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        )),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
