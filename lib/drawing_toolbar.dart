import 'package:drawing/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:selectors/color_selector.dart';
import 'package:selectors/width_selector.dart';



class DrawingToolbar extends StatefulWidget {

  final Pannel pannel;

  DrawingToolbar({Key key, @required this.pannel}) : super(key: key);

  @override
  _DrawingToolbarState createState() => _DrawingToolbarState();
}

class _DrawingToolbarState extends State<DrawingToolbar> {

  List<Widget> pannels;
  List<Tab> tabs;

  @override
  void initState() {
    super.initState();
    tabs = <Tab>[
      Tab(icon: Icon(FontAwesome5Solid.pencil_alt)),
      Tab(icon: Icon(FontAwesome5Solid.eraser)),
      Tab(icon: Icon(FontAwesome5Solid.fill)),
      Tab(icon: Icon(FontAwesome5Solid.quote_right))
    ];
    pannels = <Widget>[
      PencilToolPannel(pannel: widget.pannel),
      EraserToolPannel(pannel: widget.pannel),
      FillingToolPannel(pannel: widget.pannel),
      TextToolPannel(pannel: widget.pannel)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: <Widget>[
          TabBar(
            onTap: (tabIndex) {
              switch (tabIndex) {
                case 0:
                  widget.pannel.pencilMode = PencilMode.color;
                  break;
                case 1:
                  widget.pannel.pencilMode = PencilMode.eraser;
                  break;
              }
              setState(() {}); // to rebuild the TabBarView without keep wrong state
            },
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1)
            ),
            tabs: tabs
          ),
          Expanded(
            child: TabBarView(
              key: GlobalKey(),
              children: pannels.map((widget) => SingleChildScrollView(
                child: widget,
              )).toList()
            ),
          )
        ],
      ),
    );
  }
}


class PencilToolPannel extends StatelessWidget {
  final Pannel pannel;

  PencilToolPannel({Key key, @required this.pannel}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ColorSelector(
          colors: Pannel.pencilColors,
          onSelected: (color) => pannel.pencilColor = color,
          initialColor: pannel.pencilColor,
        ),
        WidthSelector(
          widths: Pannel.pencilBrushes,
          onSelected: (width) => pannel.pencilWidth = width,
          initialWidth: pannel.pencilWidth,
        ),
      ],
    );
  }
}

class EraserToolPannel extends StatelessWidget {
  final Pannel pannel;

  EraserToolPannel({Key key, @required this.pannel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidthSelector(
      widths: Pannel.pencilBrushes,
      onSelected: (width) => pannel.eraserWidth = width,
      initialWidth: pannel.eraserWidth,
    );
  }
}

class FillingToolPannel extends StatelessWidget {
  final Pannel pannel;

  FillingToolPannel({Key key, @required this.pannel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorSelector(
      colors: Pannel.fillingColors,
      onSelected: (color) => pannel.fill(color),
      initialColor: pannel.fillingColor,
      showSelectedItem: false,
    );
  }
}

class TextToolPannel extends StatelessWidget {
  final Pannel pannel;

  TextToolPannel({Key key, @required this.pannel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Text pour essayer la \n\n\n\n\n\n\n\n\n\npolice d'écriture")
    );
  }
}