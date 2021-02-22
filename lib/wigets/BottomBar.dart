import 'package:cyber_waves/pages/MakerPage.dart';
import 'package:cyber_waves/pages/Pace.dart';
import 'package:cyber_waves/pages/SelectUploadModePage.dart';
import 'package:cyber_waves/pages/UserHomePage.dart';
import 'package:cyber_waves/providers/CameraProvider.dart';
import 'package:cyber_waves/providers/FaceCameraProvider.dart';
import 'package:cyber_waves/providers/PostsGalleryProvider.dart';
import 'package:cyber_waves/providers/UploadBtnProvider.dart';
import 'package:cyber_waves/wigets/MakerMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CameraMain.dart';

// class BtmBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           getBtmTextWiget("踱步", false),
//           AddIcon(),
//           getBtmTextWiget("潜行", false)
//         ],
//       ),
//     );
//   }
// }

class BtmBar extends StatefulWidget {
  BtmBar({Key key, this.rpx, this.selectIndex}) : super(key: key);
  final double rpx;
  final int selectIndex;

  @override
  _BtmBarState createState() => _BtmBarState();
}

class _BtmBarState extends State<BtmBar> {
  List<bool> selected = List<bool>();
  List<String> selectItems = List<String>();
  double rpx;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 2; i++) {
      selected.add(false);
    }
    selected[widget.selectIndex] = true;
    rpx = widget.rpx;
  }

  @override
  dispose() {
    super.dispose();
  }

  _getBtmModalBtn(rpx, path, txt1, txt2) {
    return Container(
      width: 250 * rpx,
      height: 290 * rpx,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          children: [
            Image.asset(path),
            Text(txt1,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            Text(
              txt2,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  tapItem(index) {
    switch (index) {
      case 1:
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => MultiProvider(providers: [
        //               // ChangeNotifierProvider(
        //               //   create: (context) => PostsGalleryProvider(),
        //               // )
        //             ], child: UserHomePage())),
        //     ModalRoute.withName("/pace"));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserHomePage()));
        break;

      /*底部菜单滑出界面*/
      case 2:
        // Container(
        //   width: 100,
        //   height: 100,
        //   color: Colors.white,
        // );
        // double rpx = MediaQuery.of(context).size.width / 750;
        // showModalBottomSheet(
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        //     backgroundColor: Colors.transparent,
        //     isScrollControlled: true,
        //     context: context,
        //     builder: (BuildContext context) {
        //       return Container(
        //         color: Colors.black.withOpacity(0.1),
        //         height: MediaQuery.of(context).size.height,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             GestureDetector(
        //               onTap: () {
        //                 /*Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (BuildContext context) =>
        //                             MakerPage()));*/
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (BuildContext context) {
        //                           return MultiProvider(providers: [
        //                             ChangeNotifierProvider(
        //                               create: (_) => FaceCameraProvider(),
        //                             )
        //                           ], child: MakerPage());
        //                         },
        //                         fullscreenDialog: true));
        //               },
        //               child: _getBtmModalBtn(
        //                   rpx, "assets/images/btm_bg2.png", "贴纸", "直接使用就完事了~"),
        //             ),
        //           ],
        //         ),
        //       );
        //     });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectUploadPage(rpx: rpx)));
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100 * rpx,
      width: 750 * rpx,
      color: Theme.of(context).primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          getBtmTextWiget(context, "踱步", selected[0], () {
            tapItem(0);
          }),
          AddIcon(),
          getBtmTextWiget(context, "我的", selected[1], () {
            tapItem(1);
          })
        ],
      ),
    );
  }
}

getBtmTextWiget(context, String content, bool ifSelected, tapFunc) {
  return FlatButton(
    onPressed: tapFunc,
    child: Text("$content",
        style: ifSelected
            ? TextStyle(
                fontSize: 16,
                color: Color(0xffffffff),
                fontWeight: FontWeight.w600)
            : TextStyle(
                fontSize: 16,
                // fontStyle: FontStyle.italic,
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold)),
  );
}

class AddIcon extends StatelessWidget {
  const AddIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UploadBtnProvider provider = Provider.of<UploadBtnProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    double iconHeight = 55 * rpx;
    double totalWidth = 90 * rpx;
    double eachSide = 5 * rpx;

    return Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 40,
      width: 60,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        // 上传按钮
        onPressed: () {
          provider.setVisible();
        },
        child: Stack(
          children: [
            Positioned(
              height: 35,
              width: 50,
              top: 4,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[600].withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Positioned(
              height: 35,
              width: 50,
              right: 6,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue[600].withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Positioned(
              height: 35,
              width: 50,
              right: 3,
              top: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
