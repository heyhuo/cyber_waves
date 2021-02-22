import 'package:after_layout/after_layout.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Scaffold(
      body: Container(
          child: UserHome(
        rpx: rpx,
      )),
    );
  }
}

class UserHome extends StatefulWidget {
  const UserHome({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> with TickerProviderStateMixin {
  double rpx;
  double extraPicHeight = 0;
  BoxFit fitType;
  double prevDy;
  double expandedHeight=300;

  AnimationController animationController;
  Animation<double> anim, bgAnim;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    rpx = widget.rpx;
    prevDy = 0;
    fitType = BoxFit.fitWidth;
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    anim = Tween(begin: 0.0, end: 0.0).animate(animationController);
    bgAnim = Tween(begin: 0.0, end: 0.0).animate(animationController);
    tabController = TabController(length: 3, vsync: this);
  }

  updatePicHeight(changed) {
    if (prevDy == 0) prevDy = changed;
    extraPicHeight += changed - prevDy;
    if (extraPicHeight >= 200 * rpx)
      fitType = BoxFit.fitHeight;
    else
      fitType = BoxFit.fitWidth;
    setState(() {
      prevDy = changed;
      extraPicHeight = extraPicHeight;
      fitType = fitType;
      bgAnim = Tween(begin: 0.0, end: 0.4).animate(animationController);
    });
  }

  updateExpandedHeight(height){
    setState(() {
      expandedHeight=height;
    });
  }

  runAnimate() {
    setState(() {
      bgAnim = Tween(begin: 0.4, end: 0.0).animate(animationController);
      anim = Tween(begin: extraPicHeight, end: 0.0).animate(animationController)
        ..addListener(() {
          if (extraPicHeight >= 200 * rpx)
            fitType = BoxFit.fitHeight;
          else
            fitType = BoxFit.fitWidth;
          setState(() {
            extraPicHeight = anim.value;
          });
        });
      prevDy = 0;
      fitType = fitType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (movePointEvent) {
        updatePicHeight(movePointEvent.position.dy);
        // print(movePointEvent.position);
      },
      onPointerUp: (_) {
        runAnimate();
        animationController.forward(from: 0);
      },
      child: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.person_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.more_vert_outlined, color: Colors.white),
                  onPressed: () {}),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: TabBar(
                  controller: tabController,
                  tabs: [
                    Text("作品 91", style: TextStyle(color: Colors.white)),
                    Text("动态 91", style: TextStyle(color: Colors.white)),
                    Text("喜欢 91", style: TextStyle(color: Colors.white)),
                  ],
                )),
            expandedHeight: expandedHeight + extraPicHeight,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: TopBarWithCallback(
                extraPicHeight: extraPicHeight,
                fitType: fitType,
                bgAnim: bgAnim,
                updateHeight: updateExpandedHeight,
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              height: 30,
              color: Colors.white,
            );
          }, childCount: 80))
        ],
      ),
    );
  }
}

class UserSliverTopBar extends StatelessWidget {
  const UserSliverTopBar(
      {Key key,
      @required this.extraPicHeight,
      @required this.fitType,
      @required this.bgAnim})
      : super(key: key);

  final double extraPicHeight;
  final BoxFit fitType;
  final Animation<double> bgAnim;

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Stack(
      children: [
        Column(
          children: [
            //背景图
            Container(
              height: 300 * rpx + extraPicHeight,
              // decoration: BoxDecoration(color: Colors.blue),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/bg4.jpg",
                    width: 750 * rpx,
                    height: 300 * rpx + extraPicHeight,
                    fit: fitType,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.4 ),//- bgAnim.value
                  ),
                ],
              ),
            ),
            //信息
            Container(
              padding: EdgeInsets.only(top: 20 * rpx),
              height: 120 * rpx,
              // color: Colors.yellowAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    // color: Colors.greenAccent,
                    width: 200 * rpx,
                    height: 80 * rpx,
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: () {},
                      child: Text(
                        "+ 关注",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30 * rpx,
                            letterSpacing: 3 * rpx),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10 * rpx,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Color(0xff3b3c49),
                    ),
                    height: 80 * rpx,
                    // width: 60*rpx,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 50 * rpx,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 30 * rpx,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10 * rpx,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30 * rpx),
              width: 750 * rpx,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "黑火的柠檬🍋",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40 * rpx,
                        letterSpacing: 3*rpx,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "ID:123456",
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
              child: Divider(
                color: Colors.grey[700],
              ),
            ),
            Visibility(
              visible: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store_outlined, color: Color(0xffeacd3f)),
                        Text("商品橱窗", style: TextStyle(color: Color(0xffeacd3f))),
                      ],
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Color(0xffeacd3f),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
                child: Divider(
                  color: Colors.grey[700],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
              height: 100 * rpx,
              width: 750 * rpx,
              child: Text(
                "大数据爱哦的撒娇的三大打算\n大鸡排的飒飒就嗲",
                style: TextStyle(color: Colors.white, fontSize: 30 * rpx),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20 * rpx, vertical: 10 * rpx),
              child: Row(
                children: [
                  TagItem(text: "深圳"),
                  TagItem(text: "世界之窗"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20 * rpx, vertical: 20 * rpx),
              child: Row(
                children: [
                  NumWithDesc(numStr: "100.2w", descStr: "获赞"),
                  NumWithDesc(numStr: "15", descStr: "关注"),
                  NumWithDesc(numStr: "6.2w", descStr: "粉丝"),
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: 230 * rpx + extraPicHeight,
          left: 20 * rpx,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 10 * rpx,
                color: Colors.black, //Color.fromARGB(128, 219, 48, 85),
              ),
            ),
            width: 190 * rpx,
            height: 190 * rpx,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/avatar1.jpeg"),
            ),
          ),
        ),
      ],
    );
  }
}

class TagItem extends StatelessWidget {
  const TagItem({Key key, this.text}) : super(key: key);
  final text;

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      padding: EdgeInsets.all(10 * rpx),
      margin: EdgeInsets.only(right: 10 * rpx),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5 * rpx),
          color: Color(0xff3b3c49)),
      child: Text(
        text,
        style: TextStyle(fontSize: 24 * rpx, color: Colors.grey),
      ),
    );
  }
}

class NumWithDesc extends StatelessWidget {
  const NumWithDesc({Key key, @required this.numStr, @required this.descStr})
      : super(key: key);
  final String numStr;
  final String descStr;

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Padding(
      padding: EdgeInsets.only(right: 20 * rpx),
      child: Row(
        children: [
          Text(
            numStr,
            style: TextStyle(
                fontSize: 40 * rpx,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 5 * rpx,
          ),
          Text(descStr,
              style: TextStyle(
                  fontSize: 35 * rpx,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}

class TopBarWithCallback extends StatefulWidget {
  const TopBarWithCallback(
      {Key key,
      @required this.extraPicHeight,
      @required this.fitType,
      @required this.bgAnim,
      @required this.updateHeight})
      : super(key: key);
  final double extraPicHeight;
  final BoxFit fitType;
  final Animation<double> bgAnim;
  final Function(double) updateHeight;

  @override
  _TopBarWithCallbackState createState() => _TopBarWithCallbackState();
}

class _TopBarWithCallbackState extends State<TopBarWithCallback>
    with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: UserSliverTopBar(
          extraPicHeight: widget.extraPicHeight,
          fitType: widget.fitType,
          bgAnim: widget.bgAnim),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox box = context.findRenderObject();
    double height =
        box.getMaxIntrinsicHeight(MediaQuery.of(context).size.width);
    widget.updateHeight(height);
  }
}
