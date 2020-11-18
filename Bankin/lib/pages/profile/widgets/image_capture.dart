import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageCapture extends StatefulWidget {
  final CropStyle cropStyle;
  final String path;
  final callback;
  ImageCapture({this.cropStyle, this.callback, this.path});
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File imageFile;
  List<Offset> _points = <Offset>[];
  Color drawingColor = Colors.deepPurple;
  bool drawing = false;
  bool showColor = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> cropImage(context) async {
    File cropped = await ImageCropper.cropImage(
        cropStyle: widget.cropStyle,
        sourcePath: imageFile.path,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          toolbarTitle: 'Edit',
          statusBarColor: Colors.black,
          activeControlsWidgetColor: Colors.deepPurple,
        ));

    setState(() {
      imageFile = cropped ?? imageFile;
    });
  }

  Future<void> pickImage(ImageSource source) async {
    File selected =
        await ImagePicker.pickImage(source: source, imageQuality: 20);

    setState(() {
      imageFile = selected;
    });
  }

  void clear(context) async {
    setState(() {
      imageFile = null;
      _points.clear();
      drawing = false;
    });
  }

  AnimatedOpacity animatedButton(context, function, {Icon icon}) {
    return AnimatedOpacity(
      opacity: imageFile != null ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: IconButton(
        iconSize: 30,
        icon: icon,
        onPressed: () {
          function(context);
        },
      ),
    );
  }

  AnimatedOpacity revertAnimatedButton(
      {ImageSource source, Icon icon, bool isVideo}) {
    return AnimatedOpacity(
        opacity: imageFile == null ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: IconButton(
            icon: icon, iconSize: 30, onPressed: (() => pickImage(source))));
  }

  activateDrawing(context) {
    setState(() {
      drawing = !drawing;
    });
  }

  AnimatedContainer beforeImageSelectMenu(context) {
    return AnimatedContainer(
      width: imageFile == null ? MediaQuery.of(context).size.width : 0.0,
      duration: Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: revertAnimatedButton(
                source: ImageSource.camera,
                icon: Icon(Icons.camera),
                isVideo: false),
          ),
          Flexible(
            child: revertAnimatedButton(
                source: ImageSource.camera,
                icon: Icon(Icons.videocam),
                isVideo: true),
          ),
          Flexible(
            child: revertAnimatedButton(
                source: ImageSource.gallery,
                icon: Icon(Icons.photo_library),
                isVideo: false),
          ),
        ],
      ),
    );
  }

  AnimatedContainer afterImageSelectMenu(context) {
    return AnimatedContainer(
        width: imageFile != null ? MediaQuery.of(context).size.width : 0.0,
        duration: Duration(milliseconds: 500),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
          Flexible(
            child: animatedButton(context, cropImage, icon: Icon(Icons.crop)),
          ),
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  showColor = !showColor;
                });
              },
              child: animatedButton(context, activateDrawing,
                  icon: Icon(FontAwesomeIcons.pencilAlt,
                      color: drawing ? Colors.deepPurple : Colors.black)),
            ),
          ),
          Flexible(
              child: animatedButton(context, clear, icon: Icon(Icons.refresh))),
          Flexible(
            child: AnimatedOpacity(
              opacity: imageFile != null ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: SizedBox(), // TODO Upload image
            ),
          )
        ]));
  }

  Widget animatedBottomMenu(context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        beforeImageSelectMenu(context),
        afterImageSelectMenu(context),
      ],
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: imageFile != null ? Colors.black : Colors.white,
        bottomNavigationBar: BottomAppBar(child: animatedBottomMenu(context)),
        body: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              if (drawing == false) return;
              setState(() {
                RenderBox object = context.findRenderObject();
                Offset _localPosition =
                    object.globalToLocal(details.globalPosition);
                _points = new List.from(_points)..add(_localPosition);
              });
            },
            onPanEnd: (DragEndDetails details) {
              if (drawing == true) _points.add(null);
            },
            child: Stack(children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height - 50,
                  width: MediaQuery.of(context).size.width,
                  child: imageFile != null ? Image.file(imageFile) : null),
            ])));
  }
}
