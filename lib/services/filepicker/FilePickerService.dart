import 'dart:io';

import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;

/*
* Android hack
* This is hack service. Image picker does not work on Android from webview (on iOS it works out of the box).
* I had to make this hack. Thanks to https://github.com/flutter/flutter/issues/118836
* This is until Flutter team fixes webview
* */
class FilePickerService {
  Future<List<String>> androidFilePicker(webview_flutter_android.FileSelectorParams params) async {
    if (params.acceptTypes.any((type) => type == 'image/*')) {
      final picker = image_picker.ImagePicker();
      final photo = await picker.pickImage(source: image_picker.ImageSource.gallery);

      if (photo == null) {
        return [];
      }

      final imageData = await photo.readAsBytes();
      final decodedImage = image.decodeImage(imageData)!;
      final scaledImage = image.copyResize(decodedImage, width: 500);
      final jpg = image.encodeJpg(scaledImage, quality: 90);

      final filePath = (await getTemporaryDirectory()).uri.resolve(
            './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
          );
      final file = await File.fromUri(filePath).create(recursive: true);
      await file.writeAsBytes(jpg, flush: true);

      return [file.uri.toString()];
    }

    return [];
  }
}
