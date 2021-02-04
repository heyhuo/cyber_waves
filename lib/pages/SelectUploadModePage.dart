import 'package:cyber_waves/providers/UploadBtnProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectUploadPage extends StatefulWidget {
  const SelectUploadPage({Key key, @required this.rpx}) : super(key: key);

  final double rpx;

  @override
  _SelectUploadPageState createState() => _SelectUploadPageState();
}

class _SelectUploadPageState extends State<SelectUploadPage>
    with SingleTickerProviderStateMixin {
  double rpx;
  bool _isVisible = false;

//实例animation对象  和必要的控制和状态对象
  Animation<double> _animation;
  AnimationController _controller;
  AnimationStatus animationStatus;
  double animationvalue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;

    //初始化一个动画控制器 定义好动画的执行时长
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    //初始化一个补间动画 实例化一个补间类动画的实例，明确需要变换的区间大小和作用的controller对象
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
      });
    //提供方法 为动画添加监听
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UploadBtnProvider provider = Provider.of<UploadBtnProvider>(context);
    _isVisible = provider.visible;
    Color bgColor = Colors.black;
    return !_isVisible
        ? Container()
        : Positioned(
            bottom: -MediaQuery.of(context).size.height * _animation.value,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              child: Container(
                width: 750 * rpx,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.7),
                child: Container(
                  // color: Colors.yellow,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2),
                  child: Stack(
                    children: [
                      UploadBtnAnimate(
                          rpx: rpx,
                          bottomPos: 650 * rpx,
                          color: Colors.green.shade600,
                          icon: Icons.account_box,
                          title: "贴纸",
                          subTitle: "直接使用就完事了~"),
                      UploadBtnAnimate(
                          rpx: rpx,
                          bottomPos: 480 * rpx,
                          color: Colors.orange.shade600,
                          icon: Icons.photo,
                          title: "图片",
                          subTitle: "分享心爱的图片💖~"),
                      UploadBtnAnimate(
                          rpx: rpx,
                          bottomPos: 310 * rpx,
                          color: Colors.blue.shade600,
                          icon: Icons.video_library,
                          title: "视频",
                          subTitle: "发布有趣的视频📹~"),
                      Positioned(
                        bottom: 100 * rpx,
                        left: rpx * 320,
                        child: GestureDetector(
                          onTap: () {
                            provider.setVisible();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white.withOpacity(0.8),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 25,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _uploadBtn(Color color, IconData icon, String title, String subTitle) {
    var txtWidth = 360 * rpx;
    return Container(
      width: 550 * rpx,
      height: 150 * rpx,
      padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
      margin: EdgeInsets.only(top: 40 * rpx),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 50.0,
          ),
          Container(
            width: txtWidth,
            // color: Colors.yellow,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: txtWidth,
                  // color: Colors.yellow,
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: txtWidth,
                  child: Text(
                    subTitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 13),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UploadBtnAnimate extends StatefulWidget {
  final String subTitle;
  final String title;
  final IconData icon;
  final Color color;
  final double rpx;
  final double bottomPos;

  const UploadBtnAnimate(
      {Key key,
      @required this.rpx,
      @required this.bottomPos,
      @required this.color,
      @required this.icon,
      @required this.title,
      @required this.subTitle})
      : super(key: key);

  @override
  _UploadBtnAnimateState createState() => _UploadBtnAnimateState();
}

class _UploadBtnAnimateState extends State<UploadBtnAnimate>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  String subTitle;
  String title;
  IconData icon;
  Color color;
  double rpx;
  double bottomPos;
  Color curColor;
  double curWidth;

  @override
  void initState() {
    super.initState();
    subTitle = widget.subTitle;
    title = widget.title;
    color = widget.color;
    icon = widget.icon;
    rpx = widget.rpx;
    bottomPos = widget.bottomPos;
    curWidth = 550 * rpx;
    curColor = Colors.black45;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // curColor = color;
          // curWidth = 550*rpx;
        }
      });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    var txtWidth = 360 * rpx;
    return Positioned(
        bottom: bottomPos * _animation.value,
        left: 100 * rpx,
        child: Container(
          width: curWidth,
          height: 150 * rpx,
          padding: EdgeInsets.symmetric(horizontal: 20 * rpx),
          margin: EdgeInsets.only(top: 40 * rpx),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 50.0,
              ),
              Container(
                width: txtWidth,
                // color: Colors.yellow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: txtWidth,
                      // color: Colors.yellow,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: txtWidth,
                      child: Text(
                        subTitle,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
