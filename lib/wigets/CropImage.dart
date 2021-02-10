import 'package:flutter/material.dart';

class ImageCropPainter extends CustomPainter {
  final double rpx;

  ImageCropPainter(this.rpx);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    //画背景
    var paint = Paint()
      ..isAntiAlias = false
      ..strokeWidth = 2.0
      ..color = Colors.green.withOpacity(0.5);

    var paint1 = Paint()
      ..isAntiAlias = false
      ..strokeWidth = 2.0
      ..color = Colors.blue.withOpacity(0.5);

    var l1_dy = (size.height / 4.1);
    var l2_dy = (size.height / 4.1) * 3;
    var l12_dx = size.width;
    var l3_dx = size.width / 2;

    canvas.drawLine(
        Offset(0.0, l1_dy), Offset(l12_dx, l1_dy), paint..strokeCap);
    canvas.drawLine(
        Offset(0.0, l2_dy), Offset(l12_dx, l2_dy), paint..strokeCap);
    canvas.drawLine(
        Offset(l3_dx, 0.0), Offset(l3_dx, size.height), paint1..strokeCap);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
