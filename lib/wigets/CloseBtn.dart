import 'package:flutter/material.dart';

class CloseBtn extends StatelessWidget {
  const CloseBtn(
      {Key key, this.rpx, this.radius, this.size, this.bgColor, this.iconColor})
      : super(key: key);
  final double rpx;
  final double radius;
  final double size;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: 10 * rpx),
      child: CircleAvatar(
        radius: radius * rpx,
        child: Icon(
          Icons.close,
          color: iconColor,
          size: size * rpx,
        ),
        backgroundColor: bgColor,
      ),
    );
  }
}