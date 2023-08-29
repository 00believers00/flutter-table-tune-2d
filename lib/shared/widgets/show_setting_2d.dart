import 'package:flutter/material.dart';
import 'package:tuning_table/data/models/point_model.dart';
import 'package:tuning_table/shared/extensions/decimal.dart';

import 'show_table_2d.dart';

class ShowSetting2D extends StatelessWidget {
  const ShowSetting2D({
    super.key,
    required this.isOpen,
    required this.width,
    required this.height,
    required this.horizontalLabels,
    required this.verticalLabels,
    required this.sizeSpace,
    required this.horizontalDecimal,
    required this.verticalDecimal,
    required this.configTunes,
    this.headerStyle,
    this.onPressedSave,
    this.onPressedCancel,
    required this.horizontalName,
    required this.verticalName,
    this.labelStyle,
  });

  final bool isOpen;
  final double width;
  final double height;
  final String horizontalName;
  final String verticalName;
  final List<double> horizontalLabels;
  final List<double> verticalLabels;
  final double sizeSpace;
  final DecimalType horizontalDecimal;
  final DecimalType verticalDecimal;
  final Map<String, TuningPointModel> configTunes;
  final TextStyle? headerStyle;
  final VoidCallback? onPressedSave;
  final VoidCallback? onPressedCancel;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    if (!isOpen) {
      return const SizedBox();
    }

    return Container(
      width: width,
      height: height,
      color: Colors.black.withOpacity(0.7),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: List.generate(verticalLabels.length + 1, (idxV) {
              return Expanded(
                child: Row(
                  children: List.generate(horizontalLabels.length + 1, (idxH) {
                    String head = TuningPointModel.head(
                      horizontal: idxH,
                      vertical: idxV,
                    );
                    final configTuneValue =
                        configTunes[head] ?? TuningPointModel.init();

                    if (idxV == 0 && idxH == 0) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: sizeSpace,
                            bottom: sizeSpace,
                          ),
                        ),
                      );
                    } else if (idxV == 0) {
                      return LabelHeaderTableTune2d(
                        data: configTuneValue,
                        sizeSpace: sizeSpace,
                        decimalType: horizontalDecimal,
                        textStyle: headerStyle,
                      );
                    } else if (idxH == 0) {
                      bool disableText = false;
                      if(verticalLabels.length == 1){
                        disableText = true;
                      }
                      return LabelHeaderTableTune2d(
                        data: configTuneValue,
                        sizeSpace: sizeSpace,
                        decimalType: verticalDecimal,
                        textStyle: headerStyle,
                        disableText: disableText,
                      );
                    }

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: sizeSpace,
                          bottom: sizeSpace,
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
          Positioned(
            left: (verticalLabels.length > 1) ? width/horizontalLabels.length:0,
            top: (verticalLabels.length > 1) ? height/verticalLabels.length: height/2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelHead(
                  horizontalName,
                  Icons.arrow_right,
                  textStyle: labelStyle,
                ),
                const SizedBox(height: 5),
                if(verticalName.isNotEmpty)
                  labelHead(
                    verticalName,
                    Icons.arrow_drop_down,
                    textStyle: labelStyle,
                  ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            bottom: verticalLabels.length != 1 ? 8 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Button(
                  title: 'CANCEL',
                  color: Colors.redAccent,
                  onPressed: onPressedCancel,
                ),
                const SizedBox(width: 10),
                _Button(
                  title: 'SAVE',
                  color: Colors.blueAccent,
                  onPressed: onPressedSave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget labelHead(String text, IconData data, {TextStyle? textStyle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black54
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon(data),
          textTitle(
            text,
            textStyle: textStyle,
          ),
        ],
      ),
    );
  }

  Widget textTitle(String text, {TextStyle? textStyle}) {
    final rawTextStyle = textStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 9,
        );
    double fontSize = rawTextStyle.fontSize ?? 0;
    return Text(
      text,
      style: rawTextStyle.copyWith(
        color: Colors.white,
        fontSize: fontSize * 2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget icon(IconData data) {
    return Icon(
      data,
      size: 28,
      color: Colors.white,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    this.onPressed,
    required this.color,
  });

  final String title;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
