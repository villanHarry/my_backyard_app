import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  PhotoViewScreen({Key? key, this.path}) : super(key: key);
  String? path;

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: NetworkImage(path.toString()),
    );
  }
}
