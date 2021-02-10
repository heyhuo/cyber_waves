// import 'package:cyber_waves/models/PostsModel.dart';
// import 'package:cyber_waves/providers/PostsGalleryProvider.dart';
// import 'package:cyber_waves/wigets/BottomBar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class PaceMain extends StatelessWidget {
//   const PaceMain({Key key, this.selIndex}) : super(key: key);
//
//   final int selIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     PostsGalleryProvider provider =
//         Provider.of<PostsGalleryProvider>(context); //null
//     double rpx = MediaQuery.of(context).size.width / 750;
//     ScrollController controller = ScrollController();
//     return provider == null || provider.model1 == null
//         ? Scaffold()
//         : Scaffold(
//             backgroundColor: Theme.of(context).primaryColorDark,
//             appBar: AppBar(
//               backgroundColor: Theme.of(context).primaryColorLight,
//               title: Text("踱步"),
//             ),
//             bottomNavigationBar: Container(
//               // decoration: BoxDecoration(color: Colors.lightBlueAccent),
//               child: Container(
//                   color: Theme.of(context).primaryColorLight,
//                   child: SafeArea(child: BtmBar(selectIndex: selIndex))),
//             ),
//             body: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   height: 120 * rpx,
//                   padding: EdgeInsets.all(20 * rpx),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.near_me,
//                             color: Color(0xffa5dee4),
//                           ),
//                           Text(
//                             "自动定位：上海",
//                             style: TextStyle(color: Color(0xffa5dee4)),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             "切换",
//                             style: TextStyle(color: Color(0xffa5dee4)),
//                           ),
//                           Icon(
//                             Icons.arrow_right,
//                             color: Color(0xffa5dee4),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     controller: controller,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10 * rpx),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Flexible(
//                             flex: 1,
//                             child: WaterFallList(
//                               dataList: provider.model1,
//                               controller: controller,
//                             ),
//                           ),
//                           Flexible(
//                             flex: 1,
//                             child: WaterFallList(
//                               dataList: provider.model2,
//                               controller: controller,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//   }
// }
//
// class WaterFallList extends StatelessWidget {
//   const WaterFallList({Key key, this.dataList, this.controller})
//       : super(key: key);
//
//   final List<PostsModel> dataList;
//   final ScrollController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     double rpx = MediaQuery.of(context).size.width / 750;
//     return ListView.builder(
//       controller: controller,
//       shrinkWrap: true,
//       itemCount: dataList.length,
//       itemBuilder: (context, index) {
//         PostsModel curPosts = dataList[index];
//         return Column(
//           children: <Widget>[
//             Stack(
//               children: [
//                 Container(
//                     width: 365 * rpx,
//                     height: 365 * 1 * rpx,
//                     padding: EdgeInsets.symmetric(horizontal: 2 * rpx),
//                     child: Image.network(
//                       "https://10.2.12.154:8088/1.jpg",
//                       fit: BoxFit.fitWidth,
//                     )),
//                 Positioned(
//                   bottom: 0,
//                   width: 365 * rpx,
//                   height: 80 * rpx,
//                   child: Container(
//                       padding: EdgeInsets.all(10 * rpx),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.near_me),
//                               Text("1km"),
//                             ],
//                           ),
//                           Container(
//                             width: 60 * rpx,
//                             height: 60 * rpx,
//                             child: CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                   "https://10.2.12.154:8088/1.jpg"),
//                             ),
//                           )
//                         ],
//                       )),
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
// }
