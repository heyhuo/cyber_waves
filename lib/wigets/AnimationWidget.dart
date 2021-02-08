// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
//
// class AnimationWidget extends StatefulWidget {
//   final List<Uint8List> imageList;
//   final double width;
//   final double height;
//   bool start = true;
//   int interval = 50;
//
//   AnimationWidget(this.imageList,
//       {Key key, this.width, this.height, this.interval, this.start})
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
//     final int imageCount = widget.imageList.length;
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
//     int ix = _animation.value.floor() % widget.imageList.length;
//
//     List<Widget> images = [];
//     // 把所有图片都加载进内容，否则每一帧加载时会卡顿
//     for (int i = 0; i < widget.imageList.length; ++i) {
//       if (i != ix) {
//         images.add(Image.memory(
//           widget.imageList[i],
//           // width: 0,
//           // height: 0,
//         ));
//       }
//     }
//
//     images.add(Image.memory(
//       widget.imageList[ix],
//       width: widget.width,
//       height: widget.height,
//     ));
//
//     return Stack(alignment: AlignmentDirectional.center, children: images);
//   }
// }

import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagesAnimation extends StatefulWidget {
  const ImagesAnimation(this.uint8List,
      {Key key,
      this.w: 256,
      this.h: 256,
      this.entry,
      this.durationSeconds: 300})
      : super(key: key);
  final double w;
  final double h;
  final List<Uint8List> uint8List;
  final ImagesAnimationEntry entry;
  final int durationSeconds;

  @override
  _ImagesAnimationState createState() => _ImagesAnimationState();
}

class _ImagesAnimationState extends State<ImagesAnimation>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> _animation;
  bool isStart = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.durationSeconds));
    if(isStart) _controller = _controller..repeat();
    _animation = IntTween(
            begin: 0 /*widget.entry.lowIndex*/,
            end: widget.uint8List.length - 1 /*widget.entry.highIndex*/)
        .animate(_controller);
    // _animation = ;
    //widget.entry.lowIndex 表示从第几下标开始，如0；widget.entry.highIndex表示最大下标：如7
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: widget.w,
      // height: widget.h,
      // color: Colors.blue,
      child: Stack(
        children: [
          AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget child) {
                int frame = _animation.value;
                return Image.memory(
                  widget.uint8List[frame],
                  /*sprintf(widget.entry.basePath, [frame]),*/ //根据传进来的参数拼接路径
                  gaplessPlayback: true, //避免图片闪烁
                  width: widget.w,
                  height: widget.h,
                );
              }),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.8)),
              // color: Colors.yellow,
              child: IconButton(
                  // alignment: Alignment.topLeft,
                  icon: Icon(
                    !isStart ? Icons.play_arrow : Icons.pause_sharp,
                    color: Colors.black.withOpacity(0.8),
                    size: 30,
                  ),
                  onPressed: () {
                    isStart ? _controller.stop() : _controller.repeat();
                    setState(() {
                      isStart = !isStart;
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _controller.stop();
    super.dispose();

  }
}

class ImagesAnimationEntry {
  int lowIndex = 0;
  int highIndex = 0;
  String basePath;

  ImagesAnimationEntry(this.lowIndex, this.highIndex, this.basePath);
}
