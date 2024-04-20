import 'package:flutter/material.dart';
import 'package:tuning_table/tuning_table.dart';

import '../utils/table_tune_2d_helpers.dart';

class ShowTable2d extends StatelessWidget {
  const ShowTable2d({
    Key? key,
    required this.horizontalLabels,
    required this.verticalLabels,
    required this.configTunes,
    required this.horizontalName,
    required this.verticalName,
    required this.sizeSpace,
    required this.horizontalDecimal,
    required this.verticalDecimal,
    required this.valueDecimal,
    required this.valueMinMax,
    this.labelStyle,
    this.headerStyle,
    this.bodyStyle,
  }) : super(key: key);
  final List<double> horizontalLabels;
  final List<double> verticalLabels;
  final Map<String, TuningPointModel> configTunes;
  final String horizontalName;
  final String verticalName;
  final double sizeSpace;
  final DecimalType horizontalDecimal;
  final DecimalType verticalDecimal;
  final DecimalType valueDecimal;
  final TextStyle? labelStyle;
  final TextStyle? headerStyle;
  final TextStyle? bodyStyle;
  final TuningMinMax valueMinMax;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                return _LabelHeaderName(
                  horizontal: horizontalName,
                  vertical: verticalName,
                  sizeSpace: sizeSpace,
                  textStyle: labelStyle,
                );
              } else if (idxV == 0 || idxH == 0) {
                final dec = idxV == 0 ? horizontalDecimal : verticalDecimal;
                bool disableText = false;
                if (verticalLabels.length == 1 && idxH == 0) {
                  disableText = true;
                }
                return LabelHeaderTableTune2d(
                  data: configTuneValue,
                  sizeSpace: sizeSpace,
                  decimalType: dec,
                  textStyle: headerStyle,
                  disableText: disableText,
                );
              }

              return LabelBodyTableTune2d(
                data: configTuneValue,
                sizeSpace: sizeSpace,
                decimalType: valueDecimal,
                textStyle: bodyStyle,
                minMax: valueMinMax,
              );
            }),
          ),
        );
      }),
    );
  }
}

class _LabelHeaderName extends StatelessWidget {
  const _LabelHeaderName({
    Key? key,
    required this.horizontal,
    required this.vertical,
    required this.sizeSpace,
    this.textStyle,
  }) : super(key: key);
  final String horizontal;
  final String vertical;
  final double sizeSpace;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          right: sizeSpace,
          bottom: sizeSpace,
        ),
        color: const Color(0xff424143),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  textTitle(
                    horizontal,
                    textStyle: textStyle,
                  ),
                  icon(Icons.arrow_right),
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.white,
            ),
            if (vertical.isNotEmpty)
              Expanded(
                child: Row(
                  children: [
                    icon(Icons.arrow_drop_down),
                    textTitle(
                      vertical,
                      textStyle: textStyle,
                    ),
                  ],
                ),
              ),
          ],
        ),
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
    return Expanded(
      child: Text(
        text,
        style: rawTextStyle.copyWith(
          color: Colors.white,
          fontSize: (text.length <= 3) ? fontSize : fontSize * 0.85,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget icon(IconData data) {
    return Icon(
      data,
      size: 14,
      color: Colors.white,
    );
  }
}

class LabelHeaderTableTune2d extends StatelessWidget {
  const LabelHeaderTableTune2d({
    Key? key,
    required this.sizeSpace,
    required this.data,
    required this.decimalType,
    this.textStyle,
    this.disableText = false,
  }) : super(key: key);
  final TuningPointModel data;
  final double sizeSpace;
  final DecimalType decimalType;
  final TextStyle? textStyle;
  final bool disableText;

  @override
  Widget build(BuildContext context) {
    final rawTextStyle = textStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 14,
        );
    String text = (data.value ?? 0).toStringAsFixed(decimalType.decimal());
    double fontSize = rawTextStyle.fontSize ?? 0;
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          right: sizeSpace,
          bottom: sizeSpace,
        ),
        color: (data.status ?? false)
            ? const Color(0xff3382e0)
            : const Color(0xff424143),
        child: Center(
          child: Text(
            disableText ? '' : text,
            style: rawTextStyle.copyWith(
              fontSize: text.length > 4 ? fontSize * 0.9 : fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class LabelBodyTableTune2d extends StatelessWidget {
  const LabelBodyTableTune2d({
    Key? key,
    required this.data,
    required this.sizeSpace,
    required this.decimalType,
    this.textStyle,
    this.minMax = const TuningMinMax(min: -100, max: 100),
  }) : super(key: key);
  final TuningPointModel data;
  final double sizeSpace;
  final DecimalType decimalType;
  final TextStyle? textStyle;
  final TuningMinMax minMax;

  @override
  Widget build(BuildContext context) {
    bool statusPoint = data.status ?? false;
    double value = data.value ?? 0;
    final helps = FunctionTableTune2DHelpers.shared;
    final rawTextStyle = textStyle ??
        const TextStyle(
          color: Colors.white,
          fontSize: 14,
        );
    String text = value.toStringAsFixed(decimalType.decimal());
    double fontSize = rawTextStyle.fontSize ?? 0;
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
          right: sizeSpace,
          bottom: sizeSpace,
        ),
        color: statusPoint
            ? Colors.grey
            : helps.calColor(
                minMax.min,
                minMax.max,
                value,
                false,
              ),
        child: Center(
          child: Text(
            text,
            style: rawTextStyle.copyWith(
              color: statusPoint ? Colors.white : Colors.black87,
              fontSize: text.length > 4 ? fontSize * 0.9 : fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
