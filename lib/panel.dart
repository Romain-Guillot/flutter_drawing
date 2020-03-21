
import 'dart:ui';

import 'package:flutter/material.dart';


enum PencilMode {

  eraser,

  color,
}


class Pannel {

  static final pencilBrushes = <double>[2.0, 5.0, 10.0, 20.0];
  static final pencilDefaultBrush = 5.0;

  static final pencilColors = <Color>[Colors.black, Colors.red, Colors.blueAccent];
  static final pencilDefaultColor = Colors.black;

  static final fillingColors = <Color>[Colors.lightBlue, Colors.lightGreen, Colors.yellow];
  static final fillingDefaultColor = Colors.white;


  var drawings = <PanelDrawingOperation>[];

  var pencilColor = pencilDefaultColor;
  var pencilWidth = pencilDefaultBrush;
  var eraserWidth = pencilDefaultBrush;
  var pencilMode = PencilMode.color;

  Color get fillingColor {
    var fills = drawings.where((element) => element is FillingOperation);
    if (fills.isNotEmpty) {
      return (fills.last as FillingOperation).color;
    } else {
      return Pannel.fillingDefaultColor;
    }
  }

  undo() {
    if (drawings.isNotEmpty)
      drawings.removeLast();
  }

  clear() {
    drawings = <PanelDrawingOperation>[];
  }

  startNewLine() {
    var color = pencilMode == PencilMode.color ? pencilColor : fillingColor;
    var width = pencilMode == PencilMode.color ? pencilWidth : eraserWidth;
    var line = PencilOperation(
      color: color, 
      width: width,
      mode: pencilMode
    );
    drawings.add(line);
  }

  addPoint(Offset point) {
    if (!(drawings.last is PencilOperation)) 
      startNewLine();
    (drawings.last as PencilOperation).points.add(point);
  }

  fill(Color color) {
    var fill = FillingOperation(color: color);
    drawings.add(fill);
  }
}


abstract class PanelDrawingOperation {
  draw(Canvas canvas, Pannel pannel);
}



class PencilOperation implements PanelDrawingOperation {

  final points = <Offset>[];
  Color color;
  double width;
  PencilMode mode = PencilMode.color;

  PencilOperation({
    @required this.color,
    @required this.width,
    this.mode
  });

  @override
  draw(Canvas canvas, Pannel pannel) {
    var paint = Paint()
      ..color = mode == PencilMode.eraser ? pannel.fillingColor : color
      ..strokeWidth = width
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;
    
    if (points.isNotEmpty) {
      // we draw the first point as if the list contains only on element, the
      // for loop will "ignore" it
      canvas.drawPoints(PointMode.points, [points[0]], paint);
      for (int i = 1; i < points.length; i++) {
        canvas.drawPoints(
          PointMode.lines, 
          [points[i-1], points[i]], 
          paint
        );
      }
    }
  }
}


class FillingOperation implements PanelDrawingOperation {

  Color color;

  FillingOperation({@required this.color});

  @override
  draw(Canvas canvas, Pannel pannel) {
    canvas.drawColor(color, BlendMode.src);
  }
}
