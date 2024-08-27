import 'package:flutter/material.dart';
import 'package:tuning_table/shared/extensions/size.dart';

import '../../../data/models/enum_types.dart';
import '../../utils/pointer_table_helpers.dart';

class DrawPointerTablePainter extends CustomPainter {
  final double widthSizeBoxAlone;
  final double heightSizeBoxAlone;

  final double horizontalData;
  final double verticalData;

  final List<double> horizontalLabels;
  final List<double> verticalLabels;

  final double sizeSpace;

  final bool isShowVerticalLine;
  final bool isShowHorizontalLine;
  final bool isShowCircle;
  final bool isShowHorizontalTriangle;
  final bool isShowVerticalTriangle;

  final DataSortType sortHorizontalLabels;
  final DataSortType sortVerticalLabels;

  const DrawPointerTablePainter({
    required this.horizontalData,
    required this.verticalData,
    required this.horizontalLabels,
    required this.verticalLabels,
    required this.widthSizeBoxAlone,
    required this.heightSizeBoxAlone,
    required this.sizeSpace,
    this.isShowVerticalLine = true,
    this.isShowHorizontalLine = true,
    this.isShowCircle = true,
    this.isShowHorizontalTriangle = false,
    this.isShowVerticalTriangle = false,
    this.sortHorizontalLabels = DataSortType.asc,
    this.sortVerticalLabels = DataSortType.des,
  });

  @override
  Future paint(Canvas canvas, Size size) async {
    final pointerHelps = PointerTableHelpers.shared;

    double verticalLocation = pointerHelps.callLocation(
      data: verticalData,
      sizeBoxAlone: heightSizeBoxAlone,
      sizeSpace: sizeSpace,
      labels: verticalLabels,
      sortType: sortVerticalLabels,
    );

    double horizontalLocation = pointerHelps.callLocation(
      data: horizontalData,
      sizeBoxAlone: widthSizeBoxAlone,
      sizeSpace: sizeSpace,
      labels: horizontalLabels,
      sortType: sortHorizontalLabels,
    );

    //IndependentPointer
    double pointX = widthSizeBoxAlone + horizontalLocation;
    double pointY = heightSizeBoxAlone + verticalLocation;
    Offset center = Offset(pointX, pointY);
    double radius = size.percent(3, Percent.height);

    Paint paintLine = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red.withOpacity(0.3)
      ..strokeWidth = 1;

    if (isShowHorizontalLine) {
      drawHorizontalLine(
        canvas: canvas,
        radius: radius,
        pointX: pointX,
        pointY: pointY,
        sizeEnd: size.width,
        paintLine: paintLine,
      );
    }

    if (isShowVerticalLine) {
      drawVerticalLine(
        canvas: canvas,
        radius: radius,
        pointX: pointX,
        pointY: pointY,
        sizeEnd: size.height,
        paintLine: paintLine,
      );
    }

    if (isShowCircle) {
      drawIndependentPointer(
        canvas: canvas,
        radius: radius,
        center: center,
      );
    }

    Paint paintMark = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red
      ..strokeWidth = 1;

    double heightTriangle = (heightSizeBoxAlone / 3.5);
    double widthTriangle = (widthSizeBoxAlone / 3.5);

    if (isShowHorizontalTriangle) {
      drawHorizontalTriangle(
        canvas: canvas,
        pointX: pointX,
        heightTriangle: heightTriangle,
        widthTriangle: widthTriangle,
        paintMark: paintMark,
      );
    }

    if (isShowVerticalTriangle) {
      drawVerticalTriangle(
        canvas: canvas,
        pointY: pointY,
        heightTriangle: heightTriangle,
        widthTriangle: widthTriangle,
        paintMark: paintMark,
      );
    }
  }

  void drawIndependentPointer({
    required Canvas canvas,
    required double radius,
    required Offset center,
  }) {
    //IndependentPointer
    Path path = Path();
    Paint paintCircleWhite = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1;

    Paint paintCircleBrown = paintCircleWhite
      ..color = Colors.brown.withOpacity(0.5);

    path.moveTo(center.dx, center.dy);

    Rect oval = Rect.fromCircle(center: center, radius: radius);
    path.addOval(oval);

    // Draw circle color white
    canvas.drawPath(path, paintCircleWhite);

    // Draw circle color brown
    canvas.drawPath(path, paintCircleBrown);
  }

  void drawVerticalLine({
    required Canvas canvas,
    required double radius,
    required double pointX,
    required double pointY,
    required double sizeEnd,
    required Paint paintLine,
  }) {
    double r = radius;
    if (!isShowCircle) {
      r = 0;
    }
    // line Y top
    canvas.drawLine(
      Offset(pointX, heightSizeBoxAlone),
      Offset(pointX, pointY - r),
      paintLine,
    );
    // line Y bottom
    canvas.drawLine(
      Offset(pointX, pointY + r),
      Offset(pointX, sizeEnd),
      paintLine,
    );
  }

  void drawHorizontalLine({
    required Canvas canvas,
    required double radius,
    required double pointX,
    required double pointY,
    required double sizeEnd,
    required Paint paintLine,
  }) {
    double r = radius;
    if (!isShowCircle) {
      r = 0;
    }
    // line X left
    canvas.drawLine(
      Offset(widthSizeBoxAlone, pointY),
      Offset(pointX - r, pointY),
      paintLine,
    );

    // line X right
    canvas.drawLine(
      Offset(pointX + r, pointY),
      Offset(sizeEnd, pointY),
      paintLine,
    );
  }

  void drawHorizontalTriangle({
    required Canvas canvas,
    required double pointX,
    required double heightTriangle,
    required double widthTriangle,
    required Paint paintMark,
  }) {
    // Right Triangle
    Path path = Path();
    path.addPolygon(
      [
        Offset(pointX, heightTriangle),
        Offset(pointX, 0),
        Offset(pointX + widthTriangle, 0),
      ],
      true,
    );

    canvas.drawPath(path, paintMark);

    // Left Triangle
    path = Path();

    path.addPolygon(
      [
        Offset(pointX, heightTriangle),
        Offset(pointX, 0),
        Offset(pointX - widthTriangle, 0),
      ],
      true,
    );

    canvas.drawPath(path, paintMark);
  }

  void drawVerticalTriangle({
    required Canvas canvas,
    required double pointY,
    required double heightTriangle,
    required double widthTriangle,
    required Paint paintMark,
  }) {
    // Bottom Triangle
    Path path = Path();
    path.addPolygon(
      [
        Offset(widthTriangle, pointY),
        Offset(0, pointY),
        Offset(0, pointY + widthTriangle),
      ],
      true,
    );

    canvas.drawPath(path, paintMark);

    // Top Triangle
    path = Path();

    path.addPolygon(
      [
        Offset(widthTriangle, pointY),
        Offset(0, pointY),
        Offset(0, pointY - widthTriangle),
      ],
      true,
    );

    canvas.drawPath(path, paintMark);
  }

  @override
  bool shouldRepaint(DrawPointerTablePainter oldDelegate) {
    return true;
  }
}
