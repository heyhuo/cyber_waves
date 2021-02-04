import 'package:cyber_waves/pages/MakerPage.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UploadBtnProvider provider = Provider.of<UploadBtnProvider>(context);
    _isVisible = provider.visible;
    // if(_isVisible) //提供方法 为动画添加监听
    //   _controller.forward(from: 0);
    return !_isVisible ? Container() : UploadAnimateBtn(rpx: rpx);
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
  final String tag;

  const UploadBtnAnimate(
      {Key key,
      @required this.rpx,
      @required this.bottomPos,
      @required this.color,
      @required this.icon,
      @required this.title,
      @required this.tag,
      @required this.subTitle})
      : super(key: key);

  @override
  _UploadBtnAnimateState createState() => _UploadBtnAnimateState();
}

class _UploadBtnAnimateState extends State<UploadBtnAnimate>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  Animation _curve;
  String subTitle;
  String title;
  IconData icon;
  Color color;
  double rpx;
  double bottomPos;
  Color curColor;
  double curWidth;
  String tag;

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
    tag = widget.tag;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

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
    UploadBtnProvider provider = Provider.of<UploadBtnProvider>(context);
    var txtWidth = 300 * rpx;
    return Positioned(
        bottom: bottomPos,
        left: 100 * rpx,
        child: InkWell(
          onTap: () {
            provider.setHeroTag(tag, context);
          },
          child: Hero(
            tag: tag,
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
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class UploadAnimateBtn extends StatefulWidget {
  const UploadAnimateBtn({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _UploadAnimateBtnState createState() => _UploadAnimateBtnState();
}

class _UploadAnimateBtnState extends State<UploadAnimateBtn>
    with SingleTickerProviderStateMixin {
  double rpx;
  UploadBtnProvider provider;
  AnimationController _controller;
  Animation<double> _animation;
  Animation _curve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _curve = CurvedAnimation(parent: _controller, curve: Curves.bounceIn);

    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
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
    provider = Provider.of<UploadBtnProvider>(context);
    return Positioned(
      bottom: 0,//-MediaQuery.of(context).size.height * _animation.value,
      child: Container(
        width: 750 * rpx,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Container(
          // color: Colors.yellow,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
          child: Stack(
            children: [
              Positioned(
                left: 100*rpx,
                bottom:(-MediaQuery.of(context).size.height/2) * _animation.value +300*rpx,
                child: Column(
                  children: [
                    _getUploadBtn(rpx, 650 * rpx, Colors.green.shade600,
                        Icons.account_box, "贴纸", "sticker", "直接使用就完事了~"),
                    _getUploadBtn(rpx, 480 * rpx, Colors.orange.shade600, Icons.photo,
                        "图片", "picture", "分享心爱的图片💖~"),
                    _getUploadBtn(rpx, 310 * rpx, Colors.blue.shade600,
                        Icons.video_library, "视频", "video", "发布有趣的视频📹~"),
                  ],
                ),
              ),
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
    );
  }

  Widget _getUploadBtn(rpx, bottomPos, color, icon, title, tag, subTitle) {
    var txtWidth = 300 * rpx;
    // return Positioned(
    //     bottom: bottomPos,
    //     left: 100 * rpx,
    //     child: );

    return InkWell(
      onTap: () {
        provider.setHeroTag(tag, context);
      },
      child: Hero(
        tag: tag,
        child: Container(
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
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),);
  }
}
