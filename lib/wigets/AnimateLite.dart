// Future _loadModel(useGpu) async {
//   // 模型文件的名称
//   final _modelFile = 'morpher_gpu_32.tflite';
//
//   // final gpuDelegateV2 = GpuDelegateV2(
//   //     options: GpuDelegateOptionsV2(
//   //   false,
//   //   TfLiteGpuInferenceUsage.preferenceSustainSpeed,
//   //   TfLiteGpuInferencePriority.minLatency,
//   //   TfLiteGpuInferencePriority.auto,
//   //   TfLiteGpuInferencePriority.auto,
//   // ));
//
//   Interpreter _interpreter;
//   if (useGpu) {
//     // var interpreterOptions = InterpreterOptions()..addDelegate(gpuDelegateV2);
//     // var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
//
//     // TensorFlow Lite 解释器对象
//     // _interpreter =
//     // await Interpreter.fromAsset(_modelFile, options: interpreterOptions);
//   } else {
//     var interpreterOptions = InterpreterOptions()..useNnApiForAndroid = true;
//     _interpreter = await Interpreter.fromAsset(_modelFile,
//         options: InterpreterOptions()..threads = 3);
//   }
//
//   print('Interpreter loaded successfully');
//
//   // 加载张量
//   _interpreter.allocateTensors();
//   // 打印 input tensor 列表
//   print(_interpreter.getInputTensors());
//   // 打印 output tensor 列表
//   print(_interpreter.getOutputTensors());
//
//   var name = "assets/images/waifu_03_256.png";
//   var imageBytes = (await rootBundle.load(name)).buffer.asUint8List();
//   img.Image image = img.decodePng(imageBytes);
//
//   print(image.length);
//   var imgBytes = imageToByte(image, 256).reshape([1, 4, 256, 256]);
//   var morParam = [
//     [0.5, 0.5, 0.5]
//   ];
//
//   // input: List<Object>
//   var inputs = [imgBytes, morParam];
//
//   var output0 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
//   var output1 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
//   // output: Map<int, Object>
//   var outputs = {0: output0, 1: output1};
//
//   for (var i = 0; i < 10; i++) {
//     int startTime = new DateTime.now().millisecondsSinceEpoch;
//     // inference
//     _interpreter.runForMultipleInputs(inputs, outputs);
//     int endTime = new DateTime.now().millisecondsSinceEpoch;
//     print("Inference took ${endTime - startTime}");
//     // print outputs
//     print(outputs);
//   }
//
//   // print(imageBytes);
// }