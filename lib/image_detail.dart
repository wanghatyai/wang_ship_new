import 'dart:io';
import 'package:flutter/material.dart';

class ImageDetailPage extends StatefulWidget {

  File imageFile;
  ImageDetailPage({Key key, this.imageFile}) : super(key: key);

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.file(widget.imageFile)
    );
  }
}