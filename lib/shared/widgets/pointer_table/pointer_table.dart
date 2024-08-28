import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/pointer_settings.dart';
import '../../../data/services/tuning_table_2d_controller.dart';
import 'draw_pointer_table_painter.dart';

class PointerTable extends StatefulWidget {
  const PointerTable({
    super.key,
    required this.controller,
    this.pointerSettings,
  });

  final TuningTableController controller;
  final PointerSettings? pointerSettings;
  @override
  State<PointerTable> createState() => _PointerTableState();
}

class _PointerTableState extends State<PointerTable> {
  double valueHOld = 0;
  double valueH = 0;

  double valueVOld = 0;
  double valueV = 0;

  @override
  void dispose() {
    _stopTimerLoopSmoothData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.pointerSettings == null){
      return const SizedBox();
    }
    final dataHorizontal = (widget.pointerSettings!.dataHorizontal ?? 0);
    final dataVertical = (widget.pointerSettings!.dataVertical ?? 0);
    if (valueH != dataHorizontal || valueV != dataVertical) {
      valueH = dataHorizontal;
      valueV = dataVertical;
      _startTimerLoopSmoothData();
    }

    return CustomPaint(
      painter: DrawPointerTablePainter(
        horizontalLabels: widget.controller.horizontalLabels,
        verticalLabels: widget.controller.verticalLabels,
        widthSizeBoxAlone: widget.controller.widthSizeBoxAlone,
        heightSizeBoxAlone: widget.controller.heightSizeBoxAlone,
        sizeSpace: widget.controller.sizeSpace,
        horizontalData: valueHOld,
        verticalData: valueVOld,
        isShowVerticalLine: widget.pointerSettings!.vertical,
        isShowHorizontalLine: widget.pointerSettings!.horizontal,
        isShowCircle: widget.pointerSettings!.circle,
        isShowVerticalTriangle: widget.pointerSettings!.verticalTriangle,
        isShowHorizontalTriangle: widget.pointerSettings!.horizontalTriangle,
        sortHorizontalLabels: widget.pointerSettings!.sortHorizontalLabels,
        sortVerticalLabels: widget.pointerSettings!.sortVerticalLabels,
      ),
    );
  }

  Timer? _timerLoopSmoothData;

  void _startTimerLoopSmoothData() {
    _stopTimerLoopSmoothData();
    if (_timerLoopSmoothData == null) {
      int i = 0;
      //angleShowScaleRpm = 0;
      _timerLoopSmoothData =
          Timer.periodic(const Duration(milliseconds: 10), (t) {
            i++;
            valueHOld += ((valueH - valueHOld) * 0.22); //0.03 , 0.3
            valueVOld += ((valueV - valueVOld) * 0.22); //0.03 , 0.3
            if (i == 400) {
              _stopTimerLoopSmoothData();
            }
            setState(() {});
          });
    }
  }

  void _stopTimerLoopSmoothData() {
    if (_timerLoopSmoothData != null) {
      _timerLoopSmoothData!.cancel();
      _timerLoopSmoothData = null;
    }
  }
}
