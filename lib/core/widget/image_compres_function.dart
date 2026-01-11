import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

//comprees
Future<MultipartFile> createImageFromFile(String imagePath) async {
  // Ensure the file exists at the specified path
  final file = File(imagePath);
  if (!await file.exists()) {
    throw Exception('File does not exist at $imagePath');
  }

  try {
    // Compress the image
    final compressedImage = await _compressImage(file);

    // Get the directory to store the compressed image
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/compressed_image.jpg');

    // Save the compressed image to the temp directory
    await tempFile.writeAsBytes(compressedImage);

    // Return the MultipartFile for the compressed image
    return await MultipartFile.fromFile(
      tempFile.path,
      filename: file.uri.pathSegments.last,
    );
  } catch (e) {
    throw Exception('Error creating image from file: $e');
  }
}

Future<List<int>> _compressImage(File file) async {
  final result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    minWidth: 800, // Optional: Set the desired width after compression
    minHeight: 600, // Optional: Set the desired height after compression
    quality: 80, // Optional: Set the compression quality (0-100)
    rotate: 0, // Optional: Set image rotation (if needed)
  );

  if (result == null) {
    throw Exception('Error compressing image');
  }

  return result;
}
