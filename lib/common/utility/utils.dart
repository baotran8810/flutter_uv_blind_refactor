import 'package:get/get.dart';

T putPermanent<T>(T dependency) {
  return Get.put<T>(dependency, permanent: true);
}

String getMediaType(String filename) {
  final dot = filename.lastIndexOf('.');
  if (dot != -1) {
    final fileType = filename.substring(dot + 1);
    final mediaType = mediaTypes[fileType];
    if (mediaType != null) {
      return mediaType;
    }
  }
  return "application/octet-stream";
}

const Map<String, String> mediaTypes = {
  "dart": "application/dart",
  "js": "application/javascript",
  "html": "text/html; charset=UTF-8",
  "htm": "text/html; charset=UTF-8",
  "css": "text/css",
  "txt": "text/plain",
  "json": "application/json",
  "ico": "image/vnd.microsoft.icon",
  "png": "image/png",
  "jpg": "image/jpeg",
  "jpeg": "image/jpeg",
  "ogg": "audio/ogg",
  "ogv": "video/ogg",
  "mp3": "audio/mpeg",
  "mp4": "video/mp4",
  "pdf": "application/pdf"
};
