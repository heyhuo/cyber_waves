// import 'dart:io';
//
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
// import 'package:image/image.dart';
//
// void getInterpreter() async {
//   print("--测试模型--");
//   // final gpuDelegateV2 = GpuDelegateV2(
//   //     options: GpuDelegateOptionsV2(
//   //   false,
//   //   TfLiteGpuInferenceUsage.fastSingleAnswer,
//   //   TfLiteGpuInferencePriority.minLatency,
//   //   TfLiteGpuInferencePriority.auto,
//   //   TfLiteGpuInferencePriority.auto,
//   // ));
//
//   // var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegateV2);
//   final interpreter = await Interpreter.fromAsset('morpher_gpu_32.tflite');//,ptions: interpreterOptions
//
//   // Create a TensorImage object from a File
//   File img_in = File('images/Ritsuki_Sakura.png');
//   TensorImage tensorImage = TensorImage.fromFile(img_in);
//
//   var input0 = [1.23];
//   var input1 = [[0.8,0.8,0.8]];
//   // input: List<Object>
//   var inputs = [input0, input1];
//
//   var output0 = List<double>(1*4*256*256).reshape([1,4,256,256]);
//   var output1 = List<double>(1*4*256*256).reshape([1,4,256,256]);
//   // output: Map<int, Object>
//   var outputs = {0: output0, 1: output1};
//
//   // inference
//   interpreter.runForMultipleInputs(inputs, outputs);
//
//   // print outputs
//   print(outputs);
//
// }
//
//
//
// /*class _getModel extends StatelessWidget {
//   const _getModel({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:,
//     );
//   }
// }*/

// Float32List imageToByte(img.Image image, int inputSize) {
//   var float32list = Float32List(inputSize * inputSize * 4);
//   var buffer = Float32List.view(float32list.buffer);
//   int pidx = 0;
//   double mean = 0, std = 255.0;
//   for (var i = 0; i < inputSize; i++) {
//     for (var j = 0; j < inputSize; j++) {
//       var pixel = image.getPixel(j, i);
//
//       buffer[256 * i + j] = (img.getRed(pixel) - mean) / std;
//       buffer[256 * i + j + 256] = (img.getGreen(pixel) - mean) / std;
//       buffer[256 * i + j + 512] = (img.getBlue(pixel) - mean) / std;
//       buffer[256 * i + j + 768] = (img.getAlpha(pixel) - mean) / std;
//     }
//   }
//
//   var imgBytes = float32list.buffer.asFloat32List();
//   print(imgBytes[25700]);
//   return imgBytes;
// }

// _getDecodeImg() async {
//   // File im = File(name);
//   // img.Image.f
//   var imageBytes = (await rootBundle.load(name)).buffer.asUint8List();
//   // var bImage = img.Image.fromBytes(256, 256, imageBytes, format: img.Format.argb);
//
//   img.Image image = img.decodePng(imageBytes);
//   //
//   print(image.length);
//   var imgBytes = imageToByte(image, 256);
//
//   setState(() {
//     // setState_bytes = imgBytes;
//     // _ss = bImage;
//   });
// }