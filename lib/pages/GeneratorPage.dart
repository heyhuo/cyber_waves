import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cyber_waves/providers/GeneratorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:bitmap/bitmap.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({Key key}) : super(key: key);

  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Generator(rpx: MediaQuery.of(context).size.width / 750),
    );
  }
}

class Generator extends StatefulWidget {
  const Generator({Key key, @required this.rpx}) : super(key: key);
  final double rpx;

  @override
  _GeneratorState createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  GeneratorProvider provider;
  var imgBytes;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<GeneratorProvider>(context);
    imgBytes = provider.imageBytes;

    return Container(
      width: 750 * widget.rpx,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Column(
        children: [
          Container(
              width: 750 * widget.rpx,
              height: 750 * widget.rpx,
              // color: Colors.black,
              child: Stack(
                children: [
                  imgBytes == null
                      ? Container(
                          width: 300,
                          height: 300,
                          color: Colors.greenAccent,
                        )
                      : Center(
                          child: Container(
                              width: 400 * widget.rpx,
                              height: 400 * widget.rpx,
                              child: Image.memory(imgBytes)),
                        ),
                  Positioned(
                      bottom: 0,
                      left: 100 * widget.rpx,
                      child: IconButton(
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _loadModel(false);
                        },
                      ) /*Container(
                      width: 100 * widget.rpx,
                      height: 100 * widget.rpx,
                      color: Colors.yellow,
                      child:
                    ),*/
                      )
                ],
              ))
        ],
      ),
    );
  }

  Future _loadModel(useGpu) async {
    // 模型文件的名称
    final _modelFile = 'models/morpher_gpu_32.tflite'; //不要加assets/

    Interpreter _interpreter;
    if (useGpu) {
      final gpuDelegateV2 = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
        false,
        TfLiteGpuInferenceUsage.fastSingleAnswer,
        TfLiteGpuInferencePriority.minLatency,
        TfLiteGpuInferencePriority.auto,
        TfLiteGpuInferencePriority.auto,
      ));
      var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegateV2);
      _interpreter =
          await Interpreter.fromAsset(_modelFile, options: interpreterOptions);
    } else {
      // var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
      _interpreter = await Interpreter.fromAsset(_modelFile);
    }

    print('Interpreter loaded successfully');

    // 加载张量
    _interpreter.allocateTensors();
    // 打印 input tensor 列表
    print(_interpreter.getInputTensors());
    // 打印 output tensor 列表
    print(_interpreter.getOutputTensors());

    var name = "assets/waifus/higu-0-0-0.png";
    var bytes = await new FileUtil().loadFileAsBytes(name);

    var imageBytes = (await rootBundle.load(name)).buffer.asUint8List();
    img.Image oriImage = img.decodePng(imageBytes);
    img.Image resizedImage = img.copyResize(oriImage, height: 256, width: 256);

    var imgBytes =
        imageToByteListFloat32(resizedImage).reshape([1, 4, 256, 256]);

    // provider.setImage(DecodeBitmapToImage(imgBytes));

    var morParam = [0.0, 1.0, 0.5].reshape([1, 3]);

    // input: List<Object>
    var inputs = [imgBytes, morParam];

    var output0 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
    var output1 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
    // output: Map<int, Object>
    var outputs = {0: output0, 1: output1};

    // for (var i = 0; i < 10; i++) {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    // inference
    _interpreter.runForMultipleInputs(inputs, outputs);
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${(endTime - startTime) / 1000}s");
    // print outputs
    provider.setImage(DecodeBitmapToImage(outputs[0], true));
    print(outputs);
  }

// print(imageBytes);

  Float32List imageToByteListFloat32(
    img.Image image,
  ) {
    var inputSize = 256;
    var len = inputSize * inputSize;
    var convertedBytes = Float32List(1 * inputSize * inputSize * 4);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);

        var red = srgbToLinear(img.getRed(pixel), false);
        var green = srgbToLinear(img.getGreen(pixel), false);
        var blue = srgbToLinear(img.getBlue(pixel), false);
        var alpha = srgbToLinear(img.getAlpha(pixel), true);

        buffer[pixelIndex] = red;
        buffer[len + pixelIndex] = green;
        buffer[len * 2 + pixelIndex] = blue;
        buffer[len * 3 + pixelIndex] = alpha;
        pixelIndex++;
        /*buffer[pixelIndex++] = red;
        buffer[pixelIndex++] = green;
        buffer[pixelIndex++] = blue;
        buffer[pixelIndex++] = alpha;*/
      }
    }
    return buffer.buffer.asFloat32List();
  }

  srgbToLinear(int pixel, bool isAlpha) {
    var p = pixel / 255.0;

    if (p < 0.0)
      p = 0.0;
    else if (p > 1.0) p = 1.0;

    if (!isAlpha) {
      if (p <= 0.04045)
        p /= 12.92;
      else
        p = pow(((p + 0.055) / 1.055), 2.4);
    }

    p = p * 2 - 1;

    return p;
  }

  int linearToSrgb(pixel, bool isAlpha) {
    var x = pixel;
    if (!isAlpha) x = (x + 1.0) * 0.5;

    if (x < 0.0)
      x = 0;
    else if (x > 1.0) x = 1.0;

    if (!isAlpha) {
      if (x <= 0.003130804953560372) {
        x *= 12.92;
      } else {
        x = 1.055 * pow(x, 1.0 / 2.4) - 0.055;
      }
    }

    return (x * 255.0).toInt();
  }

  Uint8List DecodeBitmapToImage(imgBytes, bool isReshape) {
    // bitmap.
    var inputSize = 256;
    var len = inputSize * inputSize;
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 4);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    int idx = 0;

    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var r, g, b, a;
        if (!isReshape) {
          r = imgBytes[pixelIndex];
          g = imgBytes[len + pixelIndex];
          b = imgBytes[len * 2 + pixelIndex];
          a = imgBytes[len * 3 + pixelIndex];
          pixelIndex++;
        } else {
          r = imgBytes[0][0][i][j];
          g = imgBytes[0][1][i][j];
          b = imgBytes[0][2][i][j];
          a = imgBytes[0][3][i][j];
        }
        var red = linearToSrgb(r, false);
        var green = linearToSrgb(g, false);
        var blue = linearToSrgb(b, false);
        var alpha = linearToSrgb(a, true);

        buffer[idx++] = red;
        buffer[idx++] = green;
        buffer[idx++] = blue;
        buffer[idx++] = alpha;
      }
    }

    Bitmap bitmap = Bitmap.fromHeadless(256, 256, buffer.buffer.asUint8List());
    Uint8List headedBitmap = bitmap.buildHeaded();

    return headedBitmap;
  }
}
