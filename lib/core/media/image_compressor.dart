import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../error/exceptions.dart';

/// Turns a picked image file into an upload-ready multipart part.
///
/// SRP: this is *infrastructure* — file I/O, compression, temp directories. It
/// has no business in a cubit, yet `LoginCubit` currently does all of it inline
/// (`_createMultipartFile` / `_compressImage`, lines 537-562), alongside login,
/// three registration flows, JWT decoding, and token persistence.
///
/// DIP: an interface, so a data source depending on it can be tested with a
/// stub instead of touching the filesystem.
abstract interface class ImageCompressor {
  /// Compresses the image at [path] and wraps it for upload.
  ///
  /// Throws [CacheException] if the file is missing or cannot be compressed.
  Future<MultipartFile> toCompressedMultipart(String path);
}

@LazySingleton(as: ImageCompressor)
class FlutterImageCompressor implements ImageCompressor {
  const FlutterImageCompressor();

  static const int _minWidth = 800;
  static const int _minHeight = 600;
  static const int _quality = 80;
  static const String _missingFileMessage = 'ملف الصورة غير موجود';
  static const String _compressionFailedMessage = 'تعذر ضغط الصورة';

  @override
  Future<MultipartFile> toCompressedMultipart(String path) async {
    final File source = File(path);
    if (!await source.exists()) {
      throw const CacheException(message: _missingFileMessage);
    }
    final File compressed = await _writeCompressedCopy(source);
    return MultipartFile.fromFile(
      compressed.path,
      filename: _fileNameOf(compressed),
    );
  }

  Future<File> _writeCompressedCopy(File source) async {
    final List<int>? bytes = await FlutterImageCompress.compressWithFile(
      source.absolute.path,
      minWidth: _minWidth,
      minHeight: _minHeight,
      quality: _quality,
    );
    if (bytes == null) {
      throw const CacheException(message: _compressionFailedMessage);
    }
    final Directory tempDirectory = await getTemporaryDirectory();
    final File destination = File(
      '${tempDirectory.path}/${_uniqueName()}',
    );
    return destination.writeAsBytes(bytes);
  }

  String _fileNameOf(File file) => file.uri.pathSegments.last;

  String _uniqueName() =>
      'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
}
