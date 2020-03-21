import 'dart:ui' as ui;

import 'package:drawing/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class DrawingCanvas extends StatefulWidget {

  final Pannel pannel;

  DrawingCanvas({
    Key key, 
    @required this.pannel
  }) : super(key: key);
  
  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {

  Size pannelSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (_, constraints) {
          pannelSize = Size(constraints.maxWidth, constraints.maxWidth);
          return  GestureDetector(
            onPanDown: (details) {
              widget.pannel.startNewLine();
              setState(() => widget.pannel.addPoint(details.localPosition));
            },
            onPanUpdate: (details) {
              setState(() => widget.pannel.addPoint(details.localPosition));
            },
            onLongPress: () => getPannelPicture(),
            child: CustomPaint(
              size: pannelSize,
              painter: CanvasPainter(pannel: widget.pannel, size: pannelSize),
            ),
          );
        }
      ),
    );
  }

  Future<ui.Image> getPannelPicture() async {
    var recorder = ui.PictureRecorder();
    var canvas = Canvas(recorder);
    var painter = CanvasPainter(pannel: widget.pannel, size: pannelSize);
    painter.paint(canvas, pannelSize);
    var pic = recorder.endRecording();
    var img = await pic.toImage(pannelSize.width.round(), pannelSize.height.round());
    return img;
  }
}



class CanvasPainter extends CustomPainter {

  final Pannel pannel;
  final Size size;

  CanvasPainter({@required this.pannel, @required this.size}) : super();

  @override
  void paint(Canvas canvas, Size _) {
    var rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.clipRect(rect);

    canvas.drawColor(pannel.fillingColor, BlendMode.src);
    // idea : add attribute `layer index` aux operations
    var lines = pannel.drawings.where((element) => element is PencilOperation);
    for (var line in lines) {
      line.draw(canvas, pannel);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}