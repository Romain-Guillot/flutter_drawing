import 'package:drawing/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';



class DrawingControlbar extends StatelessWidget {

  final Pannel pannel;

  DrawingControlbar({
    Key key,
    this.pannel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        FlatButton.icon(
          onPressed: ( ) {
            pannel.undo();
          }, 
          icon: Icon(FontAwesome.undo), 
          label: Text("Undo")
        ),
        FlatButton.icon(
          onPressed: () {
            pannel.clear();
          }, 
          icon: Icon(FontAwesome.trash), 
          label: Text("Clear")
        ),
      ],
    );
  }
}