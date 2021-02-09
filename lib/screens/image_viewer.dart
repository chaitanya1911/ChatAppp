import 'package:ChatApp/screens/chatScreen.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String url;
  ImageViewer({this.url});
  @override
  _ImageViewerState createState() => _ImageViewerState(url: url);
}

class _ImageViewerState extends State<ImageViewer> {
  final String url;
  _ImageViewerState({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, ChatScreen.id);
          },
        ),
      ),
      body: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: ImageZoom(url: url))),
    );
  }
}

class ImageZoom extends StatefulWidget {
  final String url;
  ImageZoom({this.url});
  @override
  _ImageZoomState createState() => _ImageZoomState(url: url);
}

class _ImageZoomState extends State<ImageZoom> {
  final String url;
  _ImageZoomState({this.url});
  @override
  Widget build(BuildContext context) {
    final transformationController = TransformationController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InteractiveViewer(
        transformationController: transformationController,
        onInteractionEnd: (details) {
          print('End');
          setState(() {
            transformationController.toScene(Offset.zero);
          });
        },
        minScale: 0.1,
        maxScale: 3,
        child: Image.network(url),
      ),
    );
  }
}
