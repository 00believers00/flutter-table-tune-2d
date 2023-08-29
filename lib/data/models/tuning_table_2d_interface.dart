import 'package:tuning_table/data/models/enum_types.dart';

import '../../shared/extensions/decimal.dart';
import 'min_max.dart';
import 'point_model.dart';
import 'pointer_offset_model.dart';

abstract class TuningTable2DInterface {
  TuningTable2DInterface({
    required List<double> horizontalLabels,
    required List<double> verticalLabels,
  });

  Stream<UpdateType> get updateData;

  List<double> get horizontalLabels;

  List<double> get verticalLabels;

  Map<String, TuningPointModel> get data;

  TuningMinMax get horizontalMinMax;

  TuningMinMax get verticalMinMax;

  TuningMinMax get dataMinMax;

  TuningMinMax get currentMinMax;

  double get widthSizeBoxAlone;

  double get heightSizeBoxAlone;

  double get sizeSpace;

  bool get isSettingLabel;

  List<double> get dataList;

  DecimalType get valueDecimal;

  DecimalType get horizontalDecimal;

  DecimalType get verticalDecimal;

  DecimalType get currentDecimal;

  void setDataWithList(List<double> data);

  void setHorizontalLabels(List<double> labels);

  void setVerticalLabels(List<double> labels);

  void setLabels(List<double> vertical, List<double> horizontal);

  void setData(Map<String, TuningPointModel> data);

  void toggleSettingLabel();

  void clearSelectData();

  void clearLabels();

  void calculator(TuningCalculatorType type, double value);

  void interpolation(TuningAxisType type);

  void setLabelActiveAxis(TuningAxisType type);

  void setMinMax({
    TuningMinMax horizontal = const TuningMinMax(min: 0, max: 20000),
    TuningMinMax vertical = const TuningMinMax(min: 0, max: 100),
    TuningMinMax data = const TuningMinMax(min: -100, max: 100),
  });

  void setPosition(TuningPointerOffset start, TuningPointerOffset end);

  void setTableOffset(TuningPointerOffset start, TuningPointerOffset end);

  List<TuningPointerOffset> convertPosition({
    required TuningPointerOffset start,
    required TuningPointerOffset end,
  });

  void setScaleTable({
    required double width,
    required double height,
    required double sizeSpace,
  });

  void setDecimal({
    DecimalType? horizontal,
    DecimalType? vertical,
    DecimalType? value,
  });

  void refresh();
}
