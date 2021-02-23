
import 'dart:typed_data';

import 'package:cyber_waves/models/MusicModel.dart';
import 'package:cyber_waves/providers/MusicProvider.dart';
import 'package:cyber_waves/providers/UploadPostItemProvider.dart';
import 'package:cyber_waves/providers/WrapPicListProvider.dart';
import 'package:cyber_waves/wigets/CloseBtn.dart';
import 'package:cyber_waves/wigets/WrapPicList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'HomeMainPage.dart';

// class UploadPage extends StatefulWidget {
//   const UploadPage({Key key}) : super(key: key);
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomPadding: false, //输入框抵住键盘
//       body: VideoUpload(
//         rpx: MediaQuery.of(context).size.width / 750,
//       ),
//       // bottomSheet: ,
//       // ),
//     );
//   }
// }

class UploadPage extends StatefulWidget {
  const UploadPage({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  double rpx;
  double screenHeight;
  var tagList = <Widget>[];
  var picList = List<String>();
  bool tagEditFlag;
  Uint8List selPic;
  UploadPostItemProvider picProvider;
  WrapPicListProvider wrapProvider;
  MusicProvider musicProvider;
  ScrollController tagListscrollController = ScrollController();
  GlobalKey<NavigatorState> _key = GlobalKey();

  // Color screenPickerColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    picProvider = Provider.of<UploadPostItemProvider>(context);
    wrapProvider = Provider.of<WrapPicListProvider>(context);
    musicProvider = Provider.of<MusicProvider>(context);
    tagList = picProvider.tagList;
    tagEditFlag = picProvider.tagTextField;
    screenHeight = MediaQuery.of(context).size.height;
    picList = picProvider.picList;
    selPic = wrapProvider.selPic;
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘
      body: Stack(
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
                                    _onBackPressed(); // Navigator.pop(context);
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
                      trailing: InkWell(
                        onTap: () {
                          picProvider.postData(wrapProvider.mulPicAssetList);
                          // Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeMainPage()));
                        },
                        child: Container(
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
                                child: Icon(
                                  Icons.arrow_circle_up_sharp,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
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
                            ],
                          ),
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
                            _tagBtn(Color(0xff6a4c9c),
                                Icons.music_note_outlined, "添加音乐", 170),
                            _tagBtn(Color(0xffe98b2a), Icons.place_outlined,
                                "位置", 120),
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
                                    _atUser(
                                        "assets/images/fushi.png", "骑着我的小摩托"),
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
      ),
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

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColorDark,
              title: Text(
                '要暂时保存数据吗?',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    '暂不',
                    style: TextStyle(color: Colors.white60),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  child: Text(
                    '确定',
                    style: TextStyle(color: Colors.white60),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
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
  final UploadPostItemProvider provider;

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
  var _tag, _rpx;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _tag = widget.tag;
    _rpx = widget.rpx;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UploadPostItemProvider itemProvider =
        Provider.of<UploadPostItemProvider>(context);
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
          itemProvider.setContent(this._keyword);
          print("content:${itemProvider.content}");
        } else if ("music" == widget.tag) {
          itemProvider.setMusicPath(this._keyword);
          print("music:${itemProvider.musicPath}");
        }
      },
      onEditingComplete: () {
        if ("tag" == _tag) {
          itemProvider.addTag(TagItem(
            rpx: _rpx,
            tagName: this._keyword,
            tagColor: Color(0xff78C2C4),
            provider: itemProvider,
          ));
          this._keyword == "";
        } else if ("content" == _tag) {
          itemProvider.setContent(this._keyword);
        } else if ("music" == _tag) {
          itemProvider.setMusicPath(this._keyword);
        }
        print("${this._tag}:${this._keyword}");
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      focusNode: _focusNode,
      // textInputAction: TextInputAction.next,
    );

    return txtField;
  }
}

class MusicCtn extends StatefulWidget {
  const MusicCtn({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _MusicCtnState createState() => _MusicCtnState();
}

class _MusicCtnState extends State<MusicCtn> {
  double rpx;
  MusicModel musicModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    UploadPostItemProvider itemProvider =
        Provider.of<UploadPostItemProvider>(context);
    MusicProvider musicProvider = Provider.of<MusicProvider>(context);
    bool flag = itemProvider.musicField;
    musicModel = musicProvider.musicModel;
    var fontColor = Colors.grey.shade300;
    var fontStyle = TextStyle(color: fontColor, fontSize: 12.0);
    var musicName = "音乐名", albumName = "专辑名", artistName = "歌手名", albumPicUrl;
    if (musicModel != null) {
      musicName = musicModel.musicName;
      albumName = musicModel.albumName;
      artistName = musicModel.artistName;
      albumPicUrl = musicModel.albumPicUrl;
    }

    var albumImage = DecorationImage(
        image: albumPicUrl == null
            ? MemoryImage(kTransparentImage)
            : NetworkImage(albumPicUrl, scale: 0.1),
        fit: BoxFit.cover);
    return !flag
        ? Container()
        : Container(
            width: 650 * rpx,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11 * rpx),
                border:
                    Border.all(width: 1, color: Colors.white.withOpacity(0.3))),
            margin: EdgeInsets.only(top: 10 * rpx),
            child: Stack(
              children: [
                Column(
                  children: [
                    // /*音乐链接填写*/
                    Visibility(
                      visible: musicModel == null,
                      child: Row(
                        children: [
                          Container(
                            width: 500 * rpx,
                            // color: Colors.blue,
                            margin: EdgeInsets.only(left: 5.0),
                            child: ContentField(
                              tag: "music",
                              rpx: rpx,
                              hintText: "在网易云音乐复制链接粘贴在这里~",
                              hintColor: Colors.grey.shade400,
                              hintSize: 12.0,
                              conSize: 12.0,
                              minLine: 1,
                              maxLine: 1,
                              maxLength: 20,
                            ),
                          ),
                          //  控制按钮
                          Container(
                            width: 100 * rpx,
                            height: 90 * rpx,
                            // color: Colors.greenAccent,
                            child: IconButton(
                              onPressed: () {
                                musicProvider
                                    .getMusicInfo(itemProvider.musicPath);
                              },
                              icon: Icon(
                                Icons.check_circle_outline_rounded,
                                size: 60 * rpx,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    /*音乐信息展示*/
                    Visibility(
                      visible: musicModel != null,
                      child: Row(children: [
                        /*封面*/
                        Container(
                            height: 100 * rpx,
                            width: 100 * rpx,
                            margin: EdgeInsets.only(left: 2.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * rpx),
                                color: Colors.white.withOpacity(0.1),
                                image: albumImage),
                            child: albumPicUrl == null
                                ? Icon(
                                    Icons.album_rounded,
                                    color: Colors.grey.shade400,
                                    size: 60 * rpx,
                                  )
                                : Container()),
                        /*音乐信息*/
                        Container(
                          width: 535 * rpx,
                          height: 100 * rpx,
                          margin: EdgeInsets.only(left: 2),
                          child: Stack(
                            children: [
                              /*背景*/
                              Container(
                                // width: 395 * rpx,
                                height: 100 * rpx,
                                decoration: BoxDecoration(image: albumImage),
                              ),
                              Container(
                                // width: 505 * rpx,
                                height: 100 * rpx,
                                color: Colors.black.withOpacity(0.6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /*音乐信息*/
                                    Container(
                                      width: 340 * rpx,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(musicName, style: fontStyle),
                                          Text("$albumName — $artistName",
                                              style: fontStyle)
                                        ],
                                      ),
                                    ),
                                    /*音乐控制*/
                                    Container(
                                        width: 180 * rpx,
                                        height: 100 * rpx,
                                        // color: Colors.white.withOpacity(0.1),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                musicProvider
                                                    .play(musicModel.musicId);
                                              },
                                              icon: Icon(
                                                Icons
                                                    .play_circle_outline_rounded,
                                                size: 60 * rpx,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                musicProvider.clearMusicModel();
                                              },
                                              child: CloseBtn(
                                                rpx: rpx,
                                                radius: 25,
                                                size: 35,
                                                bgColor: Colors.black
                                                    .withOpacity(0.6),
                                                iconColor: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                /*加载中*/
                Visibility(
                  visible: musicProvider.isGetInfo,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(11 * rpx),
                      ),
                      height: 100 * rpx,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColorLight,
                        ),
                      )),
                )
              ],
            ),
          );
  }
}
