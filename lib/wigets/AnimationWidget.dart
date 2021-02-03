// class AnimationWidget extends StatefulWidget {
//   final List<String> _assetList;
//   final double width;
//   final double height;
//   bool start = true;
//   int interval = 50;
//
//   AnimationWidget(Key key, this._assetList,
//       {this.width, this.height, this.interval, this.start})
//       : super(key: key);
//
//   @override
//   _AnimationWidgetState createState() => _AnimationWidgetState();
// }
//
// class _AnimationWidgetState extends State<AnimationWidget>
//     with SingleTickerProviderStateMixin<AnimationWidget> {
//   // 动画控制
//   AnimationController _controller;
//   Animation<double> _animation;
//   int i = 0;
//   int interval = 1000;
//
//   @override
//   // TODO: implement widget
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.interval != null) {
//       interval = widget.interval;
//     }
//     final int imageCount = widget._assetList.length;
//     final int maxTime = interval * imageCount;
//
//     // 动画管理类
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: maxTime),
//     );
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         // _controller.reverse();
//         // _controller.forward(from: 0.0); // 完成后重新开始
//       }
//     });
//     _animation = new Tween<double>(begin: 0, end: imageCount.toDouble())
//         .animate(_controller)
//       ..addListener(() {
//         setState(() {
//           // the state that has changed here is the animation object’s value
//         });
//       });
//     if (widget.start) {
//       _controller.forward();
//     }
//   }
//
//   void _update(AnimationStatus status) {
//     setState(() {
//       if (status == AnimationStatus.completed) {
//         _controller.forward(from: 0.0); // 完成后重新开始
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int ix = _animation.value.floor() % widget._assetList.length;
//
//     List<Widget> images = [];
//     // 把所有图片都加载进内容，否则每一帧加载时会卡顿
//     for (int i = 0; i < widget._assetList.length; ++i) {
//       if (i != ix) {
//         images.add(Image.asset(
//           widget._assetList[i],
//           width: 0,
//           height: 0,
//         ));
//       }
//     }
//
//     images.add(Image.asset(
//       widget._assetList[ix],
//       width: widget.width,
//       height: widget.height,
//     ));
//
//     return Stack(alignment: AlignmentDirectional.center, children: images);
//   }
// }