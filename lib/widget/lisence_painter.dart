import 'package:flutter/material.dart';

class DocPainter extends StatefulWidget {
  DocPainter({Key? key}) : super(key: key);

  @override
  List<Offset?> _points = [];
  _DocPainterState createState() => _DocPainterState();
}

class _DocPainterState extends State<DocPainter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            RenderBox object = context.findRenderObject()! as RenderBox;
            Offset _localPosition =
                object.globalToLocal(details.globalPosition);
            // _points = List.from(_points)..add(_localPosition);
            widget._points.add(_localPosition);
          });
        },
        onPanEnd: (DragEndDetails details) => widget._points.add(null),
        child: CustomPaint(
          painter: Signature(widget._points),
          size: Size.fromHeight(MediaQuery.of(context).size.height * 0.4),
        ),
      ),
    );
  }
}

class Signature extends CustomPainter {
  List<Offset?> points;

  Signature(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  // bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
  bool shouldRepaint(Signature oldDelegate) => true;
}
