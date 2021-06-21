import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:sklad_uchet/service/main_bloc/bloc/main_bloc.dart';
import 'dart:ui' as ui;

class DocPainter extends StatefulWidget {
  MainBloc bloc;
  DocPainter({Key? key, required this.bloc})
      : super(
          key: key,
        );

  @override
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
            widget.bloc.points.add(_localPosition);
          });
        },
        onPanEnd: (DragEndDetails details) => widget.bloc.points.add(null),
        child: CustomPaint(
            painter: Signature(widget.bloc.points), size: Size.infinite),
      ),
    );
  }
}

class Signature extends CustomPainter {
  List<Offset?> points;

  Signature(this.points);

  @override
  Future<void> paint(Canvas canvas, Size size) async {
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

  Future<Uint8List> getImage() async {
    final recorder = ui.PictureRecorder();
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    final canvas = Canvas(
        recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(600.0, 600.0)));
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
    final picture = recorder.endRecording();
    ui.Image image = await picture.toImage(200, 200);
    final buffer = await image.toByteData(format: ui.ImageByteFormat.png);

    return buffer!.buffer.asUint8List();
  }

  @override
// bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
  bool shouldRepaint(Signature oldDelegate) => true;
}
