import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

bool isDataUri(String ref) => ref.startsWith('data:');

ImageProvider<Object> resolveImage(String ref) {
  if (isDataUri(ref)) {
    final bytes = base64Decode(ref.split(',').last.trim());
    return MemoryImage(bytes);
  }
  return AssetImage(ref);
}

Image imageOrAsset(String ref, {double? height, BoxFit fit = BoxFit.fill}) {
  return Image(image: resolveImage(ref), height: height, fit: fit);
}

Future<String?> pickImageBase64({int maxDim = 1024, int quality = 82}) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );
  if (result == null || result.files.isEmpty) {
    return null;
  }
  final bytes = result.files.single.bytes;
  if (bytes == null) {
    return null;
  }
  return compressToDataUri(bytes, maxDim: maxDim, quality: quality);
}

String compressToDataUri(
  Uint8List bytes, {
  int maxDim = 1024,
  int quality = 82,
}) {
  Uint8List out = bytes;
  try {
    final decoded = img.decodeImage(bytes);
    if (decoded != null) {
      var resized = decoded;
      if (decoded.width > maxDim || decoded.height > maxDim) {
        final w = decoded.width >= decoded.height ? maxDim : null;
        final h = w == null ? maxDim : null;
        resized = img.copyResize(decoded, width: w, height: h);
      }
      out = Uint8List.fromList(img.encodeJpg(resized, quality: quality));
    }
  } catch (_) {
    // fallback to raw bytes if decoding fails
  }
  return 'data:image/jpeg;base64,${base64Encode(out)}';
}