import 'package:flutter/material.dart';

import '../../data/models/pointer_offset_model.dart';

class FunctionTableTune2DHelpers {
  static final shared = FunctionTableTune2DHelpers();

  String getTuneHeader({
    required List<double> horizontalLabels,
    required List<double> verticalLabels,
    required int idxV,
    required int idxH,
  }) {
    String header = '';
    if (idxV == 0 && idxH == 0) {
      return header;
    } else if (idxV == 0) {
      int idx = idxH - 1;
      if (idx >= 0) {
        header = horizontalLabels[idx].toStringAsFixed(0);
      }
    } else if (idxH == 0) {
      int idx = idxV - 1;
      if (idx >= 0) {
        header = verticalLabels[idx].toStringAsFixed(0);
      }
    }
    return header;
  }

  Color calColor(num minValueInTable, num maxValueInTable, num valueInTable,
      bool invertColor) {
    Color vReturn = const Color.fromARGB(255, 255, 255, 255);
    const baseMinColor = 160; // 160 ค่าต่ำสุดฐานสี
    const baseMaxColor = 255; // 255 ค่าสูงสุดฐานสี
    const baseMinToMax = baseMaxColor - baseMinColor;
    num minTable = minValueInTable; // ค่าต่ำสุดของตาราง
    num maxTable = maxValueInTable; // ค่าสูงสุดของตาราง

    num lengthAllValue = minTable.abs() + maxTable.abs() + 1; // +1 for 0

    num midSimValue = (lengthAllValue - 1) / 2;
    num oneSubForeSimValue = midSimValue / 2;
    num threeSubForeSimValue = midSimValue + oneSubForeSimValue;
    num valueCal =
        valueInTable + minTable.abs(); //valueInTable คือ ค่าที่ใส่ในตาราง
    if (invertColor) {
      valueCal = lengthAllValue - valueCal;
    } //invertColor คือ กลับสี

    if (valueCal == midSimValue) {
      // console.log('-----> : ทำ  G')
      vReturn =
          const Color.fromARGB(255, baseMinColor, baseMaxColor, baseMinColor);
    } else if (valueCal < midSimValue) {
      if (valueCal == oneSubForeSimValue) {
        // console.log('-----> : ทำ  Y')
        vReturn =
            const Color.fromARGB(255, baseMaxColor, baseMaxColor, baseMinColor);
      } else if (valueCal > oneSubForeSimValue) {
        // console.log('-----> : ทำระหว่าง G to Y')
        num vCal = valueCal - oneSubForeSimValue;
        valueCal = baseMaxColor - ((vCal * baseMinToMax) / oneSubForeSimValue);
        vReturn =
            Color.fromARGB(255, valueCal.toInt(), baseMaxColor, baseMinColor);
      } else {
        // console.log('-----> : ทำระหว่าง Y to R')
        num vCal = valueCal;
        valueCal = baseMinColor + (vCal * baseMinToMax) / oneSubForeSimValue;

        vReturn =
            Color.fromARGB(255, baseMaxColor, valueCal.toInt(), baseMinColor);
      }
    } else if (valueCal > midSimValue) {
      if (valueCal == threeSubForeSimValue) {
        // console.log('-----> : ทำ  CY')
        vReturn =
            const Color.fromARGB(255, baseMinColor, baseMaxColor, baseMaxColor);
      } else if (valueCal < threeSubForeSimValue) {
        // console.log('-----> : ทำระหว่าง G to CY')
        num vCal = valueCal - midSimValue;
        valueCal = baseMinColor + (vCal * baseMinToMax) / oneSubForeSimValue;

        vReturn =
            Color.fromARGB(255, baseMinColor, baseMaxColor, valueCal.toInt());
      } else {
        // console.log('-----> : ทำระหว่าง CY to B')
        num vCal = valueCal - threeSubForeSimValue;
        valueCal = baseMaxColor - (vCal * baseMinToMax) / oneSubForeSimValue;
        vReturn =
            Color.fromARGB(255, baseMinColor, valueCal.toInt(), baseMaxColor);
      }
    }

    return vReturn;
  }

  TuningPointerOffset calPoint(Offset localPosition, double width, double height) {
    int pointX = (localPosition.dx / width) ~/ 1;
    int pointY = (localPosition.dy / height) ~/ 1;
    return TuningPointerOffset(pointX, pointY);
  }

}
