import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import 'package:cyber_waves/pages/SelectUploadModePage.dart';
import 'package:cyber_waves/providers/MusicProvider.dart';
import 'package:cyber_waves/providers/PostItemProvider.dart';
import 'package:cyber_waves/providers/UploadBtnProvider.dart';
import 'package:cyber_waves/wigets/BottomBar.dart';
import 'package:cyber_waves/wigets/MainWidget.dart';

import 'UserHomePage.dart';

class HomeMainPage extends StatefulWidget {
  HomeMainPage({Key key}) : super(key: key);

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage>
    with TickerProviderStateMixin {
  var list = new List<String>();
  double rpx;
  bool uploadBtnVisible = false;
  var postItemProvider = PostItemProvider();
  var musicProvider = MusicProvider();
  var uploadBtnProvider = UploadBtnProvider(false, "");

  @override
  void initState() {
    super.initState();

    // tabs = ["精选", "视频", "关注"];
    // tabList = List.generate(tabs.length, (index) => Text(tabs[index]));
    // _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    rpx = MediaQuery.of(context).size.width / 750;

    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.keyboard),
      //   title: Text("标题"),
      //   actions: [
      //     Icon(Icons.music_note_outlined),
      //     Icon(Icons.add_circle_outline_rounded)
      //   ],
      //   bottom: TabBar(
      //     controller: _tabController,
      //     tabs:
      //         tabList, /*[
      //       Text("精选"),
      //       Text("视频"),
      //     ],*/
      //   ),
      // ),

      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return uploadBtnProvider;
          }),
          ChangeNotifierProvider(create: (context) {
            return postItemProvider;
          }),
          ChangeNotifierProvider(create: (context) {
            return musicProvider;
          })
        ],
        child: Stack(
          children: [HomeMain(rpx: rpx), SelectUploadPage(rpx: rpx)],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        // notchMargin: 1,
        color: Theme.of(context).primaryColorLight,
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => uploadBtnProvider),
              ChangeNotifierProvider(create: (context) => postItemProvider),
              ChangeNotifierProvider(create: (context) => musicProvider)
            ],
            child: BtmBar(rpx: rpx, selectIndex: 0)),
      ),
    );
  }
}

class HomeMain extends StatefulWidget {
  const HomeMain({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> with TickerProviderStateMixin {
  TabController tabController;
  double rpx;
  double height;
  ScrollController _scrollController = new ScrollController();

  List imgList = [
    "http://yanxuan.nosdn.127.net/65091eebc48899298171c2eb6696fe27.jpg",
    "http://yanxuan.nosdn.127.net/8b30eeb17c831eba08b97bdcb4c46a8e.png",
    "http://yanxuan.nosdn.127.net/a196b367f23ccfd8205b6da647c62b84.png",
    "http://yanxuan.nosdn.127.net/149dfa87a7324e184c5526ead81de9ad.png",
    "http://yanxuan.nosdn.127.net/88dc5d80c6f84102f003ecd69c86e1cf.png",
    "http://yanxuan.nosdn.127.net/8b9328496990357033d4259fda250679.png",
    "http://yanxuan.nosdn.127.net/c39d54c06a71b4b61b6092a0d31f2335.png",
    "http://yanxuan.nosdn.127.net/ee92704f3b8323905b51fc647823e6e5.png",
    "http://yanxuan.nosdn.127.net/e564410546a11ddceb5a82bfce8da43d.png",
    "http://yanxuan.nosdn.127.net/56f4b4753392d27c0c2ccceeb579ed6f.png",
    "http://yanxuan.nosdn.127.net/6a54ccc389afb2459b163245bbb2c978.png",
    'https://picsum.photos/id/101/548/338',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1569842561051&di=45c181341a1420ca1a9543ca67b89086&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201504%2F17%2F20150417212547_VMvrj.jpeg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1570437233&di=9239dbc3237f1d21955b50e34d76c9d5&imgtype=jpg&er=1&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fblog%2F201508%2F30%2F20150830095308_UAQEi.thumb.700_0.jpeg'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 300 * rpx;
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          // snap: true,
          // floating: true,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(0 * rpx),
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 4.0,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 80 * rpx),
                controller: tabController,
                tabs: [
                  Text("直播", style: TextStyle(color: Colors.white)),
                  Text("推荐", style: TextStyle(color: Colors.white)),
                  Text("热门", style: TextStyle(color: Colors.white)),
                ],
              )),
          expandedHeight: 150 * rpx,
          // backgroundColor: thof,
          flexibleSpace: FlexibleSpaceBar(
            // title: CircleAvatar(backgroundColor: Colors.blue,),
            // stretchModes: [StretchMode.zoomBackground],
            background: HomeTopBar(),
          ),
        ),
        // SliverFillRemaining(
        //   delegate:
        //       new SliverChildBuilderDelegate((BuildContext context, int index) {
        //     //创建列表项
        //     return Container(
        //       // width: 100,
        //       margin: EdgeInsets.only(top: 300 * rpx),
        //       height: height,
        //       color: Colors.yellowAccent,
        //       child: StaggeredGridView.countBuilder(
        //         padding: const EdgeInsets.all(8.0),
        //         crossAxisCount: 4,
        //         itemCount: imgList.length,
        //         itemBuilder: (context, i) {
        //           String imgPath = imgList[i];
        //           return new Material(
        //             elevation: 8.0,
        //             borderRadius: new BorderRadius.all(
        //               new Radius.circular(8.0),
        //             ),
        //             child: new InkWell(
        //               onTap: () {
        //                 Navigator.push(
        //                   context,
        //                   new MaterialPageRoute(
        //                     builder: (context) {
        //                       // return new FullScreenImagePage(imgPath);
        //                     },
        //                   ),
        //                 );
        //               },
        //               child: new Hero(
        //                 tag: imgPath,
        //                 child: CachedNetworkImage(
        //                   imageUrl: imgPath,
        //                   fit: BoxFit.fitWidth,
        //                   placeholder: (context, url) =>
        //                       Image.asset('assets/wallfy.png'),
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //         staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
        //         mainAxisSpacing: 8.0,
        //         crossAxisSpacing: 8.0,
        //       ),
        //     );
        //   }, childCount: 1),
        //   viewportFraction: 1.0,
        // )

        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Container(
            height: 100 * rpx,
            width: 100 * rpx,
            margin: EdgeInsets.only(top: 10),
            color: Colors.blue,
            child: Row(
              children: [
                Container(
                  width: 100 * rpx,
                  height: 100 * rpx,
                  color: Colors.yellowAccent,
                ),
                Container(
                  width: 100 * rpx,
                  height: 100 * rpx,
                  color: Colors.red,
                ),
              ],
            ),
          );
        }, childCount: 100)),
      ],
    );
  }
}

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 70 * rpx,
            height: 70 * rpx,
            margin: EdgeInsets.only(left: 30 * rpx),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserHomePage()));
              },
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/avatar1.jpeg"),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(
                  Icons.person_outlined,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(Icons.more_vert_outlined, color: Colors.white),
                onPressed: () {})
          ],
        ),
      ],
    );
  }
}

class TileCard extends StatelessWidget {
  final String img;
  final String title;
  final String author;
  final String authorUrl;
  final String type;
  final double worksAspectRatio;

  TileCard(
      {this.img,
      this.title,
      this.author,
      this.authorUrl,
      this.type,
      this.worksAspectRatio});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.deepOrange,
            child: CachedNetworkImage(imageUrl: '$img'),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
            child: Text(
              '$title',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30),
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage('$authorUrl'),
                  radius: ScreenUtil().setWidth(30),
                  // maxRadius: 40.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  width: ScreenUtil().setWidth(250),
                  child: Text(
                    '$author',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(25),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(80)),
                  child: Text(
                    '${type == 'EXISE' ? '练习' : '其他'}',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(25),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
