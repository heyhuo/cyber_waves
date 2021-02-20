import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cyber_waves/models/AnimeOriginalModel.dart';
import 'package:cyber_waves/providers/GeneratorProvider.dart';
import 'package:cyber_waves/wigets/AnimationWidget.dart';
import 'package:cyber_waves/wigets/CropImage.dart';
import 'package:cyber_waves/wigets/WrapPicList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cyber_waves/wigets/CropImage.dart';

import 'UploadPage.dart';

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
  GeneratorProvider generatorProvider;
  var imgBytesList;
  var height;
  var hr;
  var ur;
  TFRunModel tfModel;
  double rpx;
  List picList;

  // Status status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ur = 1.2;
    rpx = widget.rpx;
  }

  @override
  Widget build(BuildContext context) {
    generatorProvider = Provider.of<GeneratorProvider>(context);
    imgBytesList = generatorProvider.imageBytesList;

    height = MediaQuery.of(context).size.height;
    hr = height / 3;
    tfModel = TFRunModel(generatorProvider);
    return Container(
      width: 750 * widget.rpx,
      height: height,
      color: Colors.black.withOpacity(0.5),
      child: Stack(
        children: [
          Container(
              width: 750 * widget.rpx,
              // height: ,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg2.jpg"),
                    fit: BoxFit.fitHeight),
                color: Colors.white.withOpacity(0.6),
              )),
          /*上层*/
          Column(
            children: [
              /*标题栏*/
              Container(
                height: 160 * rpx,
                color: Colors.black.withOpacity(0.5),
                // margin: EdgeInsets.only(top: 30),
                child: Container(
                  margin: EdgeInsets.only(top: 45 * rpx),
                  child: ListTile(
                    title: Center(
                        child: Text(
                      "",
                      style: TextStyle(color: Colors.white),
                    )),
                    leading: Container(
                      width: 200 * rpx,
                      height: 70 * rpx,
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            // color: Colors.yellow,
                            width: 60 * rpx,
                            child: IconButton(
                                highlightColor: Colors.white,
                                icon: Icon(Icons.arrow_back_ios,
                                    color: Colors.grey.shade400),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          Container(
                            width: 140 * rpx,
                            // color: Colors.yellow,
                            child: Text(
                              "返回",
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    /*trailing: Container(
                      width: 160 * rpx,
                      height: 74 * rpx,
                      decoration: BoxDecoration(
                          color: Colors.green.shade600.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 60 * rpx,
                            // height: 80*rpx,
                            // color: Colors.red,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_circle_up_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                              width: 80 * rpx,
                              // margin: EdgeInsets.only(left: 0),
                              // color: Colors.yellow,
                              child: Text(
                                "发布",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ))
                        ],
                      ),
                    ),*/
                  ),
                ),
              ),
              /*展示栏*/
              Container(
                  width: 750 * widget.rpx,
                  height: hr * (ur - 0.3),
                  color: Colors.black.withOpacity(0.4),
                  child: Stack(
                    children: [
                      /*图片*/
                      Positioned(
                        // top: 20,
                        left: 0,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 40,
                          ),
                          width: 750 * widget.rpx,
                          height: hr * (ur - 0.3),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2)),
                          child: Container(
                              child: ShowAnime(model: generatorProvider.showModel)),
                        ),
                      ),
                      /*画框*/
                      Visibility(
                        visible: (generatorProvider.showModel==null||generatorProvider.showModel.generateTag==0)?true:false,
                        child: Positioned(
                          bottom: 0,
                          left: 90,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.redAccent.withOpacity(0.5),
                                      width: 3)),
                              child: CustomPaint(
                                size: Size(400 * rpx, 400 * rpx),
                                painter: ImageCropPainter(rpx),
                              )),
                        ),
                      ),
                    ],
                  )),
              /*贴纸栏*/
              Container(
                height: hr * (3 - ur) + 3,
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  children: [
                    /*功能按钮*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _generateBtn(
                          Icons.animation,
                          "生成",
                        ),
                        _generateBtn(Icons.photo_outlined, "设置背景图"),
                        _generateBtn(Icons.color_lens_outlined, "设置颜色"),
                        _generateBtn(Icons.emoji_emotions_outlined, "动画"),
                        /*Container(
                          width: 100,
                          height: 100,
                          // color: Colors.yellow,
                          child: IconButton(
                            icon: Icon(
                              Icons.emoji_emotions_sharp,
                              color: Colors.white,
                              size: 50,
                            ),
                            onPressed: () {
                              // provider.readFile(provider.fileName);
                            },
                          ),
                        ),*/
                      ],
                    ),
                    Container(
                      height: hr * (3 - ur) - 80,
                      child: SingleChildScrollView(
                          child: WrapPicList(generatorProvider,null,rpx)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          /*加载中*/
          Visibility(
            visible: generatorProvider.isGenerating,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                    backgroundColor: Colors.blue,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _generateBtn(icon, tag) {
    return Container(
      width: 60,
      height: 80,
// color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            child: IconButton(
              icon: Icon(
                icon,
                // semanticLabel: tag,
                //Icons.check_circle_outline,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                if (tag == "生成")
                  _runModel();
                else if (tag == "动画") {
                  generatorProvider.readFile(
                      generatorProvider.showModel.userId, generatorProvider.showModel.animeId);
                }
              },
            ),
          ),
          Container(
              width: 100,
              // color: Colors.yellow,
              child: Text(
                tag,
                style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }

  Interpreter _interpreter;
  bool useGpu = false;

  Future _loadModel() async {
// 模型文件的名称
    final _modelFile = 'models/morpher_gpu_32.tflite'; //不要加assets/

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
      var interpreterOptions = InterpreterOptions()
// ..useNnApiForAndroid = true
        ..threads = 4;
      _interpreter =
          await Interpreter.fromAsset(_modelFile, options: interpreterOptions);
    }

    print('Interpreter loaded successfully');

// 加载张量
    _interpreter.allocateTensors();
/*// 打印 input tensor 列表
    print(_interpreter.getInputTensors());
    // 打印 output tensor 列表
    print(_interpreter.getOutputTensors());*/
  }

  Future _runModel() async {
    if (_interpreter == null) _loadModel();
    generatorProvider.setGenerating();

    var animeId = generatorProvider.showModel.animeId;
    var userId = generatorProvider.showModel.userId;
    var name = generatorProvider.showModel.animePath;

    var imageBytes = (await /*rootBundle.load(name)*/File(name).readAsBytes()).buffer.asUint8List();
    img.Image oriImage = img.decodePng(imageBytes);
//这个裁剪对画质有影响
    img.Image resizedImage = img.copyResize(oriImage,
        height: 256, width: 256, interpolation: img.Interpolation.linear);

// Bitmap.
    var imgBytes =
        imageToByteListFloat32(resizedImage).reshape([1, 4, 256, 256]);

    var totalTime = 0.0;
    for (var i = 0; i < generatorProvider.epcho; i++) {
      var morParam = [i / 10, i / 10, i / 10].reshape([1, 3]);
      var inputs = [imgBytes, morParam];
      var output0 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
      var output1 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
      var outputs = {0: output0, 1: output1};
      int startTime = new DateTime.now().millisecondsSinceEpoch;
      _interpreter.runForMultipleInputs(inputs, outputs);
      int endTime = new DateTime.now().millisecondsSinceEpoch;
      var takeTime = (endTime - startTime) / 1000;
      totalTime += takeTime;
      print("Inference times:${i},took ${takeTime}s,totalTime:${totalTime}s");

      generatorProvider.addJsonStr(morParam[0], output0);
    }
    // _interpreter.close();

    await generatorProvider.writeFile(userId, animeId);

    generatorProvider.updateGenerateTag(userId, animeId);
    generatorProvider.setGenerating();
  }

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
      }
    }
    return buffer.buffer.asFloat32List();
  }

  double srgbToLinear(int pixel, bool isAlpha) {
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

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}

class ShowGenerate extends StatelessWidget {
  const ShowGenerate({Key key, this.rpx}) : super(key: key);
  final rpx;

  @override
  Widget build(BuildContext context) {
    GeneratorProvider provider = Provider.of<GeneratorProvider>(context);
    var outList = provider.imageBytesList;
    if (outList == null || outList.length == 0) return Container();
    var len = outList.length;
    var list = List<Uint8List>();
    for (var i = 0; i < len; i++) {
      Uint8List uint8list =
          Uint8List.fromList(outList[i]["bitmap"].cast<int>());
      list.add(uint8list);
    }
    return ImagesAnimation(
      list,
      w: 256,
      h: 256,
    );
    /*Column(
      children: List.generate(len, (index) {
        Uint8List list =
            Uint8List.fromList(outList[index]["bitmap"].cast<int>());
        return Container(
            margin: EdgeInsets.only(top: 30 * rpx), child: Image.memory(list));
      }),
    );*/
  }
}

class GenerateBtn extends StatelessWidget {
  const GenerateBtn(this.icon, this.tag, {Key key, this.func, this.tfModel})
      : super(key: key);

  final IconData icon;
  final String tag;
  final VoidCallback func;
  final TFRunModel tfModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
// color: Colors.yellow,
      child: IconButton(
        icon: Icon(
          icon,
          semanticLabel: tag,
          //Icons.check_circle_outline,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          tfModel.runModel();
        },
      ),
    );
  }
}

class TFRunModel {
  var provider;
  Interpreter _interpreter;
  bool useGpu;

  TFRunModel(this.provider, {this.useGpu = false});

  Future loadModel() async {
// 模型文件的名称
    final _modelFile = 'models/morpher_gpu_32.tflite'; //不要加assets/

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
      var interpreterOptions = InterpreterOptions()
// ..useNnApiForAndroid = true
        ..threads = 4;
      _interpreter =
          await Interpreter.fromAsset(_modelFile, options: interpreterOptions);
    }

    print('Interpreter loaded successfully');

// 加载张量
    _interpreter.allocateTensors();
/*// 打印 input tensor 列表
    print(_interpreter.getInputTensors());
    // 打印 output tensor 列表
    print(_interpreter.getOutputTensors());*/
  }

  Future runModel() async {
    if (_interpreter == null) loadModel();

    var imagePath = provider.showImagePath;
    var imageBytes = (await rootBundle.load(imagePath)).buffer.asUint8List();
    img.Image oriImage = img.decodePng(imageBytes);
//这个裁剪对画质有影响
    img.Image resizedImage = img.copyResize(oriImage,
        height: 256, width: 256, interpolation: img.Interpolation.linear);

// Bitmap.
    var imgBytes =
        imageToByteListFloat32(resizedImage).reshape([1, 4, 256, 256]);

    var totalTime = 0.0;
    for (var i = 0; i < provider.epcho; i++) {
      var morParam = [i / 10, i / 10, i / 10].reshape([1, 3]);
      var inputs = [imgBytes, morParam];
      var output0 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
      var output1 = List(1 * 4 * 256 * 256).reshape([1, 4, 256, 256]);
      var outputs = {0: output0, 1: output1};
      int startTime = new DateTime.now().millisecondsSinceEpoch;
      _interpreter.runForMultipleInputs(inputs, outputs);
      int endTime = new DateTime.now().millisecondsSinceEpoch;
      var takeTime = (endTime - startTime) / 1000;
      totalTime += takeTime;
      print("Inference times:${i},took ${takeTime}s,totalTime:${totalTime}s");

      provider.addJsonStr(morParam[0], output0);
    }
    // _interpreter.close();

    await provider.writeFile(provider.fileName);
    await provider.readFile(provider.fileName);
  }

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
      }
    }
    return buffer.buffer.asFloat32List();
  }

  double srgbToLinear(int pixel, bool isAlpha) {
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
}

class ShowAnime extends StatelessWidget {
  const ShowAnime({Key key, this.model}) : super(key: key);
  final AnimeOriginalModel model;

  @override
  Widget build(BuildContext context) {
    if (model == null)
      return Icon(
        Icons.insert_emoticon,
        size: 120,
        color: Colors.white.withOpacity(0.5),
      );
    else if (model.generateTag == 0)
      return Container(
        child: Image.file(
          File(model.animePath),
          fit: BoxFit.fitHeight,
        ),
      );
    else
      return Container(child: Center(child: ShowGenerate()));
  }
}
