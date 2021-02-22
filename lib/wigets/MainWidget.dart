import 'dart:convert';

import 'package:cyber_waves/models/PostModel.dart';
import 'package:cyber_waves/providers/MusicProvider.dart';
import 'package:cyber_waves/providers/PostItemProvider.dart';
import 'package:cyber_waves/tools/WebRequest.dart';
import 'package:cyber_waves/tools/WidgetHelper.dart';
import 'package:cyber_waves/wigets/CameraMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:video_player/video_player.dart';
import 'package:transparent_image/transparent_image.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  double rpx;
  PostItemProvider postItemProvider;
  MusicProvider musicProvider;
  List<PostModel> postList;

  @override
  void initState() {
    super.initState();
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    postItemProvider = Provider.of<PostItemProvider>(context);
    musicProvider = Provider.of<MusicProvider>(context);
    return RefreshPage(provider: postItemProvider);
  }
}

class RefreshPage extends StatefulWidget {
  const RefreshPage({Key key, @required this.provider}) : super(key: key);
  final provider;

  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  PostItemProvider provider;
  List<PostModel> postList;
  var data = List<String>();
  ScrollController controller;
  bool ifLoading = false;
  RefreshController _refreshController;
  ListView _itemListWidget;
  double rpx;

  @override
  void initState() {
    super.initState();
    provider = widget.provider;
    controller = ScrollController();
    _refreshController = RefreshController(initialRefresh: true);
    provider.getPostItemList();
  }

  _setItemListWidget() {
    var list = ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: postList.length,
        itemBuilder: (context, index) {
          return PostItem(
              postModel: postList[index], provider: provider, rpx: rpx);
        });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    postList = provider.postList;
    //_setItemListWidget();
    rpx = MediaQuery.of(context).size.width / 750;

    return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: true,
        header: BezierCircleHeader(
          bezierColor: Theme.of(context).primaryColorLight,
          circleColor: Colors.yellowAccent,
          circleType: BezierCircleType.Progress,
        ),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else {
              body = Text("已经见底了~");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: (postList == null || postList.length == 0)
            ? Container(
                // color: Colors.yellowAccent,
                child: Column(
                children: [
                  // CircularProgressIndicator(),
                  // Icon(Icons.phonelink_erase_rounded),
                  // Text("暂无数据"),
                ],
              ))
            : _setItemListWidget());
  }

  void _onRefresh() async {
    provider.page = 1;
    provider.getPostItemList(ifRefresh: true);
    // _setItemListWidget();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // await Future.delayed(Duration(milliseconds: 500));
    provider.page++;
    provider.getPostItemList();
    _refreshController.loadComplete();
  }
}

class PostItem extends StatelessWidget {
  const PostItem({Key key, this.postModel, this.provider, this.rpx})
      : super(key: key);
  final PostModel postModel;
  final PostItemProvider provider;
  final double rpx;

  @override
  Widget build(BuildContext context) {
    var ipPortBasePath = "${provider.ipPort}/static/${postModel.picBasePath}/";
    // rpx = MediaQuery.of(context).size.width / 750;
    bool isVedio = false;
    var ratio = 1.8;
    return Stack(
      children: [
        //背景图
        Center(
          child: AspectRatio(
            aspectRatio: ratio,
            child: BlurHash(hash: postModel.thumbPath),
          ),
        ),

        Container(
          color: Colors.black.withOpacity(0.3),
          child: AspectRatio(
              aspectRatio: ratio,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //头像
                  _getUserAvatar(),
                  //内容
                  Container(
                    width: 600 * rpx,
                    // color: Colors.brown,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /*用户名*/
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 600 * rpx,
                                  // color: Colors.blue,
                                  child: Text(
                                    postModel.userId,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        /*标签*/
                        Container(
                          child: Row(children: _getTagList(postModel.tagList)),
                        ),
                        /*内容*/
                        Container(
                            width: 600 * rpx,
                            // color: Colors.white54.withOpacity(0.2),
                            padding: EdgeInsets.only(right: 10 * rpx),
                            margin: EdgeInsets.only(top: 10 * rpx),
                            child: Container(
                                child: Text(
                              postModel.content,
                              style: TextStyle(
                                  color: Colors.white, letterSpacing: 3),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ))),
                        /*网格图片*/
                        _getUserGridViewPics(
                            ipPortBasePath, postModel.picPathList),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ],
      // ),
      // ),
    );
  }

  _getTagList(tagList) {
    var tags = json.decode(tagList);
    var list = List<Widget>();
    for (var tag in tags) {
      var t = json.decode(tag);
      list.add(_getUserTag(t["name"], t["color"]));
    }
    return list;
  }

  /* 获取标签组件 */
  Widget _getUserTag(tagName, color) {
    // "0xff$color"
    Color tagColor = WidgetHelper.hexStringColor(color);
    return Container(
        alignment: Alignment.center,
        height: 52 * rpx,
        margin: EdgeInsets.only(right: 5, top: 5),
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          // color: color,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [tagColor, Color(0x20ffffff)]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          tagName,
          style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.5)),
        ));
  }

  /* 获取网格单张图片组件 */
  Widget _getGridPic(picPath) {
    return Container(
        // color: Colors.blue,
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(6.0),
        //   color: Colors.black.withOpacity(0.3),
        // ),
        child: Card(
      color: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(6.0)),
      clipBehavior: Clip.antiAlias,
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: picPath,
        fit: BoxFit.fitWidth,
      ),
    )
        // height:10 * rpx,
        // width: 10*rpx,
        );
  }

  /* 获取用户头像 */
  Widget _getUserAvatar() {
    return Container(
      // color: Colors.red,
      margin: EdgeInsets.only(top: 10, left: 10),
      padding: EdgeInsets.all(10),
      width: 80 * rpx,
      height: 80 * rpx,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white, width: 2.0, style: BorderStyle.solid),
          image: DecorationImage(
              image: AssetImage("assets/images/avatar1.jpeg"),
              fit: BoxFit.fitHeight)),
    );
  }

  /* 获取网格图片组件 */
  Widget _getUserGridViewPics(ipPortBasePath, picPathList) {
    var pathList = json.decode(picPathList);
    var userId = postModel.userId;
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      //水平子Widget之间间距
      crossAxisSpacing: 0.0,
      //垂直子Widget之间间距
      mainAxisSpacing: 0.0,
      // childAspectRatio: 1.0,
      children: List.generate(pathList.length, (index) {
        var picPath = json.decode(pathList[index])["name"];
        return _getGridPic(ipPortBasePath + picPath);
      }),
    );
  }
}

// class UserContentItem extends StatefulWidget {
//   const UserContentItem(this.postModel, this.provider, {Key key})
//       : super(key: key);
//   final PostModel postModel;
//   final PostItemProvider provider;
//
//   @override
//   _UserContentItemState createState() => _UserContentItemState();
// }
//
// class _UserContentItemState extends State<UserContentItem> {
//   PostModel postModel;
//   double rpx;
//   var ipPortBasePath;
//   PostItemProvider provider;
//
//   // VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     postModel = widget.postModel;
//     provider = widget.provider;
//   }
// }
