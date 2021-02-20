import 'dart:convert';

import 'package:cyber_waves/models/PostModel.dart';
import 'package:cyber_waves/providers/MusicProvider.dart';
import 'package:cyber_waves/providers/PostItemProvider.dart';
import 'package:cyber_waves/tools/WebRequest.dart';
import 'package:cyber_waves/tools/WidgetHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    postItemProvider = Provider.of<PostItemProvider>(context);
    musicProvider = Provider.of<MusicProvider>(context);
    // postItemProvider.getPostItemList(1);
    return RefreshPage(provider: postItemProvider);
  }

  _getUserContentList() async {
    await postItemProvider.getPostItemList();

    // return List.generate(
    //   5,
    //   (index) => GestureDetector(
    //     child: UserContentItem(
    //       rpx: rpx,
    //     ),
    //   ),
    // );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = widget.provider;
    controller = ScrollController();
    _refreshController = RefreshController(initialRefresh: true);
    provider.getPostItemList();
  }

  @override
  Widget build(BuildContext context) {
    postList = provider.postList;
    return SmartRefresher(
      controller: _refreshController,
      // enablePullUp: true,
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
            body = CupertinoActivityIndicator();
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
      child: ListView.builder(
          // controller: controller,
          // shrinkWrap: true,
          itemCount: postList.length,
          itemBuilder: (context, index) {
            return UserContentItem(postList[index], provider);
          }),
    );
  }

  void _onRefresh() async {
    provider.getPostItemList(ifRefresh: true);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // await Future.delayed(Duration(milliseconds: 500));
    provider.getPostItemList();
    _refreshController.loadComplete();
  }
}

class UserContentItem extends StatefulWidget {
  const UserContentItem(this.postModel, this.provider, {Key key})
      : super(key: key);
  final PostModel postModel;
  final PostItemProvider provider;

  @override
  _UserContentItemState createState() => _UserContentItemState();
}

class _UserContentItemState extends State<UserContentItem> {
  PostModel postModel;
  double rpx;
  var ipPortBasePath;
  PostItemProvider provider;

  // VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postModel = widget.postModel;
    provider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    ipPortBasePath = "${provider.ipPort}/static/${postModel.picBasePath}/";
    rpx = MediaQuery.of(context).size.width / 750;
    bool isVedio = false;
    return Container(
      /*背景图*/
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          image: DecorationImage(
              image: NetworkImage("$ipPortBasePath${postModel.thumbPath}",
                  scale: 0.01),
              fit: BoxFit.fitWidth)),
      width: 750 * rpx,
      child: Container(
        color: Colors.black.withOpacity(0.6),
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
                        style: TextStyle(color: Colors.white, letterSpacing: 3),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ))),
                  /*网格图片*/
                  _getUserGridViewPics(postModel.picPathList),
                ],
              ),
            )
          ],
        ),
      ),
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
        image: "$ipPortBasePath${picPath}",
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
  Widget _getUserGridViewPics(picPathList) {
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
        return _getGridPic(picPath);
      }),
    );
  }
}
