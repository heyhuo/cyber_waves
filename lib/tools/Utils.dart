import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
class Utils extends Object {
  Utils();

  //fileExt 文件后缀名
  static MediaType getMediaType(final String fileExt) {
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return new MediaType("image", "jpeg");
      case ".png":
        return new MediaType("image", "png");
      case ".bmp":
        return new MediaType("image", "bmp");
      case ".gif":
        return new MediaType("image", "gif");
      case ".json":
        return new MediaType("application", "json");
      case ".svg":
      case ".svgz":
        return new MediaType("image", "svg+xml");
      case ".mp3":
        return new MediaType("audio", "mpeg");
      case ".mp4":
        return new MediaType("video", "mp4");
      case ".mov":
        return new MediaType("video", "mov");
      case ".htm":
      case ".html":
        return new MediaType("text", "html");
      case ".css":
        return new MediaType("text", "css");
      case ".csv":
        return new MediaType("text", "csv");
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return new MediaType("text", "plain");
    }
    return null;
  }

  static getFormatDateTimeNow(rex, {type = "Date"}) {
    var dateString = DateFormat(rex).format(DateTime.now());
    if (type == "Date") return DateTime.parse(dateString);
    return dateString;
  }

  static String getMusicId(url) {
    if (url == null) return null;
    url.startsWith("song");
    int start = url.indexOf("song");
    int end = url.indexOf("user");
    var musicId = url.substring(start + 5, end - 2);
    return musicId;
  }

 static String getImageBlurhash(List<int> imageData) {
    img.Image image = img.decodeImage(imageData.toList());
    img.Image thumbnail = img.copyResize(image, width: 100,height: 100);
    final blurHash = encodeBlurHash(
      thumbnail.getBytes(format: img.Format.rgba),
      thumbnail.width,
      thumbnail.height,
    );
    return blurHash;
  }
}
