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