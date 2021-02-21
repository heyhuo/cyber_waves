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
