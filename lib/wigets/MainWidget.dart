import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  double rpx;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          5,
          (index) => GestureDetector(
            child: UserContentItem(
              rpx: rpx,
            ),
          ),
        ), //_getUserContent()
      ),
    );
  }
}

class UserContentItem extends StatefulWidget {
  const UserContentItem({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _UserContentItemState createState() => _UserContentItemState();
}

class _UserContentItemState extends State<UserContentItem> {
  double rpx;
  // VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = VideoPlayerController.asset("dataSource")
    //   ..initialize().then((value) {
    //     setState(() {});
    //   });
    rpx=widget.rpx;
  }

  @override
  Widget build(BuildContext context) {

      bool isVedio = false;
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/gif/g1.gif"), fit: BoxFit.fill)),
        width: 750 * rpx,
        child: Container(
          color: Colors.black.withOpacity(0.7),
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
                                "中之人sakura",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    /*标签*/
                    Container(
                      child: Row(
                        children: [
                          _getUserTag("五金店长营业", Colors.pinkAccent),
                          _getUserTag("配饰", Colors.blueAccent),
                        ],
                      ),
                    ),
                    /*内容*/
                    Container(
                        width: 600 * rpx,
                        color: Colors.red,
                        // padding: EdgeInsets.only(right: 10 * rpx),
                        child: Container(
                            child: Text(
                              "文字描述字描述文\n字描述字描述文字描述字\n描述",
                              style: TextStyle(
                                  color: Colors.grey.shade300, letterSpacing: 3),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ))),
                    /*网格图片*/
                    _getUserGridViewPics(),
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }

  /* 获取标签组件 */
  Widget _getUserTag(tagName, color) {
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
              colors: [color, Color(0x20ffffff)]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          tagName,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade100),
        ));
  }

  /* 获取网格单张图片组件 */
  Widget _getGridPic() {
    return Container(
      // color: Colors.blue,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.blue,
          ),
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
  Widget _getUserGridViewPics() {
    return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1,
        //水平子Widget之间间距
        crossAxisSpacing: 5.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 5.0,
        // childAspectRatio: 1.0,
        children: [
          _getGridPic(),
          _getGridPic(),
          _getGridPic(),
          _getGridPic(),
          _getGridPic(),
          _getGridPic(),
          _getGridPic(),
        ],
    );
  }


}
